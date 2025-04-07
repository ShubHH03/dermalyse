import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../constants.dart';

class PatientAnalysisScreen extends StatefulWidget {
  final String userId; // Accept userId as a parameter

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
        }),
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Prediction saved: ${result.toString()}')),
        );
        _fetchAnalysisResults(); // Refresh the analysis results
      } else {
        throw Exception('Failed to save patient');
      }
    } catch (e) {
      print('Error submitting form: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
                  Text(
                    'Submit Analysis',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
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
                      ? CircularProgressIndicator()
                      : _doctors.isEmpty
                      ? Text('No doctors available')
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
                  _selectedImage == null
                      ? Text('No image selected')
                      : Image.file(
                    _selectedImage!,
                    height: 150,
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
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => _pickImage(ImageSource.camera),
                        icon: Icon(Icons.camera_alt),
                        label: Text('Camera'),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      child: Text('Submit'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Analysis Results',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _analysisResults.isEmpty
                ? Center(child: Text('No analysis results found'))
                : ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _analysisResults.length,
              itemBuilder: (context, index) {
                final result = _analysisResults[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    title: Text(result['disease_name']),
                    subtitle: Text('Confidence: ${result['disease_score']}%'),
                    trailing: Text(result['timestamp']),
                    onTap: () {
                      // Handle tap to show more details
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}