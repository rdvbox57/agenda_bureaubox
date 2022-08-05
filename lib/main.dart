
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:provider/provider.dart';
import 'reservation.dart';
import 'inscription.dart';
import 'connexion.dart';
import 'accueil.dart';
import 'listeBureaux.dart';
import 'agenda.dart';
import 'bureauArguments.dart';


void main() {
 // setUrlStrategy(PathUrlStrategy());
 /* runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (_) => User())],
    child: MyApp(),
  ));

  */
 runApp(MyApp()
 //  ProviderScope(
  // child: MyApp(),
// ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
/*
      supportedLocales: [
     //  const Locale('zh'),
        const Locale('fr'),
      //  const Locale('ja'),
      ],

      locale: const Locale('fr'),
*/
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
    //    '/reservation.routeName': (context) => const ReservationScreen(),
    //    '/agenda': (context) => const AgendaScreen(),
        '/inscription': (context) => const InscriptionScreen(),
        '/connexion': (context) => const ConnexionScreen(),
        '/bureau': (context) => const listBureauxScreen(),
      },
        onGenerateRoute: (settings) {
          // If you push the PassArguments route
          if (settings.name == ReservationScreen) {
            // Cast the arguments to the correct
            // type: ScreenArguments.
            final args = settings.arguments as BureauArguments;

            // Then, extract the required data from
            // the arguments and pass the data to the
            // correct screen.
            return MaterialPageRoute(
                builder: (context) {
                  return ReservationScreen(bureauArg: args);
                }
            );
          }
          if (settings.name == AgendaScreen) {
            // Cast the arguments to the correct
            // type: ScreenArguments.
            final args = settings.arguments as BureauArguments;

            // Then, extract the required data from
            // the arguments and pass the data to the
            // correct screen.
            return MaterialPageRoute(
                builder: (context) {
                  return AgendaScreen(bureauArg: args);
                }
            );
          }
        }
    );
  }
}






