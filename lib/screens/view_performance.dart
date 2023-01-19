import 'package:flutter/material.dart';

class ViewPerformance extends StatefulWidget {
  const ViewPerformance({Key? key}) : super(key: key);

  @override
  State<ViewPerformance> createState() => _ViewPerformanceState();
}

class _ViewPerformanceState extends State<ViewPerformance> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("View Performance"),
      ),
    );
  }
}
