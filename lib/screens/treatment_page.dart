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
      final bytes = await rootBundle.load('assets/Jiten.xlsx');
      final excel = Excel.decodeBytes(bytes.buffer.asUint8List());
      final sheet = excel.tables.keys.first;
      final table = excel.tables[sheet];

      if (table == null) {
        throw Exception("Sheet '$sheet' not found");
      }

      for (var row in table.rows) {
        if (row.isNotEmpty && row.length >= 2) {
          var diseaseName = extractCellValueAsString(row[0]); // Extract disease name
          var treatmentContent = extractCellValueAsString(row[1]); // Extract treatment content

          // Check if disease name matches widget's diseaseName (case-insensitive)
          if (diseaseName != null &&
              diseaseName.trim().toLowerCase() == widget.diseaseName.trim().toLowerCase()) {
            print("Match found for ${widget.diseaseName}");

            setState(() {
              _treatmentContent = treatmentContent ?? 'Treatment content not found';
              print("Setting treatment content for ${widget.diseaseName}: $_treatmentContent");
            });
            return; // Exit the function after finding a match
          }
        }
      }

      // If no match is found, set a default treatment content
      setState(() {
        _treatmentContent = 'Treatment content not found';
      });
    } catch (e) {
      print("Error loading treatment data: $e");
      setState(() {
        _treatmentContent = 'Error loading treatment data';
      });
    }
  }

  String? extractCellValueAsString(dynamic cellValue) {
    if (cellValue == null) {
      return null;
    }

    if (cellValue is Data) {
      var cellData = cellValue.value;
      if (cellData is TextCellValue) {
        return cellData.value;
      }
    }

    return null; // Handle other types or unsupported cell values
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
