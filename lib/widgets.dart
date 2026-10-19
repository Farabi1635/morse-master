import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:morse_master/core/engine.dart';
import 'package:morse_master/core/morse.dart';
import 'dart:io';
import 'package:android_intent_plus/android_intent.dart';

const gold = Color(0xFFE0A800), green = Color(0xFF1F4D2B);

final rnd = Random();

void openTtsSettings() {
  if (!Platform.isAndroid) return;
  try { const AndroidIntent(action: 'com.android.settings.TTS_SETTINGS').launch(); } catch (_) {}
}

Widget lampBar() => Column(children: [
      ValueListenableBuilder<bool>(valueListenable: Engine.lamp, builder: (_, v, __) => AnimatedContainer(duration: const Duration(milliseconds: 30), width: 70, height: 70, decoration: BoxDecoration(shape: BoxShape.circle, color: v ? gold : Colors.grey.shade700, boxShadow: v ? [const BoxShadow(color: gold, blurRadius: 30, spreadRadius: 8)] : []))),
      const SizedBox(height: 10),
      ValueListenableBuilder<double>(valueListenable: Engine.prog, builder: (_, v, __) => LinearProgressIndicator(value: v)),
    ]);

Widget narrBox() => ValueListenableBuilder<(String, int, int)>(
      valueListenable: Engine.narr,
      builder: (_, v, __) {
        final t = v.$1, s = v.$2.clamp(0, t.length), e = v.$3.clamp(s, t.length);
        return Container(
          width: double.infinity, padding: const EdgeInsets.all(10), margin: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(color: gold.withOpacity(.2), borderRadius: BorderRadius.circular(8)),
          child: Text.rich(TextSpan(children: [TextSpan(text: t.substring(0, s)), TextSpan(text: t.substring(s, e), style: const TextStyle(backgroundColor: Color(0x99E0A800), fontWeight: FontWeight.bold)), TextSpan(text: t.substring(e))])),
        );
      },
    );

Widget btn(String t, VoidCallback f) => Padding(padding: const EdgeInsets.all(3), child: FilledButton(onPressed: f, style: FilledButton.styleFrom(minimumSize: const Size(48, 48)), child: Text(t)));

Widget mono(String t) => SelectableText(t, style: const TextStyle(fontFamily: 'monospace', fontSize: 22));

Future<void> sayStop(String t) async { Engine.stopAll(); await Engine.say(t); }

void morseStop(String c, [int? w]) { Engine.stopAll(); Engine.beep(c, w); }

class Pg extends StatefulWidget {
  final String t;
  final Widget c;
  const Pg(this.t, this.c, {super.key});
  @override
  State<Pg> createState() => _PgS();
}

class _PgS extends State<Pg> {
  @override
  void dispose() { Engine.stopAll(); super.dispose(); }
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(widget.t), actions: [IconButton(icon: const Icon(Icons.stop_circle), tooltip: 'Stop semua suara', onPressed: Engine.stopAll)]),
        body: SafeArea(child: ListView(padding: const EdgeInsets.all(16), children: [widget.c])),
      );
}

class MorseLogo extends StatelessWidget {
  final double size;
  const MorseLogo({super.key, this.size = 72});
  @override
  Widget build(BuildContext context) {
    Widget dot() => Container(width: size * .15, height: size * .15, decoration: const BoxDecoration(color: gold, shape: BoxShape.circle));
    Widget dash() => Container(width: size * .2, height: size * .15, decoration: BoxDecoration(color: gold, borderRadius: BorderRadius.circular(size)));
    Widget row(Widget Function() w) => Row(mainAxisSize: MainAxisSize.min, children: [w(), SizedBox(width: size * .07), w(), SizedBox(width: size * .07), w()]);
    return Container(
      width: size, height: size,
      decoration: BoxDecoration(color: green, borderRadius: BorderRadius.circular(size * .22), border: Border.all(color: gold, width: size * .035)),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [row(dot), SizedBox(height: size * .08), row(dash), SizedBox(height: size * .08), row(dot)]),
    );
  }
}
