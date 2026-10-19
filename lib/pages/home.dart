import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:morse_master/core/engine.dart';
import 'package:morse_master/core/morse.dart';
import 'package:morse_master/widgets.dart';
import 'package:morse_master/pages/materi.dart';
import 'package:morse_master/pages/voice.dart';
import 'package:morse_master/pages/tabel.dart';
import 'package:morse_master/pages/translator.dart';
import 'package:morse_master/pages/quiz.dart';
import 'package:morse_master/pages/latihan_tulis.dart';
import 'package:morse_master/pages/simulasi.dart';
import 'package:morse_master/pages/progres.dart';
import 'package:morse_master/pages/pengaturan.dart';

class Home extends StatelessWidget {
  const Home({super.key});
  @override
  Widget build(BuildContext context) {
    final items = <(String, IconData, Widget)>[
      ('Materi', Icons.menu_book, const Pg('Materi', Materi())),
      ('Belajar Voice', Icons.record_voice_over, const Pg('Belajar dengan Voice', VoicePage())),
      ('Tabel Morse', Icons.table_chart, const Pg('Tabel Morse', Tabel())),
      ('Teks → Morse', Icons.keyboard, const Pg('Teks ke Morse', T2M())),
      ('Morse → Teks', Icons.translate, const Pg('Morse ke Teks', M2T())),
      ('Latihan Dengar', Icons.hearing, const Pg('Latihan Mendengarkan', LatDengar())),
      ('Latihan Tulis', Icons.edit, const Pg('Latihan Menulis', LatTulis())),
      ('Game', Icons.sports_esports, const Pg('Game Tebak Huruf', GamePage())),
      ('Simulasi', Icons.flashlight_on, const Pg('Simulasi Pengiriman', Simulasi())),
      ('Progres', Icons.bar_chart, const Pg('Progres Belajar', Progres())),
      ('Pengaturan', Icons.settings, const Pg('Pengaturan', Pengaturan())),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('MORSE MASTER'), backgroundColor: green, foregroundColor: Colors.white),
      body: SafeArea(
        child: ListView(padding: const EdgeInsets.all(16), children: [
          ValueListenableBuilder<bool>(valueListenable: Engine.ttsOk, builder: (_, ok, __) => ok ? const SizedBox() : Card(color: Colors.orange.shade100, child: ListTile(leading: const Icon(Icons.warning, color: Colors.deepOrange), title: const Text('Suara Bahasa Indonesia belum terpasang', style: TextStyle(color: Colors.black)), subtitle: const Text('Ketuk untuk membuka pengaturan Text-to-Speech lalu pasang data suara Indonesia.', style: TextStyle(color: Colors.black87)), onTap: openTtsSettings))),
          Row(children: [const MorseLogo(size: 64), const SizedBox(width: 12), const Expanded(child: Text('Belajar Sandi Morse dengan guru virtual dan bunyi Morse asli.', style: TextStyle(fontSize: 16)))]),
          narrBox(),
          btn('🔊 Sapa Guru Virtual', () => sayStop('Selamat datang di MORSE MASTER. Mari kita belajar Sandi Morse.')),
          GridView.count(crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 1.5, children: [
            for (final i in items) Card(elevation: 3, child: InkWell(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => i.$3)), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(i.$2, size: 30), const SizedBox(height: 4), Text(i.$1, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold))]))),
          ]),
        ]),
      ),
    );
  }
}
