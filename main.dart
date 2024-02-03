// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

// import 'dart:html';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:super_easy_permissions/super_easy_permissions.dart';

import 'package:activenumber/utils/firebase_config.dart';

import 'anaekran.dart';

 String? _deviceId;
final FirebaseAuth _auth = FirebaseAuth.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;
CollectionReference users = FirebaseFirestore.instance.collection('users');
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseConfig.platformOptions);
  // await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
    
   if (Navigator.canPop(context)) {
  Navigator.pop(context);
} else {
  SystemNavigator.pop();
}
return Future<bool>.value(true);
 },
      child: MaterialApp(
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
          fontFamily: 'SanFrancisco',
        ),
        home: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: const Color.fromRGBO(40, 38, 56, 1),
          body: LoginScreen(),
          bottomNavigationBar: BottomAppBar(
              color: Colors.transparent,
              elevation: 0,
              child: Container(
                padding: EdgeInsets.all(20),
                child: Text(
                  "fastwork.az",
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              )),
        ),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isObscure = true;
  bool _isVisible = false;

  // fetchCredentials() {
  //   var username = "username";
  //   var password = "password123";
  //   return [username, password];
  // }
      anaEkran(){
    
  // Navigator.push(
  //          context,
  //          MaterialPageRoute(builder: (context) {
  //            return const AnaEkran();
  //          }),
  //        );
         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
             return const AnaEkran();
           }),);
//     if (Navigator.canPop(context)) {
//   Navigator.pop(context);
// } else {
//   SystemNavigator.pop();
// }
}

 





   Future<void> girisVar(ad,sifre) async {
    try {
      final User user = (await _auth.signInWithEmailAndPassword(
        email: ad,
        password: sifre,
      ))
          .user!;
          anaEkran();
    } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
               content: Text('Hesabınız Borcdan Bağlanmışdır'),
             ));
    }
  }

icazeStorage()async {

bool result = await SuperEasyPermissions.askPermission(Permissions.storage);
if (result) {
  // Permission is granted, do something
} else {
  icazeStorage();
}
}



     void yoxlanisGiris() async {
     
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // prefs.clear();
     if(prefs.getBool('giris') ==true){
    
    girisVar(prefs.getString('ad'),prefs.getString('sifre'));
     }
 
    
}
@override
  void initState() {
    
    icazeStorage();
    yoxlanisGiris();
    super.initState();
    initPlatformState();
    
  }
   Future<void> initPlatformState() async {
    String? deviceId;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      deviceId = await PlatformDeviceId.getDeviceId;
    } on PlatformException {
      deviceId = 'Failed to get deviceId.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _deviceId = deviceId;
      print("deviceId->$_deviceId");
    });
  }
  @override
  Widget build(BuildContext context) {
    

          void savePrefs(mail, sifre) async {
     
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('ad', mail);
      prefs.setString('sifre', sifre);
     prefs.setBool('giris', true);
     anaEkran();
    
}
  

     Future<void> _signInWithEmailAndPassword() async {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
               content: Text('Məlumatlar Yoxlanılır'),
             ));
    try {
      final User user = (await _auth.signInWithEmailAndPassword(
        email: usernameController.text,
        password: passwordController.text,
      ))
          .user!;
             Future<void> setDeviceId() {
      // CollectionReference'ı çağırarak yeni bir kullanıcı ekliyoruz.

      return users.doc(user.email)
      .set({
            'deviceId': _deviceId, // John Doe
            'uid': user.uid, // Stokes and Sons
            'ad': user.email // Stokes and Sons
          })
          .then((value) {
         
           savePrefs(usernameController.text, passwordController.text);
      
          })
          .catchError((error) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
               content: Text('Adminlə Əlaqə Saxlayın'),
             ));
          });
    }
    

         Future<void> deviceIDYoxla() {
     return users.doc(user.email)
    .get()
    .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        var data = documentSnapshot.get('deviceId');
       if (data == _deviceId) {
        savePrefs(usernameController.text, passwordController.text);
        
       } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
               content: Text('Bu Hesab Başqa Cihazda Aktivdir'),
             ));

       }
      } else {

       setDeviceId();

      }
    });
}




    deviceIDYoxla();
    } catch (e) {
     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
               content: Text(e.toString()),
             ));
    }
  }



    return SingleChildScrollView(
        reverse: true,
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 60,
              width: 200,
            ),

            // Login text Widget
            Center(
              child: Container(
                height: 200,
                width: 400,
                alignment: Alignment.center,
                child: Text(
                  "Giriş",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                  ),
                  // textAlign: TextAlign.center,
                ),
              ),
            ),

            SizedBox(
              height: 60,
              width: 10,
            ),
            // Wrong Password text
            Visibility(
              visible: _isVisible,
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              child: Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.all(10),
                child: Text(
                  "Yalnış Məlumat",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 10,
                  ),
                ),
              ),
            ),

            // Textfields for username and password fields
            Container(
              height: 140,
              width: 530,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Colors.white),
              child: Column(
                children: <Widget>[
                  TextFormField(
                    onTap: () {
                      setState(() {
                        _isVisible = false;
                      });
                    },
                    controller: usernameController, // Controller for Username
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Mail",
                        contentPadding: EdgeInsets.all(20)),
                    onEditingComplete: () => FocusScope.of(context).nextFocus(),
                  ),
                  Divider(
                    thickness: 3,
                  ),
                  TextFormField(
                    onTap: () {
                      setState(() {
                        _isVisible = false;
                      });
                    },

                    controller: passwordController, // Controller for Password
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Şifrə",
                        contentPadding: EdgeInsets.all(20),
                        // Adding the visibility icon to toggle visibility of the password field
                        suffixIcon: IconButton(
                          icon: Icon(_isObscure
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          },
                        )),
                    obscureText: _isObscure,
                  ),
                ],
              ),
            ),

            // Submit Button
            Container(
              width: 570,
              height: 70,
              padding: EdgeInsets.only(top: 20),
              child: RaisedButton(
                  color: Colors.pink,
                  child: Text("Giriş", style: TextStyle(color: Colors.white)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  onPressed: () {
                  _signInWithEmailAndPassword();
                  }),
            ),
          ],
        ));
  }
}

