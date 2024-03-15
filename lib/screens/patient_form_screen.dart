import 'package:flutter/material.dart';

class PatientFormScreen extends StatelessWidget {
  const PatientFormScreen({Key? key}) : super(key: key);

  //--------Alter code from here ----

  @override
  Widget build(BuildContext context) {
  return MaterialApp(
  debugShowCheckedModeBanner: false,
  title: 'Dermacare',
  theme: ThemeData(
  primarySwatch: Colors.blue,
  appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF416FDF))),
  home: const PatientFormWidget(),
  );
  }
  }

  class PatientFormWidget extends StatefulWidget {
  const PatientFormWidget({Key? key})
      : super(key: key); // Added named 'key' parameter

  @override
  State<PatientFormWidget> createState() => _PatientFormWidgetState();
  }

  class _PatientFormWidgetState extends State<PatientFormWidget> {
  late TextEditingController _fullNameController;
  late TextEditingController _ageController;
  late TextEditingController _dateOfBirthController;
  String _skinType = '';
  bool _isFemaleSelected = false;
  bool _isMaleSelected = false;

  @override
  void initState() {
  super.initState();
  _fullNameController = TextEditingController();
  _ageController = TextEditingController();
  _dateOfBirthController = TextEditingController();
  }

  @override
  void dispose() {
  _fullNameController.dispose();
  _ageController.dispose();
  _dateOfBirthController.dispose();
  super.dispose();
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
  //APP BAR

  appBar: AppBar(
  title: const Text(
  'DERMACARE',
  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
  ),
  leading: const Icon(
  Icons.menu,
  color: Colors.white,
  ),
  centerTitle: true,
  ),
  body: SingleChildScrollView(
  padding: const EdgeInsets.all(16),
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  //FULL NAME

  Container(
  margin: const EdgeInsets.symmetric(
  vertical: 10,
  ),
  ),
  const Text(
  'Full Name',
  style: TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
  color: Color(0xFF416FDF)),
  ),
  TextFormField(
  controller: _fullNameController,
  decoration: const InputDecoration(
  hintText: 'Enter your full name',
  ),
  ),
  const SizedBox(height: 16),
  //AGE
  Container(
  margin: const EdgeInsets.symmetric(
  vertical: 10,
  ),
  ),
  const Text(
  'Age',
  style: TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
  color: Color(0xFF416FDF)),
  ),
  TextFormField(
  controller: _ageController,
  keyboardType: TextInputType.number,
  decoration: const InputDecoration(
  hintText: 'Enter your age',
  ),
  ),
  const SizedBox(height: 16),

  // DOB

  Container(
  margin: const EdgeInsets.symmetric(
  vertical: 10,
  ),
  ),
  const Text(
  'Date of Birth',
  style: TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
  color: Color(0xFF416FDF),
  ),
  ),
  GestureDetector(
  onTap: () async {
  final selectedDate = await showDatePicker(
  context: context,
  initialDate: DateTime.now(),
  firstDate: DateTime(1900),
  lastDate: DateTime.now(),
  );
  if (selectedDate != null) {
  setState(() {
  _dateOfBirthController.text =
  selectedDate.toIso8601String().split('T')[0];
  });
  }
  },
  child: AbsorbPointer(
  child: TextFormField(
  controller: _dateOfBirthController,
  decoration: const InputDecoration(
  hintText: 'Select your date of birth',
  suffixIcon: Icon(Icons.calendar_today),
  ),
  ),
  ),
  ),
  const SizedBox(height: 16),

  //SKIN TYPE
  Container(
  margin: const EdgeInsets.symmetric(
  vertical: 10,
  ),
  ),
  const Text(
  'Skin Type',
  style: TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
  color: Color(0xFF416FDF),
  ),
  ),
  DropdownButtonFormField<String>(
  value: _skinType.isNotEmpty ? _skinType : null,
  onChanged: (value) {
  setState(() {
  _skinType = value!;
  });
  },
  items: const [
  DropdownMenuItem(
  value: 'Light',
  child: CircleAvatar(
  backgroundColor: Color(0xFFFFE0BD), // Light skin color
  ),
  ),
  DropdownMenuItem(
  value: 'Medium',
  child: CircleAvatar(
  backgroundColor: Color(0xFFFFCD94), // Medium skin color
  ),
  ),
  DropdownMenuItem(
  value: 'Dark',
  child: CircleAvatar(
  backgroundColor: Color(0xFFE0AC69), // Dark skin color
  ),
  ),
  DropdownMenuItem(
  value: 'More Dark',
  child: CircleAvatar(
  backgroundColor:
  Color.fromARGB(255, 228, 163, 78), // Dark skin color
  ),
  ),
  DropdownMenuItem(
  value: 'Even More Dark',
  child: CircleAvatar(
  backgroundColor:
  Color.fromARGB(255, 226, 139, 25), // Dark skin color
  ),
  ),
  ],
  ),
  const SizedBox(height: 16),

  //GENDER
  Container(
  margin: const EdgeInsets.symmetric(
  vertical: 10,
  ),
  ),
  const Text(
  'Gender',
  style: TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
  color: Color(0xFF416FDF),
  ),
  ),
  Row(
  children: [
  Checkbox(
  activeColor: Colors.blue,
  value: _isFemaleSelected,
  onChanged: (value) {
  setState(() {
  _isFemaleSelected = value!;
  if (_isFemaleSelected) {
  _isMaleSelected = false;
  }
  });
  },
  ),
  const Text(
  'Female',
  style: TextStyle(
  fontSize: 15,
  ),
  ),
  Checkbox(
  activeColor: const Color(0xFF416FDF),
  value: _isMaleSelected,
  onChanged: (value) {
  setState(() {
  _isMaleSelected = value!;
  if (_isMaleSelected) {
  _isFemaleSelected = false;
  }
  });
  },
  ),
  const Text('Male'),
  ],
  ),
  const SizedBox(height: 16),
  Container(
  margin: const EdgeInsets.symmetric(
  vertical: 10,
  ),
  ),
  ElevatedButton(
  style: ElevatedButton.styleFrom(
  minimumSize: const Size(375, 50),
  backgroundColor: const Color(0xFF416FDF),
  ),
  onPressed: () {},
  child: const Text(
  'Submit',
  style: TextStyle(
  fontSize: 20,
  color: Colors.white,
  fontWeight: FontWeight.bold,
  ),
  ),
  ),
  ],
  ),
  ),
  );
  }
  }
