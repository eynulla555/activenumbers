import 'package:activenumber/axtaris.dart';
import 'package:activenumber/haqqimizda.dart';
import 'package:activenumber/sonaxtarilanlar.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';


class AnaEkran extends StatelessWidget {
  const AnaEkran({Key? key}) : super(key: key);
  //activenumber
//ActiveNumber2320
  // This widget is the root of your application.
  //  keytool -genkey -v -keystore D:\bybabek\activenumber.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias activenumber

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Active Number',
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
      home: const MyHomePage(title: 'Active Number'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            DelayedDisplay(
  delay: const Duration(seconds: 1),
  child: ElevatedButton(
  onPressed: () {
 Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const NomreAxtarisi()),
  );

  },
  child: const Text('Nomrə Axtarışı'),
  style: ElevatedButton.styleFrom(
    // shape: const CircleBorder(),
    // padding: const EdgeInsets.all(10),
    primary: Colors.blue, // <-- Button color
    onPrimary: Colors.red, // <-- Splash color
  ),
),
),
     DelayedDisplay(
  delay: const Duration(milliseconds: 1500),
  child: ElevatedButton(
  onPressed: () {
     Navigator.push(
           context,
           MaterialPageRoute(builder: (context) => const SonAxtarilanNomreler()),
         );

  },
  child: const Text('Son Axtarılanlar'),
  style: ElevatedButton.styleFrom(
    // shape: const CircleBorder(),
    // padding: const EdgeInsets.all(10),
    primary: Colors.blue, // <-- Button color
    onPrimary: Colors.red, // <-- Splash color
  ),
),
),
     DelayedDisplay(
  delay: const Duration(seconds: 2),
  child: ElevatedButton(
  onPressed: () {

     Navigator.push(
           context,
           MaterialPageRoute(builder: (context) => const HaqqimizdaPage()),
         );
  },
  child: const  Text('Haqqımızda'),
  style: ElevatedButton.styleFrom(
    // shape: const CircleBorder(),
    // padding: const EdgeInsets.all(20),
    primary: Colors.blue, // <-- Button color
    onPrimary: Colors.red, // <-- Splash color
  ),
),
),
           
           
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
