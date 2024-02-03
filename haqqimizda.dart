import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
class HaqqimizdaPage extends StatefulWidget {
  const HaqqimizdaPage({ Key? key }) : super(key: key);

  @override
  _HaqqimizdaPageState createState() => _HaqqimizdaPageState();
}

class _HaqqimizdaPageState extends State<HaqqimizdaPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: DefaultTextStyle(
  style: const TextStyle(
    fontSize: 20.0,
  ),
  child: AnimatedTextKit(
    animatedTexts: [
      WavyAnimatedText('Developer bybabek'),
      WavyAnimatedText('For You'),
    ],
    isRepeatingAnimation: true,
    onTap: () {
      print("Tap Event");
    },
  ),
),
      ),
      body: const ByBabekEynulla(),
    );
  }
}

class ByBabekEynulla extends StatefulWidget {
  const ByBabekEynulla({ Key? key }) : super(key: key);

  @override
  _ByBabekEynullaState createState() => _ByBabekEynullaState();
}

class _ByBabekEynullaState extends State<ByBabekEynulla> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
         TextLiquidFill(
           text: 'Active Number',
           waveColor: Colors.blueAccent,
           boxBackgroundColor: Colors.white,
           textStyle: const TextStyle(
             fontSize: 50.0,
             fontWeight: FontWeight.bold,
           ),
           boxHeight: 150.0,
         ),
         const Text('Bizimlə əlaqə',
         style: TextStyle(
             fontSize: 20.0,
             fontWeight: FontWeight.bold,
           ),
         ),
         ListTile(
          title: const Text('Eynulla Mərdanov'),
          subtitle: const Text('070 549 5707'),
          leading: const FaIcon(FontAwesomeIcons.whatsapp),
          onTap: () => _launchURL('https://wa.me/994705495707'),
        ),
         ListTile(
          title: const Text('Babək Teymurov'),
          subtitle: const Text('t.me/bybabek'),
          leading: const FaIcon(FontAwesomeIcons.telegram),
          onTap: () => _launchURL('https://t.me/bybabek'),
        )

        ],

        
      ),
    );
  }

  void _launchURL(_url) async {
  if (!await launch(_url)) throw 'Could not launch $_url';
}
}