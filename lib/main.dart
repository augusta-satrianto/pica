import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pica/services/auth_service.dart';
import 'package:pica/shared/theme.dart';
import 'package:pica/ui/auth/login_page.dart';
import 'package:pica/ui/home/home_page.dart';
import 'package:pica/ui/onboarding.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Intl.defaultLocale = 'id';
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isFirstTime = prefs.getBool('isFirstTime') ?? true;
  String name = await getName();
  String kelurahanName = await getKelurahanName();
  String colorHex = await getColorHex();
  Widget startWidget;
  if (isFirstTime) {
    startWidget = const OnboardingPage();
  } else {
    String token = await getToken();
    if (token == '') {
      startWidget = const LoginPage();
    } else {
      String role = await getRole();
      startWidget = HomePage(
        role: role,
        name: name,
        kelurahanName: kelurahanName,
        colorHex: colorHex,
      );
    }
  }
  runApp(MyApp(
    startWidget: startWidget,
  ));
}

class MyApp extends StatelessWidget {
  final Widget startWidget;

  const MyApp({Key? key, required this.startWidget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      title: 'PICA',
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
      home: startWidget,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('id', 'ID'),
      ],
    );
  }
}
