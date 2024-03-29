import 'package:flutter/material.dart';
import 'package:pica/shared/theme.dart';
import 'package:pica/ui/check_auth.dart';
import 'package:intl/intl.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  Intl.defaultLocale = 'id';
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xFF186968),
          titleTextStyle: poppins.copyWith(
              fontWeight: semiBold, fontSize: 18, color: Colors.white),
          elevation: 0,
          toolbarHeight: 70,
          titleSpacing: 0,
          iconTheme: IconThemeData(color: neutral600),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        textSelectionTheme: const TextSelectionThemeData(
            cursorColor: Color(0xFF186968),
            selectionColor: Color(0xFF186968),
            selectionHandleColor: Color(0xFF186968)),
        useMaterial3: true,
      ),
      localizationsDelegates: const [
        // ...delegasi lokal lainnya
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('id', 'ID'),
      ],
      home: const CheckAuth(),
    );
  }
}
