import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:login_signup/screens/treatment_page.dart';
import 'package:login_signup/theme/theme.dart';
import '../widgets/common_buttons.dart';
import '../constants.dart';
import 'select_photo_options_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class SetPhotoScreen extends StatefulWidget {
  const SetPhotoScreen({Key? key});

  static const id = 'set_photo_screen';

  @override
  State<SetPhotoScreen> createState() => _SetPhotoScreenState();
}

class _SetPhotoScreenState extends State<SetPhotoScreen> {
  File? _image;
  bool _showLists = false; // Track if the lists should be shown
  Map<String, dynamic> _responseData =
      {}; // State variable to store response data

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
    CroppedFile? croppedImage =
        await ImageCropper().cropImage(sourcePath: imageFile.path);
    if (croppedImage == null) return null;
    return File(croppedImage.path);
  }

  Future<void> uploadImage() async {
    try {
      Uint8List bytes = await _image!.readAsBytes();
      String base64Image = base64Encode(bytes);
      var uri = Uri.parse('https://a121-2409-40c0-11a4-97fc-dc08-41de-8205-c29b.ngrok-free.app/predict');
      // Prepare the JSON payload
      var payload = jsonEncode({'image': base64Image});
      // Send the POST request with the JSON payload
      var response = await http.post(uri,
          headers: {"Content-Type": "application/json"}, body: payload);
      if (response.statusCode == 200) {
        print('Upload successful');
        var responseData = jsonDecode(response.body);
        setState(() {
          _responseData = responseData;
        });
      } else {
        print('Upload failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  void _toggleListsVisibility() {
    if (!_showLists) {
      uploadImage(); // Trigger image upload if not already done
    }
    setState(() {
      _showLists = !_showLists;
    });
  }

  void _showSelectPhotoOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.28,
        maxChildSize: 0.4,
        minChildSize: 0.28,
        expand: false,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            child: SelectPhotoOptionsScreen(
              onTap: _pickImage,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: lightColorScheme.primary,
        title: Text(
          'Dermalyse',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  SizedBox(height: 30),
                  Text(
                    'Select an image to analyze!',
                    style: kHeadTextStyle,
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Expanded(
                child: Center(
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      _showSelectPhotoOptions(context);
                    },
                    child: Container(
                      height: 300.0,
                      width: 300.0,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                      ),
                      child: Center(
                        child: _image == null
                            ? Text(
                                'No image selected',
                                style: TextStyle(fontSize: 20),
                              )
                            : Image.file(
                                _image!,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CommonButtons(
                    onTap: () => _showSelectPhotoOptions(context),
                    backgroundColor: lightColorScheme.primary,
                    textColor: Colors.white,
                    textLabel: 'Select Image',
                  ),
                  SizedBox(height: 16),
                  CommonButtons(
                    onTap: _toggleListsVisibility,
                    backgroundColor: lightColorScheme.primary,
                    textColor: Colors.white,
                    textLabel: 'Results',
                  ),
                ],
              ),
              SizedBox(height: 16),
              if (_showLists)
                Expanded(
                  child: ListView.builder(
                    itemCount: _responseData.length,
                    itemBuilder: (context, index) {
                      String key = _responseData.keys.elementAt(index);
                      print(key);
                      return ListTile(
                        title: Text(key),
                        subtitle: Text('${_responseData[key]} %'),
                        trailing: Icon(Icons.arrow_forward),
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
            ],
          ),
        ),
      ),
    );
  }
}
