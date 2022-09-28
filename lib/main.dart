import 'dart:io';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:login_example/dashboard_screen.dart';
import 'package:login_example/aplicacao.dart';
import 'package:login_example/campo.dart';
import 'package:login_example/cardss.dart';
import 'package:login_example/colheita.dart';
import 'package:login_example/app.dart';
import 'package:login_example/cultivar.dart';
import 'package:login_example/cultura.dart';
import 'package:login_example/insumo.dart';
import 'package:login_example/plantio.dart';
import 'package:login_example/propriedade.dart';
import 'package:login_example/relatorio.dart';
import 'package:login_example/safra.dart';
import 'package:login_example/talhao.dart';
import 'package:provider/provider.dart';
import 'dashboard_screen.dart';
import 'form_widgets.dart';
import 'login_screen.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'transition_route_observer.dart';
import 'package:window_size/window_size.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      systemNavigationBarColor:
          SystemUiOverlayStyle.dark.systemNavigationBarColor,
    ),
  );
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows) {
    // setWindowMaxSize(const Size(1024, 768));
    setWindowMinSize(const Size(960, 720));
  }
  // initializeDateFormatting('pt_BR', null);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            // Initialize the model in the builder. That way, Provider
            // can own Counter's lifecycle, making sure to call `dispose`
            // when not needed anymore.
            create: (context) => Counter()),
        ChangeNotifierProvider(create: (context) => CampoProvider()),
        ChangeNotifierProvider(create: (context) => TalhaoProvider()),
        ChangeNotifierProvider(create: (context) => SafraProvider()),
        ChangeNotifierProvider(create: (context) => Atualizar()),
        ChangeNotifierProvider(create: (context) => PropriedadProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // const scrollbarTheme = ScrollbarThemeData(showTrackOnHover: true);

    return MaterialApp(
      // theme: ThemeData.light().copyWith(scrollbarTheme: scrollbarTheme),
      // darkTheme: ThemeData.dark().copyWith(scrollbarTheme: scrollbarTheme),

      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: const [Locale('pt', 'BR')],
      title: 'Gpagri',
      // theme: ThemeData(
      //   textSelectionTheme:
      //       const TextSelectionThemeData(cursorColor: Colors.orange),
      //   // fontFamily: 'SourceSansPro',
      //   textTheme: TextTheme(
      //     headline3: const TextStyle(
      //       fontFamily: 'OpenSans',
      //       fontSize: 45.0,
      //       // fontWeight: FontWeight.w400,
      //       color: Colors.orange,
      //     ),
      //     button: const TextStyle(
      //       // OpenSans is similar to NotoSans but the uppercases look a bit better IMO
      //       fontFamily: 'OpenSans',
      //     ),
      //     caption: TextStyle(
      //       fontFamily: 'NotoSans',
      //       fontSize: 12.0,
      //       fontWeight: FontWeight.normal,
      //       color: Colors.deepPurple[300],
      //     ),
      //     headline1: const TextStyle(fontFamily: 'Quicksand'),
      //     headline2: const TextStyle(fontFamily: 'Quicksand'),
      //     headline4: const TextStyle(fontFamily: 'Quicksand'),
      //     headline5: const TextStyle(fontFamily: 'NotoSans'),
      //     headline6: const TextStyle(fontFamily: 'NotoSans'),
      //     subtitle1: const TextStyle(fontFamily: 'NotoSans'),
      //     bodyText1: const TextStyle(fontFamily: 'NotoSans'),
      //     bodyText2: const TextStyle(fontFamily: 'NotoSans'),
      //     subtitle2: const TextStyle(fontFamily: 'NotoSans'),
      //     overline: const TextStyle(fontFamily: 'NotoSans'),
      //   ),
      //   colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepPurple)
      //       .copyWith(secondary: Colors.orange),
      // ),
      navigatorObservers: [TransitionRouteObserver()],
      initialRoute: LoginScreen.routeName,
      routes: {
        LoginScreen.routeName: (context) => const LoginScreen(),
        DashboardScreen.routeName: (context) => const DashboardScreen(),
        FormWidgetsDemo.routeName: (context) => const FormWidgetsDemo(),
        // Cardss.routeName: (context) => const Cardss(),
        TelaTalhoes.routeName: (context) => const TelaTalhoes(),
        TelaCampos.routeName: (context) => const TelaCampos(),
        TelaPropriedades.routeName: (context) => const TelaPropriedades(),
        TelaCulturas.routeName: (context) => const TelaCulturas(),
        TelaCultivares.routeName: (context) => const TelaCultivares(),
        TelaInsumos.routeName: (context) => const TelaInsumos(),
        TelaPlantios.routeName: (context) => const TelaPlantios(),
        TelaColheitas.routeName: (context) => const TelaColheitas(),
        TelaAplicacoes.routeName: (context) => const TelaAplicacoes(),
        TelaSafras.routeName: (context) => const TelaSafras(),
        TelaRelatorios.routeName: (context) => const TelaRelatorios(),
        MyPDFTela.routeName: (context) => const MyPDFTela(),
      },
    );
  }
}
