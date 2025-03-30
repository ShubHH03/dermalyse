import 'package:flutter/material.dart';
import 'package:login_signup/screens/home_screen.dart';
import 'package:login_signup/screens/set_photo_screen.dart';
import 'package:login_signup/screens/profile.dart';

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
      home: BottomNavigation(),
    );
  }
}

class BottomNavigation extends StatefulWidget {
  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _selectedIndex = 0;

  // List of pages to navigate to
  final List<Widget> _pages = [
    HomePage(),
    AnalysisPage(),
    DoctorsPage(),
    Profile()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_services),
            label: 'Analysis',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_information),
            label: 'Doctors',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue.shade700,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

// Placeholder pages - you'll need to implement these
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HomeScreen(); // Assuming HomeScreen is your home page
  }
}

class AnalysisPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SetPhotoScreen(); // Assuming SetPhotoScreen is your analysis page
  }
}

class DoctorsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Doctors')),
      body: ListView(
        children: [
          ListTile(
            title: Text('Dr. Marcus Horizon'),
            subtitle: Text('Cardiologist'),
            trailing: Text('4.7 ★'),
          ),
          // Add more doctor listings here
        ],
      ),
    );
  }
}
