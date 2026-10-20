import 'package:flutter/material.dart';
import 'package:morse_master/core/engine.dart';
import 'package:morse_master/widgets.dart';
import 'package:morse_master/pages/home.dart';

class MorseApp extends StatelessWidget {
  const MorseApp({super.key});
  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: st,
        builder: (_, __) {
          final hc = st.contrast;
          final theme = hc
              ? ThemeData.dark(useMaterial3: true).copyWith(colorScheme: const ColorScheme.dark(primary: Colors.yellow, onPrimary: Colors.black, surface: Colors.black), scaffoldBackgroundColor: Colors.black)
              : ThemeData(useMaterial3: true, brightness: st.dark ? Brightness.dark : Brightness.light, colorScheme: ColorScheme.fromSeed(seedColor: green, secondary: gold, brightness: st.dark ? Brightness.dark : Brightness.light));
          return MaterialApp(
            title: 'MORSE MASTER', debugShowCheckedModeBanner: false, theme: theme,
            builder: (c, w) => MediaQuery(data: MediaQuery.of(c).copyWith(textScaler: TextScaler.linear(st.font)), child: w!),
            home: const Home(),
          );
        },
      );
}
