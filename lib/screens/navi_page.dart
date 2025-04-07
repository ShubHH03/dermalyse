import 'package:flutter/material.dart';
import 'package:login_signup/screens/home_screen.dart';
import 'package:login_signup/screens/doctor_analysis.dart';
import 'package:login_signup/screens/patients_analysis.dart';
import 'package:login_signup/screens/patients.dart';
import 'package:login_signup/screens/doctors.dart';
import 'package:login_signup/screens/profile.dart';

class BottomNavigation extends StatefulWidget {
  final String userId; // User ID passed from login/signup
  final String userRole; // User role passed from login/signup

  const BottomNavigation({Key? key, required this.userId, required this.userRole}) : super(key: key);

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
        HomeScreen(userId: widget.userId, userRole: widget.userRole),
        SetPhotoScreen(), // Doctor-specific analysis screen
        PatientsPage(doctorId: widget.userId), // Pass doctorId to PatientsPage
        Profile(userId: widget.userId, userRole: widget.userRole), // Pass userId and userRole to Profile
      ];

      _navigationItems = [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.analytics),
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
        HomeScreen(userId: widget.userId, userRole: widget.userRole),
        PatientAnalysisScreen(userId: widget.userId), // Patient-specific analysis screen
        DoctorsPage(), // DoctorsPage for patients
        Profile(userId: widget.userId, userRole: widget.userRole), // Pass userId and userRole to Profile
      ];

      _navigationItems = [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.analytics),
          label: 'Analysis',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.medical_services),
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