import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:morse_master/core/engine.dart';
import 'package:morse_master/core/morse.dart';
import 'package:morse_master/widgets.dart';

class Pengaturan extends StatelessWidget {
  const Pengaturan({super.key});
  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: st,
        builder: (_, __) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SwitchListTile(title: const Text('Narator aktif'), value: st.narator, onChanged: (v) { st.narator = v; st.apply(); }),
          SwitchListTile(title: const Text('Audio Morse aktif'), value: st.morseOn, onChanged: (v) { st.morseOn = v; st.apply(); }),
          DropdownButton<String>(value: st.mode, isExpanded: true, items: const [DropdownMenuItem(value: 'narator', child: Text('Mode Narator')), DropdownMenuItem(value: 'morse', child: Text('Mode Morse')), DropdownMenuItem(value: 'hybrid', child: Text('Mode Hybrid'))], onChanged: (v) { st.mode = v!; st.apply(); }),
          Text('Volume Morse'), Slider(value: st.vol, onChanged: (v) { st.vol = v; st.apply(); }),
          Text('Kecepatan Morse: ${st.wpm} WPM'), Slider(value: st.wpm.toDouble(), min: 5, max: 40, divisions: 35, onChanged: (v) { st.wpm = v.round(); st.apply(); }),
          Text('Kecepatan narator: ${st.rate.toStringAsFixed(1)}x'), Slider(value: st.rate, min: .5, max: 2, divisions: 15, onChanged: (v) { st.rate = v; st.apply(); }),
          Text('Ukuran teks: ${(st.font * 100).round()}%'), Slider(value: st.font, min: .8, max: 1.6, divisions: 8, onChanged: (v) { st.font = v; st.apply(); }),
          SwitchListTile(title: const Text('Mode gelap'), value: st.dark, onChanged: (v) { st.dark = v; st.apply(); }),
          SwitchListTile(title: const Text('Kontras tinggi'), value: st.contrast, onChanged: (v) { st.contrast = v; st.apply(); }),
          const Divider(),
          ValueListenableBuilder<bool>(valueListenable: Engine.ttsOk, builder: (_, ok, __) => Text(ok ? 'Suara Bahasa Indonesia tersedia.' : 'Suara Indonesia belum terpasang di perangkat ini.')),
          FutureBuilder<dynamic>(
            future: Engine.tts.getVoices,
            builder: (_, s) {
              final vs = (s.data is List ? s.data as List : []).where((v) => v is Map && '${v['locale']}'.toLowerCase().startsWith('id')).toList();
              if (vs.isEmpty) return const SizedBox();
              final keys = vs.map((v) => '${v['name']}|${v['locale']}').toList();
              return DropdownButton<String>(value: keys.contains(st.voice) ? st.voice : null, hint: const Text('Pilih suara Indonesia'), isExpanded: true, items: [for (final k in keys) DropdownMenuItem(value: k, child: Text(k.split('|')[0]))], onChanged: (v) { st.voice = v!; st.apply(); Engine.applyVoice(); });
            },
          ),
          Wrap(children: [btn('Pasang / atur suara', openTtsSettings), btn('Tes narator', () => sayStop('Selamat datang di MORSE MASTER. Mari kita belajar Sandi Morse.')), btn('Tes Morse', () => morseStop('... --- ...'))]),
          const Text('Kualitas suara narator bergantung pada mesin text-to-speech di perangkat.'),
        ]),
      );
}
