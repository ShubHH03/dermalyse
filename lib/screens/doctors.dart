import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants.dart';

class DoctorsPage extends StatefulWidget {
  @override
  _DoctorsPageState createState() => _DoctorsPageState();
}

class _DoctorsPageState extends State<DoctorsPage> {
  List<dynamic> doctors = [];
  List<dynamic> filteredDoctors = [];
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchDoctors();
  }

  Future<void> fetchDoctors() async {
    try {
      final response = await http.get(Uri.parse('$apiBaseUrl/doctors')); // Replace with your API URL
      if (response.statusCode == 200) {
        setState(() {
          doctors = json.decode(response.body);
          filteredDoctors = doctors; // Initialize filteredDoctors with all doctors
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load doctors');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching doctors: $e');
    }
  }

  void filterDoctors(String query) {
    setState(() {
      filteredDoctors = doctors
          .where((doctor) =>
      doctor['name'].toLowerCase().contains(query.toLowerCase()) ||
          doctor['specialization'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: filterDoctors,
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : filteredDoctors.isEmpty
                ? Center(child: Text('No doctors available'))
                : ListView.builder(
              itemCount: filteredDoctors.length,
              itemBuilder: (context, index) {
                final doctor = filteredDoctors[index];
                return ListTile(
                  title: Text(doctor['name']),
                  subtitle: Text(doctor['specialization']),
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.shade200,
                    child: Text(doctor['name'][0]),
                  ),
                  onTap: () {
                    // Navigate to doctor details or perform an action
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}