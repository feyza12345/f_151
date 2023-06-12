import 'package:flutter/material.dart';

class Ilanlar extends StatefulWidget {
  const Ilanlar({super.key});

  @override
  State<Ilanlar> createState() => _IlanlarState();
}

class _IlanlarState extends State<Ilanlar> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Ilanlar')),
    );
  }
}
