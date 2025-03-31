import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:login_signup/screens/treatment_page.dart';
import 'package:http/http.dart' as http;

class SetPhotoScreen extends StatefulWidget {
  const SetPhotoScreen({Key? key}) : super(key: key);
  static const id = 'set_photo_screen';

  @override
  State<SetPhotoScreen> createState() => _SetPhotoScreenState();
}

class _SetPhotoScreenState extends State<SetPhotoScreen> {
  File? _image;
  bool _isLoading = false;
  Map<String, dynamic> _responseData = {};

  Future _pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      File? img = File(image.path);
      img = await _cropImage(imageFile: img);
      setState(() {
        _image = img;
        Navigator.of(context).pop();
      });
    } on PlatformException catch (e) {
      print(e);
      Navigator.of(context).pop();
    }
  }

  Future<File?> _cropImage({required File imageFile}) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Colors.deepPurple,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: 'Crop Image',
        ),
      ],
    );
    return croppedImage == null ? null : File(croppedImage.path);
  }

  Future<void> uploadImage() async {
    setState(() {
      _isLoading = true;
    });

    try {
      Uint8List bytes = await _image!.readAsBytes();
      String base64Image = base64Encode(bytes);

      // ---------------using ngrok---------------------
      // const ngrokUri = "https://a354-2401-4900-56dd-85e0-1c5a-dac7-5275-b89c.ngrok-free.app/predict";
      // var uri = Uri.parse(ngrokUri);

      // ----------------using localhost--------------------
      // testing via localhost
      const uriLocalhost = 'http://192.168.31.229:5001/predict';
      var uri = Uri.parse(uriLocalhost);

      // ------------------------------------

      // Prepare the JSON payload
      var payload = jsonEncode({'image': base64Image});
      
      var response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: payload,
      );

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        print('Upload successful');
        var responseData = jsonDecode(response.body);
        setState(() {
          _responseData = responseData;
        });
      } else {
        _showErrorDialog('Upload failed. Please try again.');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog('An error occurred: $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Error', style: TextStyle(color: Colors.red)),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Okay'),
          ),
        ],
      ),
    );
  }

  void _showSelectPhotoOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Choose Image Source',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildImageSourceButton(
                  icon: Icons.camera_alt,
                  label: 'Camera',
                  onTap: () => _pickImage(ImageSource.camera),
                ),
                _buildImageSourceButton(
                  icon: Icons.photo_library,
                  label: 'Gallery',
                  onTap: () => _pickImage(ImageSource.gallery),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSourceButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurple.shade50,
        foregroundColor: Colors.blue.shade700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      ),
      child: Column(
        children: [
          Icon(icon, size: 40),
          SizedBox(height: 10),
          Text(label),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Image Analysis', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue.shade700,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Upload an Image for Analysis',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  // color: Colors.grey.shade900,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Expanded(
                child: GestureDetector(
                  onTap: () => _showSelectPhotoOptions(context),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.shade50,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.deepPurple.shade100,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: _image == null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.upload_file,
                                  size: 80,
                                  color: Colors.blue.shade700,
                                ),
                                SizedBox(height: 15),
                                Text(
                                    'Tap to Select Image',
                                  style: TextStyle(
                                    // color: Colors.deepPurple,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.file(
                                _image!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _showSelectPhotoOptions(context),
                      icon: Icon(Icons.photo_camera),
                      label: Text('Choose Image'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade700,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _image != null ? uploadImage : null,
                      icon: Icon(Icons.analytics),
                      label: Text('Analyze'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _image != null 
                            ? Colors.blue.shade700 
                            : Colors.grey,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (_isLoading)
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade700),
                    ),
                  ),
                ),
              if (_responseData.isNotEmpty && !_isLoading)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListView.separated(
                        separatorBuilder: (context, index) => Divider(
                          height: 1,
                          color: Colors.grey.shade300,
                        ),
                        itemCount: _responseData.length,
                        itemBuilder: (context, index) {
                          String key = _responseData.keys.elementAt(index);
                          return ListTile(
                            title: Text(
                              key,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple,
                              ),
                            ),
                            subtitle: Text(
                              '${_responseData[key].toStringAsFixed(2)}%',
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.deepPurple,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TreatmentPage(diseaseName: key),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}