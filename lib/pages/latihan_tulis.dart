import 'package:flutter/material.dart';
import 'package:morse_master/core/engine.dart';
import 'package:morse_master/core/morse.dart';
import 'package:morse_master/widgets.dart';

class LatTulis extends StatefulWidget {
  const LatTulis({super.key});
  @override
  State<LatTulis> createState() => _LTS();
}

class _LTS extends State<LatTulis> {
  final c = TextEditingController();
  String q = '', a = '', fb = '';
  @override
  void initState() { super.initState(); nw(); }
  void nw() {
    final t = rnd.nextInt(4);
    final ch = kL[rnd.nextInt(26)], w = kWords[rnd.nextInt(kWords.length)];
    setState(() {
      if (t == 0) { q = 'Tuliskan kode Morse untuk huruf $ch.'; a = kMorse[ch]!; }
      else if (t == 1) { q = 'Ubah kata $w menjadi kode Morse.'; a = toMorse(w); }
      else if (t == 2) { q = 'Terjemahkan menjadi teks: ${toMorse(w)}'; a = w; }
      else { q = 'Susun pesan SOS dengan benar.'; a = '... --- ...'; }
      c.clear(); fb = '';
    });
  }
  void check() {
    final u = c.text.trim().toUpperCase().replaceAll(RegExp(r'\s*/\s*'), ' / ').replaceAll(RegExp(r'\s+'), ' ');
    final good = u == a;
    st.rec(good);
    setState(() => fb = good ? 'Benar! 🎉' : 'Belum tepat. Jawaban: $a');
    sayStop(good ? 'Hebat! Jawaban kamu benar.' : 'Jawaban belum tepat. Mari kita pelajari kembali.');
  }
  @override
  Widget build(BuildContext context) => Column(children: [Text(q, style: const TextStyle(fontSize: 18)), const SizedBox(height: 8), TextField(controller: c, decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Jawaban')), Text(fb, style: const TextStyle(fontSize: 18)), Wrap(children: [btn('Periksa', check), btn('Soal baru', nw)])]);
}
