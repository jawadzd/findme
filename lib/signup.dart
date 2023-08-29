import 'package:findme/login.dart';
import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// ignore: camel_case_types
class signup extends StatefulWidget {
  const signup({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _signupState createState() => _signupState();
}

// ignore: camel_case_types
class _signupState extends State<signup> {


    TextEditingController user = TextEditingController();
  TextEditingController pass = TextEditingController();
  Future register() async {
    print(user.text);
    var url = Uri.parse('http://${globals.ipadd}/findme/register.php');
    var response = await http.post(url, body: {
      "name": user.text.toString(),
      "password": pass.text.toString(),
    });
    var data = json.decode(response.body);
    if (data == null) {
      Fluttertoast.showToast(
        backgroundColor: Colors.red,
        textColor: Colors.white,
        msg: 'User already exit!',
        toastLength: Toast.LENGTH_SHORT,
      );
    } else {
      // print(data);
      Fluttertoast.showToast(
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        msg: 'Registration Successful',
        toastLength: Toast.LENGTH_SHORT,
      );
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>   login(),
        ),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("signup "),
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
                  child: Image.asset('asset/images/signup.png')),
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
              register();
              },
              child: const Text(
                'signup',
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
            ),
          ),
          const SizedBox(
            height: 80,
          ),
         
        ],
      ),
    );
  }
}
