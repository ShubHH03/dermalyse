import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Dermalyse',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: Profile(),
  ));
}

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Blue header section with profile
          Container(
            color: Colors.blue,
            padding: EdgeInsets.only(top: 50, bottom: 30),
            child: Column(
              children: [
                // Profile picture
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue.shade600,
                    image: DecorationImage(
                      image: AssetImage('assets/profile_placeholder.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        // child: Icon(Icons.camera_alt, size: 16, color: Colors.blue),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                // Name
                Text(
                  'Soham Waghela',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                // Metrics row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Heart rate
                    _buildMetricColumn('Heart rate', '215bpm', Icons.favorite),
                    Container(height: 40, width: 1, color: Colors.white.withOpacity(0.3)),
                    // Calories
                    _buildMetricColumn('Calories', '756cal', Icons.local_fire_department),
                    Container(height: 40, width: 1, color: Colors.white.withOpacity(0.3)),
                    // Weight
                    _buildMetricColumn('Weight', '103lbs', Icons.fitness_center),
                  ],
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
                  _buildMenuItem('Appointmnet', Icons.calendar_today_outlined),
                  Divider(height: 1),
                  _buildMenuItem('Payment Method', Icons.account_balance_wallet_outlined),
                  Divider(height: 1),
                  _buildMenuItem('FAQs', Icons.chat_bubble_outline),
                  Spacer(),
                  // Bottom navigation
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