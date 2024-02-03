import 'dart:io';

import 'package:auto_animated/auto_animated.dart';
import 'package:boom_menu/boom_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:super_easy_permissions/super_easy_permissions.dart';
import 'package:vcard_maintained/vcard_maintained.dart';

import 'anaekran.dart';

var gonderilenNomreler = [1];
var gelenNomreler = [];
var prefix;
var gelenNomreString;
var kopyalanacaqNomreler;
var _bitdi = false;

const options = LiveOptions(
  // Start animation after (default zero)
  delay: Duration(seconds: 1),

  // Show each item through (default 250)
  showItemInterval: Duration(milliseconds: 500),

  // Animation duration (default 250)
  showItemDuration: Duration(seconds: 1),

  // Animations starts at 0.05 visible
  // item fraction in sight (default 0.025)
  visibleFraction: 0.05,

  // Repeat the animation of the appearance 
  // when scrolling in the opposite direction (default false)
  // To get the effect as in a showcase for ListView, set true
  reAnimateOnVisibility: false,
);
class ResponseList extends StatefulWidget {
 const ResponseList({ Key? key }) : super(key: key);

 @override
 _ResponseListState createState() => _ResponseListState();
}

class _ResponseListState extends State<ResponseList> {
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
    restApi(1, 0);
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
    
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
             return const AnaEkran();
           }),);
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
        scrollVisible: _bitdi, 
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
  
    
  
       
  
  
  
  
  
  
  
  
  
  
  
    body: 
    LiveList.options(
  
    
  
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





restApi(api, index) {
 print(gonderilenNomreler.toString() + 'baslayacaqda');
if (api == 1){
  if (prefix == '50') {
      restApi(2, 0);
  }  else {
  
 nolElli() async {
   try {
     
  
     final response = await http.get(Uri.parse(
        'https://hesab.az/api/pg/unregistered/merchants/azercell/billingInfo/?prefix=50&number='+ gonderilenNomreler[index].toString()));
setState(() {
    
    if (response.statusCode == 200) {
      gelenNomreler.add('050' + gonderilenNomreler[index].toString());
    } 
    if (index + 1 == gonderilenNomreler.length) {
      restApi(2, 0);
    } else {
        
        restApi(1, index + 1);
    }
    
  
});

   } catch (e) {
     print(e.toString());
   }
}
  
  nolElli();
  }
}

if (api == 2){
if (prefix == '51') {
      restApi(3, 0);
  }  else {
 nolElliBir() async {
   try {
     
  
     final response = await http.get(Uri.parse(
        'https://hesab.az/api/pg/unregistered/merchants/azercell/billingInfo/?prefix=51&number='+ gonderilenNomreler[index].toString()));
setState(() {
    
    if (response.statusCode == 200) {
      gelenNomreler.add('051' + gonderilenNomreler[index].toString());
    } 
    if (index + 1 == gonderilenNomreler.length) {
      restApi(3, 0);
    } else {
        
        restApi(2, index + 1);
    }
    
  
});

   } catch (e) {
     print(e.toString());
   }
}
  nolElliBir();
  }
}


if (api == 3){
  if (prefix == '10') {
      restApi(4, 0);
  }  else {
nolOn() async {
   try {
     
  
     final response = await http.get(Uri.parse(
        'https://hesab.az/api/pg/unregistered/merchants/azercell/billingInfo/?prefix=10&number='+ gonderilenNomreler[index].toString()));
setState(() {
    
    if (response.statusCode == 200) {
      gelenNomreler.add('010' + gonderilenNomreler[index].toString());
    } 
    if (index + 1 == gonderilenNomreler.length) {
      restApi(4, 0);
    } else {
        
        restApi(3, index + 1);
    }
    
  
});

   } catch (e) {
     print(e.toString());
   }
}
  nolOn();
  }
}

if (api == 4) {
  if (prefix == '70') {
      restApi(5, 0);
  }  else {
nolYetmis() async {
   try {
     
  
     final response = await http.get(Uri.parse(
        'https://hesab.az/api/pg/unregistered/merchants/nar/billingInfo/?payment_type=phone&prefix=70&number='+ gonderilenNomreler[index].toString()));
setState(() {
    
    if (response.statusCode == 200) {
      gelenNomreler.add('070' + gonderilenNomreler[index].toString());
    } 
    if (index + 1 == gonderilenNomreler.length) {
      restApi(5, 0);
    } else {
        
        restApi(4, index + 1);
    }
    
  
});

   } catch (e) {
     print(e.toString());
   }
}
  nolYetmis();
  }
}


if (api == 5) {
  if (prefix == '77') {
      restApi(6, 0);
  }  else {
  nolYetmisYeddi() async {
   try {
     
  
     final response = await http.get(Uri.parse(
        'https://hesab.az/api/pg/unregistered/merchants/nar/billingInfo/?payment_type=phone&prefix=77&number='+ gonderilenNomreler[index].toString()));
setState(() {
    
    if (response.statusCode == 200) {
      gelenNomreler.add('077' + gonderilenNomreler[index].toString());
    } 
    if (index + 1 == gonderilenNomreler.length) {
      restApi(6, 0);
    } else {
        
        restApi(5, index + 1);
    }
    
  
});

   } catch (e) {
     print(e.toString());
   }
}
  nolYetmisYeddi();
  }
}

if (api == 6) {
  
if (prefix == '55') {
      restApi(7, 0);
  }  else {
nolElliBes() async {
   try {
     
  
     final response = await http.get(Uri.parse(
        'https://hesab.az/api/pg/unregistered/merchants/bakcell/billingInfo/?prefix=55&number='+ gonderilenNomreler[index].toString()));
setState(() {
    
    if (response.statusCode == 200) {
      gelenNomreler.add('055' + gonderilenNomreler[index].toString());
    } 
    if (index + 1 == gonderilenNomreler.length) {
      restApi(7, 0);
    } else {
        
        restApi(6, index + 1);
    }
    
  
});

   } catch (e) {
     print(e.toString());
   }
}
  nolElliBes();
  }

}

if (api == 7) {
  if (prefix == '99') {
      bitdi();
  }  else {

  nolDoxsanDoqquz() async {
   try {
     
  
     final response = await http.get(Uri.parse(
        'https://hesab.az/api/pg/unregistered/merchants/bakcell/billingInfo/?prefix=99&number='+ gonderilenNomreler[index].toString()));
setState(() {
    
    if (response.statusCode == 200) {
      gelenNomreler.add('099' + gonderilenNomreler[index].toString());
    } 
    if (index + 1 == gonderilenNomreler.length) {
              bitdi();

    } else {
        
        restApi(7, index + 1);
    }
    
  
});

   } catch (e) {
     print(e.toString());
   }
}
  nolDoxsanDoqquz();

  }
}





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
  try {
     SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String>? savedStrList = prefs.getStringList('nomreler');
  String? getprefix = prefs.getString('prefix');
  List<int> gonderilecekNomreler = savedStrList!.map((i) => int.parse(i)).toList();
  setState(() {
    gonderilenNomreler = gonderilecekNomreler;
    prefix = getprefix;
  });
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
               content: Text(e.toString()),
             ));
  }
  
}
bitdi() async{
  setState(() {
    _bitdi = true;
  });
  SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> stringList = gelenNomreler.map((i) => i.toString()).toList();

 prefs.setStringList('sonaxtarilan', stringList);
  
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

 Text(gelenNomreler[index] ?? '',
 style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
 ),

],


);

}