import 'package:flutter/material.dart';
import 'package:morse_master/core/morse.dart';
import 'package:morse_master/widgets.dart';

class Tabel extends StatelessWidget {
  const Tabel({super.key});
  @override
  Widget build(BuildContext context) => Column(children: [lampBar(), for (final e in kMorse.entries) ListTile(leading: Text(e.key, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)), title: mono(e.value), trailing: IconButton(icon: const Icon(Icons.volume_up), onPressed: () => morseStop(e.value)))]);
}
