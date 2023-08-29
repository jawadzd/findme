import 'package:shared_preferences/shared_preferences.dart';

import './signup.dart';
import 'package:flutter/material.dart';
import './location_page.dart';
import 'globals.dart' as globals;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// ignore: camel_case_types
class login extends StatefulWidget {
   login({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _loginState createState() => _loginState();
}

// ignore: camel_case_types
class _loginState extends State<login> {
  
 addStringToSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('stringValue', user.text.toString());
  }

  TextEditingController user = TextEditingController();
  TextEditingController pass = TextEditingController();

  Future login() async {
    print(user.text);
    print(pass.text);

    var url = Uri.parse('http://${globals.ipadd}/findme/login.php');
    var response = await http.post(url, body: {
      "username": user.text.toString(),
      "password": pass.text.toString(),
    });

    var data = json.decode(response.body);
    if (data == 'success') {
      Fluttertoast.showToast(
        msg: 'Login Successful',
        backgroundColor: Colors.green,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
      );
      addStringToSF();

      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LocationPage(name:  user.text.toString(),) ),
        );
      
    } else {
      Fluttertoast.showToast(
        backgroundColor: Colors.green,
        textColor: Colors.white,
        msg: 'Username and password invalid',
        toastLength: Toast.LENGTH_SHORT,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Login "),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 60.0),
            child: Center(
              child: SizedBox(
                  width: 200,
                  height: 150,
                  /*decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(50.0)),*/
                  child: Image.asset('asset/images/login96.png')),
            ),
          ),
           Padding(
            //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: TextField(
                controller: user,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                  hintText: 'Enter valid email id as abc@gmail.com'),
            ),
          ),
           Padding(
            padding:
                const EdgeInsets.only(left: 15.0, right: 15.0, top: 15, bottom: 0),
            //padding: EdgeInsets.symmetric(horizontal: 15),
            child: TextField(
               controller: pass,
              obscureText: true,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                  hintText: 'Enter  password'),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            height: 50,
            width: 250,
            decoration: BoxDecoration(
                color: Colors.blue, borderRadius: BorderRadius.circular(20)),
            child: ElevatedButton(
              onPressed: () {
                login();

              },
              child: const Text(
                'Login',
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
            ),
          ),
          const SizedBox(
            height: 80,
          ),
          TextButton(
            
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) =>  signup()));
              },
              child: const Text('New User ? Create Account',
              style: TextStyle(color: Colors.black),)),
               const SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }
}
