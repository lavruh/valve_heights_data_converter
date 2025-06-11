import 'package:flutter/material.dart';
import 'package:valve_heights_data_converter/data_processor.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final valveSequenceInput = TextEditingController();

  @override
  void initState() {
    valveSequenceInput.text = "C,D,A,B";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(onPressed: _openDataFile, child: Text("Open Data File")),
          DropdownMenu(
            dropdownMenuEntries: generateMenu(valveSequence),
            label: Text("Valve Sequence"),
          ),
          DropdownMenu(
            dropdownMenuEntries: generateMenu(cylinderSequence),
            label: Text("Cylinder Sequence"),
          ),
          TextButton(
            onPressed: _generateReport,
            child: Text("Generate report"),
          ),
        ],
      ),
    );
  }

  void _openDataFile() {}

  void _generateReport() {}

  List<DropdownMenuEntry<List<String>>> generateMenu(
    Map<String, List<String>> map,
  ) {
    List<DropdownMenuEntry<List<String>>> items = [];
    for (final name in map.keys) {
      final values = cylinderSequence[name];
      if (values != null) {
        items.add(DropdownMenuEntry(value: values, label: name));
      }
    }
    return items;
  }
}
