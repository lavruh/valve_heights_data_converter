import 'dart:io';

import 'package:excel/excel.dart';
import 'package:file_provider/file_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  void _exportReport() async {
    final data = await rootBundle.load('assets/template.xlsx');
    final bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    final excel = Excel.decodeBytes(bytes);
    final table = excel.tables["Sheet1"];
    if (table == null) return;

    var cell =
        table.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: 6));
    cell.value = DoubleCellValue(13.37);

    final outRegions = {
      "A1": [3, 6],
      "A2": [3, 10],
      "A3": [3, 14],
      "A4": [3, 18],
      "A5": [3, 22],
      "A6": [3, 26],
      "B1": [11, 6],
      "B2": [11, 10],
      "B3": [11, 14],
      "B4": [11, 18],
      "B5": [11, 22],
      "B6": [11, 26]
    };
    final valveOffset = {"A": 0, "B": 1, "C": 2, "D": 3};

    for (final cyl in previewData.values) {
      final outLoc = outRegions[cyl.name];
      if (outLoc == null) continue;
      final col = outLoc[0];
      final row = outLoc[1];

      for (final valve in cyl.values.keys) {
        final offset = valveOffset[valve];
        final readings = cyl.values[valve];
        if (offset == null || readings == null) continue;

        var stem = table.cell(CellIndex.indexByColumnRow(
            columnIndex: col, rowIndex: row + offset));
        var rotator = table.cell(CellIndex.indexByColumnRow(
            columnIndex: col + 1, rowIndex: row + offset));

        final stemStyle = stem.cellStyle;
        stem.value = DoubleCellValue(readings[0]);
        stem.cellStyle = stemStyle;
        final rotatorStyle = rotator.cellStyle;
        rotator.value = DoubleCellValue(readings[1]);
        rotator.cellStyle = rotatorStyle;
      }
    }

    if (kIsWeb) {
      excel.save(fileName: "measurement.xlsx");
    } else {
      final fileBytes = excel.save();
      if (fileBytes == null) return;
      final IFileProvider fileProvider = FileProvider.getInstance();
      final file = await fileProvider.selectFile(
          context: context,
          title: "Select output file",
          allowedExtensions: ["xlsx"]);
      String path = file.path.split(".")[0];
      File("$path.xlsx")
        ..createSync(recursive: true)
        ..writeAsBytesSync(fileBytes);
    }
  }
}

String _generateCsvData() {
  String out = '#,"0610022839","caliper",,,,,""';
  final realDeviceData = """#,"0610022839","caliper",,,,,""
0.00,"OK","2025/6/14 3:45"
13.03,"OK","2025/6/14 3:45"
""";
  for (double i = 0.0; i < 12 * 4 * 2; i += 1.0) {
    out = '$out\n${i.toStringAsFixed(2)},"OK","2025/6/14 3:46"';
  }
  return out;
}
