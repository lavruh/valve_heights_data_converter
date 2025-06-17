import 'package:file_provider/file_provider.dart';
import 'package:flutter/material.dart';
import 'package:valve_heights_data_converter/cylinder_measurement.dart';
import 'package:valve_heights_data_converter/data_preview.dart';
import 'package:valve_heights_data_converter/data_processor.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Map<String, CylinderMeasurement> previewData = {};
  String csvData = "";
  String initCylState = "A1";
  List<String> valveSeqState = [];
  List<String> cylSeqState = [];
  List<String> measurementSeqState = [];

  @override
  void initState() {
    valveSeqState = valveSequence["D,C,A,B"] ?? [];
    cylSeqState = cylinderSequence["PS_ME"] ?? [];
    measurementSeqState = measurementSequence["stem"] ?? [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                  onPressed: _openDataFile, child: Text("Open Data File")),
              TextButton(
                onPressed: _generateReport,
                child: Text("Generate report"),
              ),
              TextButton(
                onPressed: _exportReport,
                child: Text("Export report"),
              ),
            ],
          ),
          Wrap(
            children: [
              Padding(
                  padding: EdgeInsetsGeometry.all(8.0),
                  child: DropdownMenu(
                    dropdownMenuEntries: generateMenu(valveSequence),
                    label: Text("Valve Sequence"),
                    initialSelection: valveSeqState,
                    onSelected: (val) {
                      if (val == null) return;
                      setState(() {
                        valveSeqState = val;
                      });
                    },
                  )),
              Padding(
                  padding: EdgeInsetsGeometry.all(8.0),
                  child: DropdownMenu(
                    dropdownMenuEntries: generateMenu(cylinderSequence),
                    label: Text("Cylinder Sequence"),
                    initialSelection: cylSeqState,
                    onSelected: (val) {
                      if (val == null) return;
                      setState(() {
                        cylSeqState = val;
                      });
                    },
                  )),
              Padding(
                  padding: EdgeInsetsGeometry.all(8.0),
                  child: DropdownMenu<String>(
                    dropdownMenuEntries: generateStringMenu(cylSeqState),
                    label: Text("Initial cylinder"),
                    initialSelection: initCylState,
                    onSelected: (val) {
                      if (val == null) return;
                      setState(() {
                        initCylState = val;
                      });
                    },
                  )),
              Padding(
                  padding: EdgeInsetsGeometry.all(8.0),
                  child: DropdownMenu(
                    dropdownMenuEntries: generateMenu(measurementSequence),
                    label: Text("Sequence"),
                    initialSelection: measurementSeqState,
                    onSelected: (val) {
                      if (val == null) return;
                      setState(() {
                        measurementSeqState = val;
                      });
                    },
                  )),
            ],
          ),
          DataPreview(data: previewData),
        ],
      ),
    );
  }

  void _openDataFile() async {
    final IFileProvider fileProvider = FileProvider.getInstance();
    final file = await fileProvider.selectFile(
      context: context,
      title: "Select input data file",
    );
    final data = file.readAsStringSync();
    setState(() {
      csvData = data;
    });
  }

  void _generateReport() {
    final proc = DataProcessor(
      initCyl: initCylState,
      cylSequence: cylSeqState,
      valveSequence: valveSeqState,
      measurementSequence: measurementSeqState,
    );

    // csvData = _generateCsvData();

    final data = proc.convertCsvToDataTable(csvData);
    setState(() {
      previewData = data;
    });
  }

  List<DropdownMenuEntry<List<String>>> generateMenu(
    Map<String, List<String>> map,
  ) {
    List<DropdownMenuEntry<List<String>>> items = [];
    for (final name in map.keys) {
      final values = map[name];
      if (values != null) {
        items.add(DropdownMenuEntry(value: values, label: name));
      }
    }
    return items;
  }

  List<DropdownMenuEntry<String>> generateStringMenu(
    List<String> list,
  ) {
    List<DropdownMenuEntry<String>> items = [];
    for (final name in list) {
      items.add(DropdownMenuEntry(value: name, label: name));
    }
    return items;
  }

  void _exportReport() {}
}

String _generateCsvData() {
  String out = '#,"0610022839","caliper",,,,,""';
  final realDeviceData = """#,"0610022839","caliper",,,,,""
0.00,"OK","2025/6/14 3:45"
13.03,"OK","2025/6/14 3:45"
29.63,"OK","2025/6/14 3:45"
143.48,"OK","2025/6/14 3:45"
103.01,"OK","2025/6/14 3:45"
74.86,"OK","2025/6/14 3:45"
49.11,"OK","2025/6/14 3:45"
22.69,"OK","2025/6/14 3:45"
110.80,"OK","2025/6/14 3:45"
74.75,"OK","2025/6/14 3:45"
49.79,"OK","2025/6/14 3:45"
104.82,"OK","2025/6/14 3:45"
29.43,"OK","2025/6/14 3:45"
112.45,"OK","2025/6/14 3:45"
43.16,"OK","2025/6/14 3:45"
70.00,"OK","2025/6/14 3:45"
17.95,"OK","2025/6/14 3:45"
50.14,"OK","2025/6/14 3:45"
67.18,"OK","2025/6/14 3:45"
110.06,"OK","2025/6/14 3:45"
140.97,"OK","2025/6/14 3:45"
94.90,"OK","2025/6/14 3:46"
124.80,"OK","2025/6/14 3:46"
32.60,"OK","2025/6/14 3:46"
85.96,"OK","2025/6/14 3:46"
112.06,"OK","2025/6/14 3:46"
16.94,"OK","2025/6/14 3:46"
10.82,"OK","2025/6/14 3:46"
59.10,"OK","2025/6/14 3:46"
80.20,"OK","2025/6/14 3:46"
56.04,"OK","2025/6/14 3:46"
75.15,"OK","2025/6/14 3:46"
21.15,"OK","2025/6/14 3:46"
130.50,"OK","2025/6/14 3:46"
100.00,"OK","2025/6/14 3:46"
84.68,"OK","2025/6/14 3:46"
65.61,"OK","2025/6/14 3:46"
30.98,"OK","2025/6/14 3:46"
18.41,"OK","2025/6/14 3:46"
138.64,"OK","2025/6/14 3:46"
60.01,"OK","2025/6/14 3:46"
89.17,"OK","2025/6/14 3:46"
31.49,"OK","2025/6/14 3:46"
69.11,"OK","2025/6/14 3:46"
99.99,"OK","2025/6/14 3:46"
""";
  for (double i = 0.0; i < 12 * 4 * 2; i += 1.0) {
    out = '$out\n${i.toStringAsFixed(2)},"OK","2025/6/14 3:46"';
  }
  print(out);
  return out;
}
