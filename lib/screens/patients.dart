import 'package:flutter/material.dart';

class PatientsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Patients', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue.shade700,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: CircleAvatar(
              child: Text('JS'),
              backgroundColor: Colors.blue.shade200,
            ),
            title: Text('John Smith'),
            subtitle: Text('Last visit: March 25, 2025'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Navigate to patient details
            },
          ),
          ListTile(
            leading: CircleAvatar(
              child: Text('AR'),
              backgroundColor: Colors.green.shade200,
            ),
            title: Text('Amanda Rodriguez'),
            subtitle: Text('Last visit: March 15, 2025'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Navigate to patient details
            },
          ),
          ListTile(
            leading: CircleAvatar(
              child: Text('MP'),
              backgroundColor: Colors.purple.shade200,
            ),
            title: Text('Michael Parker'),
            subtitle: Text('Last visit: March 10, 2025'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Navigate to patient details
            },
          ),
          ListTile(
            leading: CircleAvatar(
              child: Text('SK'),
              backgroundColor: Colors.orange.shade200,
            ),
            title: Text('Sarah Kim'),
            subtitle: Text('New patient - No visits'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Navigate to patient details
            },
          ),
          // Add more patient listings here
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add functionality to add new patient or create appointment
        },
        child: Icon(Icons.add),
        tooltip: 'Add new patient',
      ),
    );
  }
}