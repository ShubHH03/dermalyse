import 'package:flutter/material.dart';

class CommonButtons extends StatelessWidget {
  const CommonButtons({
    Key? key,
    required this.textLabel,
    required this.textColor,
    required this.backgroundColor,
    required this.onTap,
  }) : super(key: key);

  final String textLabel;
  final Color textColor;
  final Color backgroundColor;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          elevation: 5,
          backgroundColor: backgroundColor,
          shape: const StadiumBorder(),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 6,
          ),
          child: Text(
            textLabel,
            style: TextStyle(color: textColor, fontSize: 18),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Centered Button Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Centered Button Example'),
        ),
        body: Center(
          child: CommonButtons(
            textLabel: 'Centered Button',
            textColor: Colors.white,
            backgroundColor: Colors.blue,
            onTap: () {
              // Add your onTap functionality here
            },
          ),
        ),
      ),
    );
  }
}