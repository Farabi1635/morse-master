import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:morse_master/core/engine.dart';
import 'package:morse_master/core/morse.dart';
import 'package:morse_master/widgets.dart';

class Quiz extends StatefulWidget {
  final List<String> pool;
  final int wpm, len, time, maxRep;
  final String name;
  const Quiz({super.key, required this.pool, required this.wpm, this.len = 1, this.time = 0, this.maxRep = 0, required this.name});
  @override
  State<Quiz> createState() => _QuizS();
}

class _QuizS extends State<Quiz> {
  String cur = '', fb = '';
  List<String> opts = [];
  int ok = 0, no = 0, rep = 0, left = 0;
  bool ans = false, fin = false;
  Timer? tm;
  String gen() => List.generate(widget.len, (_) => widget.pool[rnd.nextInt(widget.pool.length)]).join();
  @override
  void initState() {
    super.initState();
    left = widget.time;
    if (left > 0) tm = Timer.periodic(const Duration(seconds: 1), (_) { if (fin) return; setState(() => left--); if (left <= 0) finish(); });
    next();
  }
  @override
  void dispose() { tm?.cancel(); super.dispose(); }
  Future<void> next() async {
    Engine.stopAll();
    final id = Engine.run, c = gen(), o = {c};
    while (o.length < 4) { o.add(gen()); }
    setState(() { cur = c; opts = o.toList()..shuffle(); ans = false; rep = 0; fb = ''; });
    if (widget.time == 0) await Engine.say('Dengarkan bunyi berikut, lalu pilih jawaban yang benar.');
    if (id == Engine.run && mounted && !fin) play();
  }
  void play() {
    if (widget.maxRep > 0 && rep >= widget.maxRep) { setState(() => fb = 'Batas putar ulang habis.'); return; }
    rep++;
    Engine.beep(toMorse(cur), widget.wpm);
  }
  void answer(String x) {
    if (ans) return;
    final good = x == cur;
    setState(() { ans = true; good ? ok++ : no++; fb = good ? 'Benar! 🎉' : 'Salah. $cur = ${toMorse(cur)}'; });
    st.rec(good, good ? cur : null);
    if (widget.time == 0) { Engine.stopAll(); Engine.say(good ? 'Hebat! Jawaban kamu benar.' : 'Jawaban belum tepat. Mari kita pelajari kembali.'); }
    else { Future.delayed(const Duration(milliseconds: 800), () { if (mounted && !fin) next(); }); }
  }
  void finish() {
    final sc = ok * 10 - no * 2;
    Engine.stopAll();
    st.last = sc; st.best = max(st.best, sc); st.games.insert(0, '${widget.name}: $sc'); if (st.games.length > 20) st.games.removeLast(); st.save();
    setState(() => fin = true);
  }
  @override
  Widget build(BuildContext context) {
    if (fin) return Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [Text('Selesai! Skor ${st.last}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)), Text('Benar $ok, salah $no. Skor tertinggi ${st.best}'), btn('Kembali', () => Navigator.pop(context))])));
    final acc = ok + no == 0 ? 0 : (100 * ok / (ok + no)).round();
    return Column(children: [
      Text('Benar $ok • Salah $no • Akurasi $acc%${widget.time > 0 ? ' • Waktu $left dtk' : ''}'),
      lampBar(), const SizedBox(height: 10),
      Wrap(children: [for (final o in opts) btn(o, () => answer(o))]),
      Text(fb, style: const TextStyle(fontSize: 18)),
      Wrap(children: [btn('🔊 Putar / Ulangi', play), if (widget.time == 0 && ans) btn('Soal berikutnya', next)]),
    ]);
  }
}

class LatDengar extends StatefulWidget {
  const LatDengar({super.key});
  @override
  State<LatDengar> createState() => _LDS();
}

class _LDS extends State<LatDengar> {
  int lv = 0, rep = 0;
  bool go = false;
  @override
  Widget build(BuildContext context) {
    if (go) {
      final pools = [('ETIANM'.split(''), 10, 1), (kL.split(''), 15, 1), (kAll, 25, 2)];
      final p = pools[lv];
      return Quiz(key: UniqueKey(), pool: p.$1, wpm: p.$2, len: p.$3, maxRep: rep, name: 'Latihan');
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Level'),
      SegmentedButton<int>(segments: const [ButtonSegment(value: 0, label: Text('Mudah')), ButtonSegment(value: 1, label: Text('Sedang')), ButtonSegment(value: 2, label: Text('Sulit'))], selected: {lv}, onSelectionChanged: (s) => setState(() => lv = s.first)),
      Text('Batas putar ulang: ${rep == 0 ? 'bebas' : rep}'),
      Slider(value: rep.toDouble(), min: 0, max: 5, divisions: 5, onChanged: (v) => setState(() => rep = v.round())),
      btn('Mulai', () => setState(() => go = true)),
    ]);
  }
}

class GamePage extends StatefulWidget {
  const GamePage({super.key});
  @override
  State<GamePage> createState() => _GS();
}

class _GS extends State<GamePage> {
  bool go = false;
  @override
  Widget build(BuildContext context) => go
      ? Quiz(pool: kL.split(''), wpm: 15, time: 45, name: 'Tebak Huruf')
      : Column(children: [const Text('Aturan: dengarkan bunyi Morse lalu pilih huruf yang benar. Waktu 45 detik. Benar +10, salah −2.'), btn('Mulai', () => setState(() => go = true))]);
}
