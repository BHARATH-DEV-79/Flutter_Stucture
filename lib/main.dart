import 'package:flutter/material.dart';

void main(){
  runApp(Mainclass());
}

class Mainclass extends StatelessWidget {
  const Mainclass({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Placeholder(),
    );
  }
}