import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:morse_master/core/engine.dart';
import 'package:morse_master/core/morse.dart';
import 'package:morse_master/widgets.dart';

const topics = [
  ('Pengenalan Sandi Morse', 'Sandi Morse mengubah huruf dan angka menjadi isyarat titik dan garis.', '... --- ...'),
  ('Sejarah dan kegunaan', 'Morse ditemukan sekitar tahun 1830-an untuk telegraf dan kini dipakai di pelayaran, penerbangan, dan Pramuka.', '-- --- .-. ... .'),
  ('Titik dan garis', 'Titik berdurasi satu unit, garis tiga unit. Jeda antar unsur satu unit.', '. - . -'),
  ('Memisahkan huruf dan kata', 'Antar huruf berjeda tiga unit, antar kata tujuh unit. Dalam tulisan, spasi memisahkan huruf dan garis miring memisahkan kata.', '.--. .-. .- / .--. .-. .-'),
  ('Pesan darurat SOS', 'SOS adalah tiga titik, tiga garis, lalu tiga titik.', '... --- ...'),
  ('Morse di Pramuka', 'Pramuka memakai Morse dengan peluit, bendera, atau senter untuk mengirim pesan.', '.--. .-. .- -- ..- -.- .-'),
];

class Materi extends StatefulWidget {
  const Materi({super.key});
  @override
  State<Materi> createState() => _MateriS();
}

class _MateriS extends State<Materi> {
  @override
  Widget build(BuildContext context) => Column(children: [
        lampBar(), narrBox(),
        for (var i = 0; i < topics.length; i++)
          Card(child: Padding(padding: const EdgeInsets.all(14), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('${i + 1}. ${topics[i].$1}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(topics[i].$2), mono(topics[i].$3),
            Wrap(children: [btn('🗣 Narator', () => sayStop(topics[i].$2)), btn('🔊 Morse', () => morseStop(topics[i].$3)), btn(st.done.contains(i) ? '✔ Selesai' : 'Tandai selesai', () { if (!st.done.contains(i)) st.done.add(i); st.save(); setState(() {}); })]),
          ]))),
      ]);
}
