import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants.dart';

class PatientsPage extends StatefulWidget {
  final String doctorId; // Pass the doctor ID to fetch patients

  const PatientsPage({Key? key, required this.doctorId}) : super(key: key);

  @override
  _PatientsPageState createState() => _PatientsPageState();
}

class _PatientsPageState extends State<PatientsPage> {
  List<dynamic> _patients = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPatients();
  }

  Future<void> _fetchPatients() async {
    try {
      final url = Uri.parse('$apiBaseUrl/doctor/${widget.doctorId}/patients'); // Replace with your API base URL
      final response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          _patients = json.decode(response.body);
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load patients');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Patients', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue.shade700,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _patients.isEmpty
          ? const Center(child: Text('No patients found'))
          : ListView.builder(
        itemCount: _patients.length,
        itemBuilder: (context, index) {
          final patient = _patients[index];
          return ListTile(
            leading: CircleAvatar(
              child: Text(
                _getInitials(patient['name']),
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.blue.shade200,
            ),
            title: Text(patient['name'] ?? 'N/A'),
            subtitle: Text(
              patient['latest_analysis'] != null && patient['latest_analysis']['disease_name'] != null
                  ? 'Disease: ${patient['latest_analysis']['disease_name']}'
                  : 'No disease information',
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Navigate to patient details
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PatientDetailsPage(patient: patient),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add functionality to add new patient or create appointment
        },
        child: const Icon(Icons.add),
        tooltip: 'Add new patient',
      ),
    );
  }

  String _getInitials(String? name) {
    if (name == null || name.isEmpty) return '';
    final names = name.split(' ');
    final initials = names.map((n) => n.isNotEmpty ? n[0] : '').take(2).join();
    return initials.toUpperCase();
  }
}

class PatientDetailsPage extends StatelessWidget {
  final Map<String, dynamic> patient;

  const PatientDetailsPage({Key? key, required this.patient}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(patient['name'] ?? 'Patient Details'),
        backgroundColor: Colors.blue.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name: ${patient['name'] ?? 'N/A'}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Disease: ${patient['latest_analysis']?['disease_name'] ?? 'N/A'}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Disease Score: ${patient['latest_analysis']?['disease_score'] ?? 'N/A'}',
              style: const TextStyle(fontSize: 16),
            ),
            // const SizedBox(height: 8),
            // Text(
            //   'Doctor ID: ${patient['doctor_id'] ?? 'N/A'}',
            //   style: const TextStyle(fontSize: 16),
            // ),
            // const SizedBox(height: 16),
            // ElevatedButton(
            //   onPressed: () {
            //     // Add functionality to edit patient details
            //   },
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: Colors.blue.shade700,
            //   ),
            //   child: const Text('Edit Details'),
            // ),
          ],
        ),
      ),
    );
  }
}