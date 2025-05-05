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
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTreatmentContent();
  }

  Future<void> _loadTreatmentContent() async {
    try {
      final bytes = await rootBundle.load('assets/treatment.xlsx');
      final excel = Excel.decodeBytes(bytes.buffer.asUint8List());
      final sheet = excel.tables.keys.first;
      final table = excel.tables[sheet];

      if (table == null) {
        throw Exception("Sheet '$sheet' not found");
      }

      for (var row in table.rows) {
        if (row.isNotEmpty && row.length >= 2) {
          var diseaseName = extractCellValueAsString(row[0]);
          var treatmentContent = extractCellValueAsString(row[1]);

          if (diseaseName != null &&
              diseaseName.trim().toLowerCase() == widget.diseaseName.trim().toLowerCase()) {
            setState(() {
              _treatmentContent = treatmentContent ?? 'Treatment content not found';
              _isLoading = false;
            });
            return;
          }
        }
      }

      setState(() {
        _treatmentContent = 'Treatment content not found for ${widget.diseaseName}';
        _isLoading = false;
      });
    } catch (e) {
      print("Error loading treatment data: $e");
      setState(() {
        _treatmentContent = 'Error loading treatment data';
        _isLoading = false;
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

    return null;
  }

  List<String> _parseTreatmentContent() {
    // Split content by paragraphs or bullet points
    if (_treatmentContent.contains('•')) {
      return _treatmentContent.split('•').where((item) => item.trim().isNotEmpty).toList();
    } else if (_treatmentContent.contains('\n\n')) {
      return _treatmentContent.split('\n\n').where((item) => item.trim().isNotEmpty).toList();
    } else {
      return [_treatmentContent];
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> treatmentItems = _isLoading ? [] : _parseTreatmentContent();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue.shade700,
        title: Text(
          'Treatment Details',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.share, color: Colors.white),
            onPressed: () {
              // Share functionality could be added here
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Share feature coming soon'))
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Disease Header
            Container(
              width: double.infinity,
              color: Colors.blue.shade700,
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.diseaseName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Medical Condition',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Stats Card
            // Container(
            //   margin: EdgeInsets.all(16),
            //   padding: EdgeInsets.all(16),
            //   decoration: BoxDecoration(
            //     color: Colors.white,
            //     borderRadius: BorderRadius.circular(12),
            //     boxShadow: [
            //       BoxShadow(
            //         color: Colors.black.withOpacity(0.05),
            //         blurRadius: 10,
            //         offset: Offset(0, 5),
            //       ),
            //     ],
            //   ),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceAround,
            //     children: [
            //       _buildStatItem('Severity', 'Moderate', Icons.warning_amber_rounded),
            //       _buildStatItem('Recovery', '2-4 weeks', Icons.healing),
            //       _buildStatItem('Contagious', 'No', Icons.people),
            //     ],
            //   ),
            // ),

            // Treatment Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Treatment Plan',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
              ),
            ),

            // Treatment Content Cards
            if (treatmentItems.isNotEmpty)
              ...treatmentItems.map((item) => _buildTreatmentCard(item)).toList()
            else
              Padding(
                padding: EdgeInsets.all(16),
                child: Center(
                  child: Text(
                    _treatmentContent,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),

            // Disclaimer
            Container(
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                // border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.grey[700], size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Disclaimer',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'This information is for educational purposes only and is not intended to replace professional medical advice. Always consult with a healthcare provider for diagnosis and treatment.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Book appointment or take next step
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Booking appointment feature coming soon'))
          );
        },
        icon: Icon(Icons.calendar_today),
        label: Text('Book Appointment'),
        backgroundColor: Colors.blue.shade700,
      ),
    );
  }

  Widget _buildStatItem(String title, String value, IconData icon) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.blue.shade700, size: 24),
        ),
        SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildTreatmentCard(String content) {
    // This helps identify if the item is likely a heading or regular content
    bool isHeading = content.length < 50 && !content.contains(',');

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                isHeading ? Icons.medical_services : Icons.check_circle,
                color: Colors.blue.shade700,
                size: 24,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                content.trim(),
                style: TextStyle(
                  fontSize: isHeading ? 18 : 16,
                  fontWeight: isHeading ? FontWeight.bold : FontWeight.normal,
                  color: isHeading ? Colors.blue.shade800 : Colors.black87,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}