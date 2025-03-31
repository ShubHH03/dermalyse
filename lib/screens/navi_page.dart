import 'package:flutter/material.dart';
import 'package:login_signup/screens/home_screen.dart';
import 'package:login_signup/screens/set_photo_screen.dart';
import 'package:login_signup/screens/profile.dart';
import 'package:login_signup/screens/doctors.dart';
import 'package:login_signup/screens/patients.dart';

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
  final String userRole; // Add user role parameter

  // Constructor with default value for backward compatibility
  BottomNavigation({this.userRole = 'Patient'});

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _selectedIndex = 0;
  late List<Widget> _pages;
  late List<BottomNavigationBarItem> _navigationItems;

  @override
  void initState() {
    super.initState();
    _initializeNavigation();
  }

  // Initialize navigation based on user role
  void _initializeNavigation() {
    if (widget.userRole == 'Doctor') {
      // Doctor navigation
      _pages = [
        HomePage(),
        AnalysisPage(),
        PatientsPage(),
        Profile()
      ];
      
      _navigationItems = [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.medical_services),
          label: 'Analysis',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people),
          label: 'Patients',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ];
    } else {
      // Patient navigation
      _pages = [
        HomePage(),
        AnalysisPage(),
        DoctorsPage(),
        Profile()
      ];
      
      _navigationItems = [
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
      ];
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Dermalyse'),
      // ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: _navigationItems,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue.shade700,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

// Placeholder pages
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