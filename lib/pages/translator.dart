import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:morse_master/core/engine.dart';
import 'package:morse_master/core/morse.dart';
import 'package:morse_master/widgets.dart';

class T2M extends StatefulWidget {
  const T2M({super.key});
  @override
  State<T2M> createState() => _T2MS();
}

class _T2MS extends State<T2M> {
  final c = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final o = toMorse(c.text);
    return Column(children: [
      TextField(controller: c, minLines: 2, maxLines: 4, decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Ketik teks, mis. PRAMUKA'), onChanged: (_) => setState(() {})),
      const SizedBox(height: 10), mono(o), lampBar(),
      Wrap(children: [btn('Salin', () => Clipboard.setData(ClipboardData(text: o))), btn('🔊 Putar', () => morseStop(o)), btn('⏹', Engine.stopAll)]),
    ]);
  }
}

class M2T extends StatefulWidget {
  const M2T({super.key});
  @override
  State<M2T> createState() => _M2TS();
}

class _M2TS extends State<M2T> {
  final c = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final r = fromMorse(c.text);
    return Column(children: [
      TextField(controller: c, minLines: 2, maxLines: 4, decoration: const InputDecoration(border: OutlineInputBorder(), hintText: '.--. .-. .- / ...'), onChanged: (_) => setState(() {})),
      const SizedBox(height: 10), mono(r.text),
      if (r.bad.isNotEmpty) Text('Kode tidak dikenal: ${r.bad.join(' ')}', style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
      Wrap(children: [btn('Salin', () => Clipboard.setData(ClipboardData(text: r.text))), btn('Hapus', () => setState(c.clear))]),
    ]);
  }
}
