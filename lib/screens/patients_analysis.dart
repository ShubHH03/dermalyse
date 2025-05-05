import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../constants.dart';
import 'package:login_signup/screens/treatment_page.dart'; // Import for TreatmentPage

class PatientAnalysisScreen extends StatefulWidget {
  final String userId;

  const PatientAnalysisScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _PatientAnalysisScreenState createState() => _PatientAnalysisScreenState();
}

class _PatientAnalysisScreenState extends State<PatientAnalysisScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  String? _selectedDoctorId;
  File? _selectedImage;
  bool _isLoading = false;
  bool _isFetchingDoctors = true;
  List<dynamic> _doctors = [];
  List<dynamic> _analysisResults = [];

  @override
  void initState() {
    super.initState();
    _fetchDoctors();
    _fetchAnalysisResults();
  }

  Future<void> _fetchDoctors() async {
    try {
      final response = await http.get(Uri.parse('$apiBaseUrl/doctors'));
      if (response.statusCode == 200) {
        setState(() {
          _doctors = json.decode(response.body);
          _isFetchingDoctors = false;
        });
      } else {
        throw Exception('Failed to load doctors');
      }
    } catch (e) {
      print('Error fetching doctors: $e');
      setState(() {
        _isFetchingDoctors = false;
      });
    }
  }

  Future<void> _fetchAnalysisResults() async {
    try {
      final response = await http.get(Uri.parse('$apiBaseUrl/patients/${widget.userId}/analysis'));
      if (response.statusCode == 200) {
        setState(() {
          _analysisResults = json.decode(response.body);
        });
      } else {
        throw Exception('Failed to load analysis results');
      }
    } catch (e) {
      print('Error fetching analysis results: $e');
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate() || _selectedImage == null || _selectedDoctorId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields and select an image')),
      );
      return;
    }

    _formKey.currentState!.save();

    setState(() {
      _isLoading = true;
    });

    try {
      // Convert image to Base64
      final bytes = await _selectedImage!.readAsBytes();
      final base64Image = base64Encode(bytes);

      // Send data to the API
      final response = await http.post(
        Uri.parse('$apiBaseUrl/patients/predict'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': _name,
          'doctor_id': _selectedDoctorId,
          'image': base64Image,
          'patient_id': widget.userId,
        }),
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);

        // Refresh the analysis results
        await _fetchAnalysisResults();

        setState(() {
          _isLoading = false;
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Analysis submitted successfully')),
        );

        // Navigate to treatment page if disease name is available
        if (result.containsKey('disease_name')) {
          _navigateToTreatment(result['disease_name']);
        }
      } else {
        throw Exception('Failed to save analysis');
      }
    } catch (e) {
      print('Error submitting form: $e');
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  // Navigate to treatment page
  void _navigateToTreatment(String diseaseName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TreatmentPage(diseaseName: diseaseName),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Analysis'),
        backgroundColor: Colors.blue.shade700,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Patient Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the patient name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _name = value;
                    },
                  ),
                  const SizedBox(height: 16),
                  _isFetchingDoctors
                      ? Center(child: CircularProgressIndicator())
                      : DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Select Doctor',
                      border: OutlineInputBorder(),
                    ),
                    items: _doctors.map<DropdownMenuItem<String>>((doctor) {
                      return DropdownMenuItem<String>(
                        value: doctor['id'].toString(),
                        child: Text(doctor['name']),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedDoctorId = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a doctor';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: _selectedImage == null
                        ? Text('No image selected')
                        : Image.file(
                      _selectedImage!,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => _pickImage(ImageSource.gallery),
                        icon: Icon(Icons.image),
                        label: Text('Gallery'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade500,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => _pickImage(ImageSource.camera),
                        icon: Icon(Icons.camera_alt),
                        label: Text('Camera'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade500,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Center(
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      child: Text('Submit'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade500,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        minimumSize: Size(200, 50),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Text(
              'Analysis Results',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _analysisResults.isEmpty
                ? Center(child: Text('No analysis results found'))
                : ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _analysisResults.length,
              itemBuilder: (context, index) {
                final result = _analysisResults[index];
                // Extract disease name and confidence score
                final diseaseName = result['disease_name'] ?? 'Unknown';
                final confidence = result['disease_score'] ?? 0.0;
                final timestamp = result['timestamp'] ?? '';

                return GestureDetector(
                  onTap: () => _navigateToTreatment(diseaseName),
                  child: Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: Colors.grey.shade100,
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  diseaseName,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Confidence: ${confidence.toStringAsFixed(2)}%',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                timestamp,
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: 1, // Analysis tab selected
      //   type: BottomNavigationBarType.fixed,
      //   items: [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: 'Home',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.bar_chart),
      //       label: 'Analysis',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.medical_services),
      //       label: 'Doctors',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.person),
      //       label: 'Profile',
      //     ),
      //   ],
      //   onTap: (index) {
      //     // Handle bottom navigation tap
      //     // Implement navigation to other screens here
      //   },
      // ),
    );
  }
}