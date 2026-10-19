import 'dart:async';
import 'package:flutter/material.dart';
import 'package:morse_master/app.dart';
import 'package:morse_master/core/engine.dart';

Future<void> main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    ErrorWidget.builder = (d) => Directionality(textDirection: TextDirection.ltr, child: Material(child: Padding(padding: const EdgeInsets.all(16), child: SingleChildScrollView(child: Text('Terjadi kesalahan:\n${d.exceptionAsString()}')))));
    try { await st.load().timeout(const Duration(seconds: 3)); } catch (_) {}
    runApp(const MorseApp());
    unawaited(Engine.init()); // tidak ditunggu agar aplikasi langsung tampil
  }, (e, s) => debugPrint('Error: $e'));
}
