// ignore_for_file: no_logic_in_create_state

import 'package:findme/login.dart';
import 'globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:launch_review/launch_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({Key? key, required this.name}) : super(key: key);
  final String name;

  @override
  State<LocationPage> createState() => _LocationPageState(name);
}

class _LocationPageState extends State<LocationPage> {
    final String name;
  _LocationPageState(this.name);

  Future<void> getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String stringValue = prefs.getString('stringValue') ?? "";

    setState(() {
      name2 = stringValue;
    });
  }

  late String name2 = "";

  removeValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("stringValue");
  }

  String? _currentAddress;
  Position? _currentPosition;

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) {
      Geolocator.openLocationSettings();
    }
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
      _getAddressFromLatLng(_currentPosition!);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
            _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
            '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future share() async {
    setState(() {
      test=1;
    });
   

    var url = Uri.parse('http://${globals.ipadd}/findme/share.php');
    http.post(url, body: {
      "name": name,
      "LAT": (_currentPosition?.latitude).toString(),
      "status":'1',
      "LNG": (_currentPosition?.longitude).toString(),
      "ADDRESS": (_currentAddress).toString(),
    });
  }
  Future stop() async{
    setState(() {
      test=0;
    });


    var url =Uri.parse('http://${globals.ipadd}/findme/stop.php');
    http.post(url,body:{
      "name":name,
      "status":'0',
    });
  }
  Timer? timer;
  int test=0;


  @override
  void initState() {
    getStringValuesSF();
    super.initState();
    if(test==1){
     timer = Timer.periodic(const Duration(seconds: 15), (Timer t) => share());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Location Page")),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'MORE',
                style: TextStyle(color: Colors.white, fontSize: 30),
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.star,
                color: Colors.black,
              ),
              title: const Text('Rate us'),
              onTap: () {
                LaunchReview.launch();
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.logout,
                color: Colors.black,
              ),
              title: const Text('log out'),
              iconColor: Colors.white,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text("LOG OUT "),
                    content: const Text("Are you sure you want to leave"),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          child: const Text("stay"),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          removeValues();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => login(),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          child: const Text("log out"),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const AboutListTile(
              icon: Icon(
                Icons.info,
                color: Colors.black,
              ),
              applicationIcon: Icon(
                Icons.attach_money,
              ),
              applicationName: "THE EXCHANGE ZONE",
              applicationVersion: '1.7.02',
              applicationLegalese: '© 2023 MobiMarTech',
              aboutBoxChildren: [],
              child: Text('About app'),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('LAT: ${_currentPosition?.latitude ?? ""}'),
              Text('LNG: ${_currentPosition?.longitude ?? ""}'),
              Text('ADDRESS: ${_currentAddress ?? ""}'),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _getCurrentPosition,
                child: const Text("Get Current Location"),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: share, child: const Text("Start sharing")),
                  ElevatedButton(
                      onPressed: stop, child: const Text('Stop sharing')),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
//  Geolocator.openLocationSettings();
