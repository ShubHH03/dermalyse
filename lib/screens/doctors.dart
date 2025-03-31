import 'package:flutter/material.dart';

class DoctorsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctors', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue.shade700,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Dr. Marcus Horizon'),
            subtitle: Text('Cardiologist'),
            trailing: Text('4.7 ★'),
            leading: CircleAvatar(
              backgroundColor: Colors.blue.shade200,
              child: Text('MH'),
            ),
            onTap: () {
              // Navigate to doctor details
            },
          ),
          ListTile(
            title: Text('Dr. Sarah Reynolds'),
            subtitle: Text('Dermatologist'),
            trailing: Text('4.9 ★'),
            leading: CircleAvatar(
              backgroundColor: Colors.green.shade200,
              child: Text('SR'),
            ),
            onTap: () {
              // Navigate to doctor details
            },
          ),
          ListTile(
            title: Text('Dr. James Wilson'),
            subtitle: Text('Dermatologist'),
            trailing: Text('4.5 ★'),
            leading: CircleAvatar(
              backgroundColor: Colors.purple.shade200,
              child: Text('JW'),
            ),
            onTap: () {
              // Navigate to doctor details
            },
          ),
          // Add more doctor listings here
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add functionality to search or filter doctors
        },
        child: Icon(Icons.search),
        tooltip: 'Search doctors',
      ),
    );
  }
}