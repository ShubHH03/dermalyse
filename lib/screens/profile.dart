import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_signup/theme/theme.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Dermalyse',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: Profile(), // Replace with your app's home widget
  ));
}

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: lightColorScheme.primary,
        title: const Text(
          'DERMALYSE',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        leading: BackButton(
          onPressed: () => Navigator.of(context).pop(),
          color: Colors.white,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 50),
            CircleAvatar(
              radius: 50,
              backgroundColor: lightColorScheme.primary,
              child: Icon(
                Icons.person,
                size: 60,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'mikamail@gmail.com',
              style: TextStyle(fontSize: 18),
            ),
        Padding(
          padding: const EdgeInsets.all(80.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // SizedBox(height:0),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Profile()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(250, 50),
                ),
                child: Text(
                  'DETAILS',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              Divider(),
              SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () {
                  // Navigation
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(250, 50),
                ),
                icon: Icon(Icons.book), // Added book icon
                label: Text(
                  'HISTORY',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Divider(),
              SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () {
                  // No navigation
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(250, 50),
                ),
                icon: Icon(Icons.location_on), // Added location icon
                label: Text(
                  'MUMBAI',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Divider(),
            ],
          ),
        ),
          //   SizedBox(height: 50),
          //   ListTile(
          //     leading: Icon(Icons.person),
          //     title: Text('My Details'),
          //     trailing: Icon(Icons.arrow_forward_ios),
          //   ),
          //   Divider(),
          //   ListTile(
          //     leading: Icon(Icons.book),
          //     title: Text('History'),
          //   ),
          //   Divider(),
          //   ListTile(
          //     leading: Icon(Icons.location_on),
          //     title: Text('Mumbai'),
          //   ),
          //   SizedBox(height: 0),
          //   Divider(),
          //   //
          //
         ],
        ),
      ),
    );
  }
}
