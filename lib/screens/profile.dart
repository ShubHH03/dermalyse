import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Dermalyse',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    // home: Profile(userId: '1', userRole: 'Patient'), // Example parameters
  ));
}

class Profile extends StatefulWidget {
  final String userId; // Pass the user ID
  final String userRole; // Pass the user role (Doctor or Patient)

  const Profile({Key? key, required this.userId, required this.userRole}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Map<String, dynamic>? userData; // To store user data
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final url = widget.userRole == 'Doctor'
          ? '$apiBaseUrl/doctors/${widget.userId}' // Fetch doctor data
          : '$apiBaseUrl/patients/${widget.userId}'; // Fetch patient data

      print('Fetching user data from: $url'); // Debug log

      final response = await http.get(Uri.parse(url));

      print('Response status: ${response.statusCode}'); // Debug log
      print('Response body: ${response.body}'); // Debug log

      if (response.statusCode == 200) {
        setState(() {
          userData = json.decode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load user data');
      }
    } catch (e) {
      print('Error fetching user data: $e'); // Debug log
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : userData == null
          ? const Center(child: Text('Failed to load user data'))
          : Column(
        children: [
          // Blue header section with profile
          Container(
            color: Colors.blue,
            padding: EdgeInsets.only(top: 100, bottom: 30),
            child: Column(
              children: [
                // Profile picture
                // Container(
                //   width: 80,
                //   height: 80,
                //   decoration: BoxDecoration(
                //     shape: BoxShape.circle,
                //     color: Colors.blue.shade600,
                //     image: DecorationImage(
                //       image: AssetImage('assets/profile_placeholder.jpg'),
                //       fit: BoxFit.cover,
                //     ),
                //   ),
                //   child: Stack(
                //     alignment: Alignment.bottomRight,
                //     children: [
                //       Container(
                //         padding: EdgeInsets.all(4),
                //         decoration: BoxDecoration(
                //           color: Colors.white,
                //           shape: BoxShape.circle,
                //         ),
                //         child: Icon(Icons.camera_alt, size: 16, color: Colors.blue),
                //       ),
                //     ],
                //   ),
                // ),
                SizedBox(height: 15),
                // Name from API data
                Text(
                  userData!['name'] ?? 'User Name',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                // Email from API data
                Text(
                  userData!['email'] ?? 'user@example.com',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 5),
                // Role
                Text(
                  'Role: ${widget.userRole}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 20),
                // Metrics row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  // children: [
                  //   // Heart rate
                  //   _buildMetricColumn('Heart rate', '215bpm', Icons.favorite),
                  //   Container(height: 40, width: 1, color: Colors.white.withOpacity(0.3)),
                  //   // Calories
                  //   _buildMetricColumn('Calories', '756cal', Icons.local_fire_department),
                  //   Container(height: 40, width: 1, color: Colors.white.withOpacity(0.3)),
                  //   // Weight
                  //   _buildMetricColumn('Weight', '103lbs', Icons.fitness_center),
                  // ],
                ),
              ],
            ),
          ),
          // Menu items
          Expanded(
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  _buildMenuItem('My Analysis', Icons.favorite_border),
                  Divider(height: 1),
                  _buildMenuItem('Appointment', Icons.calendar_today_outlined),
                  Divider(height: 1),
                  _buildMenuItem('Payment Method', Icons.account_balance_wallet_outlined),
                  Divider(height: 1),
                  _buildMenuItem('FAQs', Icons.chat_bubble_outline),
                  // Show specialization for doctors
                  if (widget.userRole == 'Doctor') Divider(height: 1),
                  if (widget.userRole == 'Doctor')
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(Icons.medical_services, color: Colors.blue),
                          ),
                          SizedBox(width: 16),
                          Text(
                            'Specialization: ${userData!['specialization'] ?? 'N/A'}',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricColumn(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        SizedBox(height: 5),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(String title, IconData icon) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.blue),
      ),
      title: Text(
        title,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      trailing: Icon(Icons.chevron_right, color: Colors.grey),
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      onTap: () {},
    );
  }
}