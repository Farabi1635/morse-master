import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'morse.dart';

class St extends ChangeNotifier {
  bool narator = true, morseOn = true, dark = false, contrast = false;
  String mode = 'hybrid', voice = '';
  double vol = .6, rate = 1, font = 1;
  int wpm = 15, n = 0, ok = 0, last = 0, best = 0;
  List<int> done = [];
  Set<String> mastered = {};
  List<String> games = [];
  SharedPreferences? sp;

  Future<void> load() async {
    sp = await SharedPreferences.getInstance();
    Map<String, dynamic> j = {};
    try { j = jsonDecode(sp!.getString('s') ?? '{}') as Map<String, dynamic>; } catch (_) {}
    narator = j['narator'] ?? true; morseOn = j['morseOn'] ?? true; dark = j['dark'] ?? false; contrast = j['contrast'] ?? false;
    mode = j['mode'] ?? 'hybrid'; voice = j['voice'] ?? '';
    vol = (j['vol'] ?? .6).toDouble(); rate = (j['rate'] ?? 1).toDouble(); font = (j['font'] ?? 1).toDouble();
    wpm = j['wpm'] ?? 15; n = j['n'] ?? 0; ok = j['ok'] ?? 0; last = j['last'] ?? 0; best = j['best'] ?? 0;
    done = List<int>.from(j['done'] ?? []); mastered = Set<String>.from(j['mastered'] ?? []); games = List<String>.from(j['games'] ?? []);
  }

  void save() => sp?.setString('s', jsonEncode({'narator': narator, 'morseOn': morseOn, 'dark': dark, 'contrast': contrast, 'mode': mode, 'voice': voice, 'vol': vol, 'rate': rate, 'font': font, 'wpm': wpm, 'n': n, 'ok': ok, 'last': last, 'best': best, 'done': done, 'mastered': mastered.toList(), 'games': games}));
  void apply() { save(); notifyListeners(); }
  void rec(bool good, [String? ch]) { n++; if (good) { ok++; if (ch != null) mastered.addAll(ch.split('')); } save(); }
  void reset() { n = 0; ok = 0; last = 0; best = 0; done = []; mastered = {}; games = []; apply(); }
}

final st = St();

class Engine {
  static final tts = FlutterTts();
  static final pl = AudioPlayer();
  static int run = 0;
  static final ttsOk = ValueNotifier<bool>(true);
  static bool _dead = false;
  static final lamp = ValueNotifier<bool>(false), prog = ValueNotifier<double>(0);
  static final narr = ValueNotifier<(String, int, int)>(('', 0, 0));
  static Completer<void>? _c, _pc;
  static Timer? _t;
  static final _sw = Stopwatch();
  static List<(double, double)> _seg = [];
  static double _tot = 1;
  static String _cur = '';
  static int _base = 0, _pos = 0;
  static bool _paused = false;

  static Future<void> init() async {
    try { pl.onPlayerComplete.listen((_) => _end()); } catch (_) {}
    try {
      const to = Duration(seconds: 5);
      await tts.setLanguage('id-ID').timeout(to);
      await tts.awaitSpeakCompletion(true).timeout(to);
      tts.setProgressHandler((t, s, e, w) { _pos = _base + s; narr.value = (_cur, _base + s, _base + e); });
      final r = await tts.isLanguageAvailable('id-ID').timeout(to);
      ttsOk.value = r == true || r == 1;
      await applyVoice();
    } catch (e) {
      ttsOk.value = false;
      if (e is TimeoutException) _dead = true;
    }
  }

  static Future<void> applyVoice() async {
    if (st.voice.contains('|')) { final p = st.voice.split('|'); try { await tts.setVoice({'name': p[0], 'locale': p[1]}); } catch (_) {} }
  }

  static Future<void> say(String t) async {
    final id = run;
    _cur = t; _base = 0; _pos = 0; narr.value = (t, 0, 0);
    if (!st.narator || _dead) return;
    try {
      await tts.setSpeechRate((0.5 * st.rate).clamp(0.1, 1.0));
      while (true) {
        await tts.speak(t.substring(_base)).timeout(const Duration(seconds: 40));
        if (!_paused || id != run) break;
        _pc = Completer<void>();
        await _pc!.future;
        if (id != run) break;
      }
    } catch (_) {}
  }

