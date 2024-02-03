import 'package:auto_animated/auto_animated.dart';
import 'package:boom_menu/boom_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

import 'package:super_easy_permissions/super_easy_permissions.dart';

var gelenNomreler = [];
var gonderilenNomreler = [1];
var prefix;
var gelenNomreString;
var kopyalanacaqNomreler;
var _bitdi = false;
const options = LiveOptions(
  // Start animation after (default zero)
  delay: Duration(milliseconds: 1),

  // Show each item through (default 250)
  showItemInterval: Duration(milliseconds: 1),

  // Animation duration (default 250)
  showItemDuration: Duration(milliseconds: 1),

  // Animations starts at 0.05 visible
  // item fraction in sight (default 0.025)
  visibleFraction: 0.025,

  // Repeat the animation of the appearance 
  // when scrolling in the opposite direction (default false)
  // To get the effect as in a showcase for ListView, set true
  reAnimateOnVisibility: false,
);
class SonAxtarilanNomreler extends StatefulWidget {
 const SonAxtarilanNomreler({ Key? key }) : super(key: key);

 @override
 _SonAxtarilanNomrelerState createState() => _SonAxtarilanNomrelerState();
}

class _SonAxtarilanNomrelerState extends State<SonAxtarilanNomreler> {
Future get _localPath async {
// Application documents directory: /data/user/0/{package_name}/{app_name}
 final applicationDirectory = await getApplicationDocumentsDirectory();

// External storage directory: /storage/emulated/0
final externalDirectory = await getExternalStorageDirectory();

// Application temporary directory: /data/user/0/{package_name}/cache
 final tempDirectory = await getTemporaryDirectory();

return externalDirectory!.path;
}

Future get _localFile async {
final path = await _localPath;

return File('$path/activenumber.vcf');
}
Future _writeToFile(String text) async {
try {
bool result = await SuperEasyPermissions.isGranted(Permissions.storage);
if (result) {
  final file = await _localFile;
// Write the file
File vcf = await file.writeAsString('$text');
 

} else {

  bool result = await SuperEasyPermissions.askPermission(Permissions.storage);
if (result) {
   final file = await _localFile;

// Write the file
File vcf = await file.writeAsString('$text');

} else {
     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
               content: Text('Yaddasa Yazmaq Üçün İcazə Verin'),
             ));
}
}
 } catch (e){
print(e.toString());
}
}
@override
 void initState() {
    gelenNomreler.clear();
    _bitdi = false;
  getSavePrefs();
    super.initState();
  }

 Future<void> share(Text) async {
   try {
     
 
    await FlutterShare.share(
      title: 'Nomrələrr',
      text: Text,
      // linkUrl: 'https://flutter.dev/',
      chooserTitle: 'Mətn olaraq paylaş'
    );
      } catch (e) {
        print(e.toString());
   }
  }


 Future<void> shareFile() async {
   try {
     
   
   final file = await _localFile;
   final fileString = file.toString();
   final pathFile = fileString.replaceAll('File: ', '');
   final temizPath = pathFile.substring(1, pathFile.length);
   final terTemizPath = temizPath.substring(0, temizPath.length - 1);

    await FlutterShare.shareFile(
      title: 'Nömrələr',
      text: 'Nömrələrin vcf faylı',
      filePath: terTemizPath,

    );
    } catch (e) {
      print(e.toString());
   }
  }


   Future<void> shareWithContact() async {
   try {
     
   
   final file = await _localFile;
   final fileString = file.toString();
   final pathFile = fileString.replaceAll('File: ', '');
   final temizPath = pathFile.substring(1, pathFile.length);
   final terTemizPath = temizPath.substring(0, temizPath.length - 1);

    await FlutterShare.shareFile(
      title: 'Nömrələr',
      text: 'Nömrələrin vcf faylı',
      filePath: terTemizPath,
      fileType: 'text/x-vcard',

    );
    } catch (e) {
      print(e.toString());
   }
  }
 @override
 Widget build(BuildContext context) {
   

   return
WillPopScope(
 onWillPop: () {
    
   if (Navigator.canPop(context)) {
  Navigator.pop(context);
} else {
  SystemNavigator.pop();
}
return Future<bool>.value(true);
 },
  child:   Scaffold(
  
  appBar: AppBar(
        
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text('Nəticələr'),
     
      ),
  
   floatingActionButton: BoomMenu(
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: const IconThemeData(size: 22.0),
        child: const Icon(Icons.add),
        backgroundColor: Colors.orange,
        onOpen: () => debugPrint('OPENING DIAL'),
        onClose: () => debugPrint('DIAL CLOSED'),
        // scrollVisible: _bitdi, 
        overlayColor: Colors.black,
        overlayOpacity: 0.7,
        children: [
          BoomMenuItem(
            child: const Icon(Icons.share, color: Colors.white),
            title: "Paylaş",
            titleStyle: const TextStyle(fontSize: 18),
            titleColor: Colors.white,
            subtitle: "Nömrələri proqram vasitəsi ilə paylaşın",
            subTitleStyle: const TextStyle(fontSize: 14),
            subTitleColor: Colors.white,
            backgroundColor: Colors.amber,
            onTap: () {
                 saveVcf(gelenNomreler);
              shareFile();
            },
          ),
          //  BoomMenuItem(
          //   child: const Icon(Icons.add_ic_call_rounded, color: Colors.white),
          //   title: "Kontakta yaz",
          //   titleStyle: const TextStyle(fontSize: 18),
          //   titleColor: Colors.white,
          //   subtitle: "Nömrələri kontakta əlavə edin",
          //   subTitleStyle: const TextStyle(fontSize: 14),
          //   subTitleColor: Colors.white,
          //   backgroundColor: Colors.amber,
          //   onTap: () {

          //   saveVcf(gelenNomreler);
          //   shareWithContact();
          //   // for (var i = 0; i < gelenNomreler.length; i++) {
          //   //   setState(() {
               
          //   //   gelenNomreString =gelenNomreString == null ? '' : gelenNomreString  + '\n BEGIN:VCARD \n VERSION:3.0 \n N:${gelenNomreler[i]};fastwork \n FN:fastwork;${gelenNomreler[i]} \n TEL;CELL:${'+994' + gelenNomreler[i].substring(1, gelenNomreler[i].length)} \n END:VCARD';
          //   //   });
          //   // }

          //   //   _writeToFile(gelenNomreString);



          //   },
          // ),

                BoomMenuItem(
            child: const Icon(Icons.share, color: Colors.white),
            title: "Mətn",
            titleStyle: const TextStyle(fontSize: 18),
            titleColor: Colors.white,
            subtitle: "Mətn olaraq paylaş",
            subTitleStyle: const TextStyle(fontSize: 14),
            subTitleColor: Colors.white,
            backgroundColor: Colors.amber,
            onTap: () {


           
            kopyalanacaqNomreler = '';


            for (var i = 0; i < gelenNomreler.length; i++) {
              setState(() {
               
              kopyalanacaqNomreler =kopyalanacaqNomreler == null ? '' : kopyalanacaqNomreler  + '\n' + gelenNomreler[i];

              });
            }
               
             share(kopyalanacaqNomreler.toString());

            //  Clipboard.setData(ClipboardData(text: kopyalanacaqNomreler))
            // 
            // ;
              
            },
          )
           
        ]
   ),
  
    
  
       
  
  
  
  
  
  
  
  
  
  
  
    body:   LiveList.options(
  
    
  
      options: options,
  
    
  
    
  
    
  
      // Like ListView.builder, but also includes animation property
  
    
  
      itemBuilder: buildAnimatedItem,
  
    
  
    
  
    
  
      // Other properties correspond to the 
  
    
  
      // `ListView.builder` / `ListView.separated` widget
  
    
  
      scrollDirection: Axis.vertical,
  
    
  
      itemCount: gelenNomreler.length,
  
    
  
    ),
  
  ),
);


 }








