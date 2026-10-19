import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:morse_master/core/engine.dart';
import 'package:morse_master/core/morse.dart';
import 'package:morse_master/widgets.dart';

class Simulasi extends StatefulWidget {
  const Simulasi({super.key});
  @override
  State<Simulasi> createState() => _SimS();
}

class _SimS extends State<Simulasi> {
  final c = TextEditingController(text: 'SOS'), g = TextEditingController();
  String w = '', msg = 'Aplikasi mengirim kata acak, kamu menebak.';
  @override
  Widget build(BuildContext context) => Column(children: [
        TextField(controller: c, decoration: const InputDecoration(border: OutlineInputBorder()), onChanged: (_) => setState(() {})),
        mono(toMorse(c.text)), lampBar(),
        Wrap(children: [btn('📡 Kirim Morse', () => morseStop(toMorse(c.text))), btn('⏸', Engine.pause), btn('▶', Engine.resume), btn('⏹', Engine.stopAll), btn('🔁 Ulangi', () => morseStop(toMorse(c.text)))]),
        Text('Kecepatan: ${st.wpm} WPM'), Slider(value: st.wpm.toDouble(), min: 5, max: 40, divisions: 35, onChanged: (v) { st.wpm = v.round(); st.save(); setState(() {}); }),
        Text('Volume'), Slider(value: st.vol, onChanged: (v) { st.vol = v; Engine.pl.setVolume(v); st.save(); setState(() {}); }),
        const Divider(), const Text('Mode Tantangan', style: TextStyle(fontWeight: FontWeight.bold)), Text(msg),
        TextField(controller: g, decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Tebakan')),
        Wrap(children: [btn('Kirim tantangan', () { w = kWords[rnd.nextInt(kWords.length)]; morseStop(toMorse(w)); }), btn('Periksa', () { if (w.isEmpty) return; final good = g.text.trim().toUpperCase() == w; st.rec(good); setState(() => msg = good ? 'Benar!' : 'Salah, katanya $w'); })]),
      ]);
}