  static Future<void> beep(String code, [int? w]) async {
    if (!st.morseOn) return;
    await stopMorse();
    final u = 1.2 / (w ?? st.wpm);
    const sr = 22050;
    var t = .15;
    final seg = <(double, double)>[];
    for (final ch in code.split('')) {
      if (ch == '.' || ch == '-') { final d = (ch == '.' ? 1 : 3) * u; seg.add((t, t + d)); t += d + u; }
      else if (ch == ' ' || ch == '/') { t += 2 * u; }
    }
    final n = (t * sr).round();
    final bd = ByteData(44 + n * 2);
    void s(int o, String x) { for (var i = 0; i < x.length; i++) { bd.setUint8(o + i, x.codeUnitAt(i)); } }
    s(0, 'RIFF'); bd.setUint32(4, 36 + n * 2, Endian.little); s(8, 'WAVEfmt ');
    bd.setUint32(16, 16, Endian.little); bd.setUint16(20, 1, Endian.little); bd.setUint16(22, 1, Endian.little);
    bd.setUint32(24, sr, Endian.little); bd.setUint32(28, sr * 2, Endian.little); bd.setUint16(32, 2, Endian.little); bd.setUint16(34, 16, Endian.little);
    s(36, 'data'); bd.setUint32(40, n * 2, Endian.little);
    for (final g in seg) {
      final a = (g.$1 * sr).round(), b = (g.$2 * sr).round();
      for (var i = a; i < b && i < n; i++) {
        final x = i / sr;
        var e = 1.0;
        if (x - g.$1 < .006) e = (x - g.$1) / .006;
        if (g.$2 - x < .006) e = min(e, (g.$2 - x) / .006);
        bd.setInt16(44 + i * 2, (sin(2 * pi * 650 * x) * e * 30000).round(), Endian.little);
      }
    }
    _seg = seg; _tot = t; _c = Completer<void>(); prog.value = 0;
    await pl.setVolume(st.vol);
    await pl.play(BytesSource(bd.buffer.asUint8List()));
    _sw..reset()..start();
    _t = Timer.periodic(const Duration(milliseconds: 15), (_) {
      final p = _sw.elapsedMilliseconds / 1000;
      lamp.value = _seg.any((g) => p >= g.$1 && p < g.$2);
      prog.value = (p / _tot).clamp(0.0, 1.0);
      if (p > _tot + .15) _end();
    });
    await _c!.future;
  }

  static void _end() { _t?.cancel(); _sw.stop(); lamp.value = false; if (_c != null && !_c!.isCompleted) _c!.complete(); }
  static Future<void> stopMorse() async { await pl.stop(); _end(); }
  static void pause() { _paused = true; pl.pause(); _sw.stop(); tts.stop(); }
  static void resume() {
    if (!_paused) return;
    _paused = false; _base = _pos; pl.resume();
    if (_c != null && !_c!.isCompleted) _sw.start();
    if (_pc != null && !_pc!.isCompleted) _pc!.complete();
  }
  static void stopAll() { run++; _paused = false; if (_pc != null && !_pc!.isCompleted) _pc!.complete(); tts.stop(); stopMorse(); }

  static Future<void> teach(String ch) async {
    stopAll();
    final id = run;
    st.mastered.add(ch); st.save();
    final c = kMorse[ch]!;
    final d = c.split('').map((x) => x == '.' ? 'titik' : 'garis').join(' kemudian ');
    if (st.mode != 'morse') { await say('Sekarang kita belajar $ch.${st.mode == 'hybrid' ? ' Dengarkan kode Morse-nya.' : ''}'); if (id != run) return; }
    if (st.mode != 'narator') { await beep(c); if (id != run) return; }
    if (st.mode != 'morse') await say('Huruf $ch terdiri dari $d.');
  }
}
