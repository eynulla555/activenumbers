import 'package:activenumber/response.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
 // ignore: prefer_typing_uninitialized_variables
 var temizMetn;
 var nomrelerList = [];
 var isFab = false;
 var prefix;
 final TextEditingController  textinIci =  TextEditingController();
class NomreAxtarisi extends StatefulWidget {
  const NomreAxtarisi({ Key? key }) : super(key: key);

  @override
  _NomreAxtarisiState createState() => _NomreAxtarisiState();
}

class _NomreAxtarisiState extends State<NomreAxtarisi> {

  @override
  void initState() {
    textinIci.clear();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
  
   return Scaffold(
         floatingActionButton: Visibility(
           visible: isFab,
           child: FloatingActionButton(
                 onPressed: ()  {
         
            nomrelerList.clear();
           for (var i = 0; i < temizMetn.length; i++) {
             if (temizMetn[i] != '') {
                if(temizMetn[i].length  > 8){
                 prefix = temizMetn[0].substring(temizMetn[0].length - 9, temizMetn[0].length - 7).toString();

                }
                if (temizMetn[i].length > 6) {            
               nomrelerList.add(temizMetn[i].substring(temizMetn[i].length - 7, temizMetn[i].length));
                } 
         
         
             }  
         
                  }
                  
             
            savePrefs();
             //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
             //   content: Text(prefs.getStringList('nomreler').toString()),
             // ));
                Navigator.push(
           context,
           MaterialPageRoute(builder: (context) => const ResponseList()),
         );
                 },
                 tooltip: 'Irəli',
                 child: const Icon(Icons.chevron_right),
               ),
         ),
      appBar: AppBar(
        
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text('Nömrə Axtarışı'),
     
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:  <Widget>[
              TextField(
                controller: textinIci,
                onChanged: (metn){
                nomrelerList.clear();
                 var silTire = metn.replaceAll('-', '');
                 var silMoterizeSag = silTire.replaceAll('(', '');
                 var silMoterizeSol = silMoterizeSag.replaceAll(')', '');
                 var silAra = silMoterizeSol.replaceAll(' ', '');
                 var sillString =  silAra.replaceAll( RegExp(r"\D"), "\n"); 
                 var sillSimvol =  sillString.replaceAll( RegExp(r"[^\s\w]"), ""); 
                var splitSTring = sillSimvol.split('\n');
                // print(sillSimvol);
                setState(() {
                temizMetn = splitSTring;
                metn.length > 6 ? isFab = true : isFab = false;
               
                });
                },

                textAlign: TextAlign.center,
                
                decoration: const InputDecoration(hintText: "Nömrəni Yapıştırın",
                alignLabelWithHint: true,
                ),
                scrollPadding: const EdgeInsets.all(20.0),
                keyboardType: TextInputType.multiline,
                maxLines: 99999,
                autofocus: true,)
            ],
          ),
        ),
      ),
      resizeToAvoidBottomInset: true,
    );
  }

void savePrefs() async {
  try {
        //  var prefix = temizMetn[0].substring(temizMetn[0].length - 9, temizMetn[0].length - 7).toString();
           SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> strList = nomrelerList.map((i) => i.toString()).toList();
      prefs.setStringList('nomreler', strList);
      prefs.setString('prefix', prefix);
  } catch (e) {

ScaffoldMessenger.of(context).showSnackBar(SnackBar(
               content: Text(e.toString()),
             ));

  }
      
    
}



}