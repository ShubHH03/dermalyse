import 'package:flutter/material.dart';
import 'package:login_signup/screens/set_photo_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dermalyse',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NaviPage(),
    );
  }
}

class NaviPage extends StatefulWidget {
  @override
  _NaviPageState createState() => _NaviPageState();
}

class _NaviPageState extends State<NaviPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg1.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // No navigation
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(250, 100),
                      ),
                      child: Text(
                        'PROFILE',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SetPhotoScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(250, 100),
                      ),
                      child: Text(
                        'START ANALYSIS',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // No navigation
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(250, 100),
                      ),
                      child: Text(
                        'PAST RESULTS',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}