// Build animated item (helper for all examples)
Widget buildAnimatedItem(
  BuildContext context,
  int index,
  Animation<double> animation,
) {
  return Padding(
    padding: const EdgeInsets.only(top:8.0),
    child: FadeTransition(
      opacity: Tween<double>(
        begin: 0,
        end: 1,
      ).animate(animation),
      // And slide transition
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, -0.1),
          end: Offset.zero,
        ).animate(animation),
        // Paste you Widget
        child: 
      NumberList(index),
        
      ),
    ),
  );
}

getSavePrefs() async {
   SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String>? savedStrList = prefs.getStringList('sonaxtarilan');
      List<dynamic> strList = savedStrList!.map((i) => i.toString()).toList();
  
  setState(() {
  gelenNomreler = strList;
  });
}


saveVcf(Nomreler){
  try{

//   var vCard = VCard();
// for (var i = 0; i < Nomreler.length; i++) {
//   vCard.firstName = Nomreler[i].toString();
//   // vCard.lastName = gelenNomreler.toString();
// ///multiple cellphone
// vCard.cellPhone = Nomreler[i].toString();
// // vCard.saveToFile('/contact.vcf');
// }
var saveString = ' ';
for (var i = 0; i < Nomreler.length; i++) {
  saveString = saveString + '\nBEGIN:VCARD \nVERSION:3.0' + '\nFN;CHARSET=UTF-8:${Nomreler[i]}' + '\nN;CHARSET=UTF-8:;${Nomreler[i]};;;' + '\nNICKNAME;CHARSET=UTF-8: \n' + 'TEL;TYPE=CELL:${Nomreler[i]}' + '\nEND:VCARD';
}
// print(saveString);
// BEGIN:VCARD
// I/flutter ( 5435): VERSION:3.0
// I/flutter ( 5435): FN;CHARSET=UTF-8:0555690700
// I/flutter ( 5435): N;CHARSET=UTF-8:;0555690700;;;
// I/flutter ( 5435): NICKNAME;CHARSET=UTF-8:
// I/flutter ( 5435): TEL;TYPE=CELL:0555690700
// I/flutter ( 5435): REV:2022-01-31T17:13:59.504649
// I/flutter ( 5435): END:VCARD


// print(vCard.getFormattedString());
  _writeToFile(saveString);
  } catch(e){

   print(e.toString());
  }
}

}

Widget NumberList(index){


return
Row(
  mainAxisAlignment: MainAxisAlignment.center,
crossAxisAlignment: CrossAxisAlignment.center,
children: [

 Text(gelenNomreler[index].toString(),
 style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
 ),

],


);

}