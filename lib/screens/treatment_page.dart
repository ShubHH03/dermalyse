import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:excel/excel.dart';

class TreatmentPage extends StatefulWidget {
  final String diseaseName;

  TreatmentPage({required this.diseaseName});

  @override
  _TreatmentPageState createState() => _TreatmentPageState();
}

class _TreatmentPageState extends State<TreatmentPage> {
  String _treatmentContent = '';

  @override
  void initState() {
    super.initState();
    _loadTreatmentContent();
  }

  Future<void> _loadTreatmentContent() async {
    try {
      final bytes = await rootBundle.load('assets/treatment_data.xlsx');
      final excel = Excel.decodeBytes(bytes.buffer.asUint8List());
      final sheet = excel.tables.keys.first;
      final rows = excel.tables[sheet]!.rows;

      // Skip the first row (header row) and start from the second row
      final dataRows = rows.skip(1);

      for (var row in dataRows) {
        if (row.length >= 2) {
          // Explicitly check if the first cell's value is a String
          if (row[0]?.value is String) {
            String diseaseName = row[0]?.value as String;
            // Trim spaces and compare
            if (diseaseName.trim().toLowerCase() == widget.diseaseName.trim().toLowerCase()) {
              print("Match found for ${widget.diseaseName}"); // Debugging line
              setState(() {
                _treatmentContent = (row[1]?.value as String?) ?? 'Treatment content not found';
                print("Setting treatment content for ${widget.diseaseName}: $_treatmentContent"); // Debugging line
              });
              return; // Early return after setting treatment content
            }
          }
        }
      }

      print("No match found for ${widget.diseaseName}"); // Debugging line
      setState(() {
        _treatmentContent = 'Treatment content not found for ${widget.diseaseName}';
      });
    } catch (e) {
      print("Error loading treatment data: $e"); // Debugging line
      setState(() {
        _treatmentContent = 'Error loading treatment data';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Treatment for ${widget.diseaseName}'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 25),
            Container(
              height: 150,
              width: 375,
              margin: const EdgeInsets.symmetric(horizontal: 20).copyWith(top: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                color: Colors.blueAccent,
              ),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 20),
                  child: Text(
                    '${widget.diseaseName}',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Text(
                    _treatmentContent.isNotEmpty ? _treatmentContent : 'Treatment content not found',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
