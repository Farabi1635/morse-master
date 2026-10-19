import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:morse_master/core/engine.dart';
import 'package:morse_master/core/morse.dart';
import 'package:morse_master/widgets.dart';

class VoicePage extends StatefulWidget {
  const VoicePage({super.key});
  @override
  State<VoicePage> createState() => _VoiceS();
}

class _VoiceS extends State<VoicePage> {
  @override
  Widget build(BuildContext context) => Column(children: [
        DropdownButton<String>(value: st.mode, isExpanded: true, items: const [DropdownMenuItem(value: 'narator', child: Text('Mode Narator')), DropdownMenuItem(value: 'morse', child: Text('Mode Morse')), DropdownMenuItem(value: 'hybrid', child: Text('Mode Hybrid'))], onChanged: (v) { st.mode = v!; st.save(); setState(() {}); }),
        lampBar(), narrBox(),
        Wrap(children: [btn('⏸ Jeda', Engine.pause), btn('▶ Lanjut', Engine.resume), btn('⏹ Berhenti', Engine.stopAll)]),
        Wrap(spacing: 8, runSpacing: 8, children: [
          for (final c in kAll)
            SizedBox(width: 165, child: Card(child: Padding(padding: const EdgeInsets.all(8), child: Column(children: [
              Text(c, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)), mono(kMorse[c]!),
              Wrap(alignment: WrapAlignment.center, children: [
                IconButton(tooltip: 'Dengarkan Narator', icon: const Icon(Icons.record_voice_over), onPressed: () => sayStop('Huruf $c terdiri dari ${kMorse[c]!.split('').map((x) => x == '.' ? 'titik' : 'garis').join(' kemudian ')}.')),
                IconButton(tooltip: 'Putar Morse', icon: const Icon(Icons.volume_up), onPressed: () => morseStop(kMorse[c]!)),
                IconButton(tooltip: 'Lihat Animasi / Belajar', icon: const Icon(Icons.lightbulb), onPressed: () => Engine.teach(c)),
              ]),
            ]))))
        ]),
      ]);
}
