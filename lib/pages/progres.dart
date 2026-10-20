import 'package:flutter/material.dart';
import 'package:morse_master/core/engine.dart';
import 'package:morse_master/widgets.dart';
import 'package:morse_master/pages/materi.dart';

class Progres extends StatelessWidget {
  const Progres({super.key});
  Widget stat(String t, String v) => SizedBox(width: 160, child: Card(child: Padding(padding: const EdgeInsets.all(12), child: Column(children: [Text(t), Text(v, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold))]))));
  @override
  Widget build(BuildContext context) => Column(children: [
        Wrap(children: [stat('Materi selesai', '${st.done.length}/${topics.length}'), stat('Latihan', '${st.n}'), stat('Akurasi', '${st.n == 0 ? 0 : (100 * st.ok / st.n).round()}%'), stat('Skor terakhir', '${st.last}'), stat('Skor tertinggi', '${st.best}'), stat('Karakter dikuasai', '${st.mastered.length}/36')]),
        LinearProgressIndicator(value: st.mastered.length / 36), const SizedBox(height: 12),
        const Text('Riwayat game', style: TextStyle(fontWeight: FontWeight.bold)),
        if (st.games.isEmpty) const Text('Belum ada.'),
        for (final x in st.games) Text(x),
        btn('Reset progres', () => showDialog(context: context, builder: (d) => AlertDialog(title: const Text('Reset progres?'), content: const Text('Semua progres akan dihapus.'), actions: [TextButton(onPressed: () => Navigator.pop(d), child: const Text('Batal')), TextButton(onPressed: () { st.reset(); Navigator.pop(d); Navigator.pop(context); }, child: const Text('Reset'))]))),
      ]);
}
