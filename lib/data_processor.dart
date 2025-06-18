import 'package:csv/csv.dart';
import 'package:excel/excel.dart';
import 'package:flutter/services.dart';
import 'package:valve_heights_data_converter/cylinder_measurement.dart';

const cylinderSequence = {
  "PS_ME": [
    "A1",
    "B1",
    "A5",
    "B5",
    "A3",
    "B3",
    "A6",
    "B6",
    "A2",
    "B2",
    "A4",
    "B4"
  ],
  "SB_ME": [
    "A1",
    "B4",
    "A4",
    "B2",
    "A2",
    "B6",
    "A6",
    "B3",
    "A3",
    "B5",
    "A5",
    "B1"
  ],
};

const valveSequence = {
  "A,B,C,D": ["A", "B", "C", "D"],
  "B,A,C,D": ["B", "A", "C", "D"],
  "D,C,A,B": ["D", "C", "A", "B"],
  "B,C,A,D": ["B", "C", "A", "D"],
  "D,C,B,A": ["D", "C", "B", "A"],
  "B,D,A,C": ["B", "D", "A", "C"],
  "B,C,D,A": ["B", "C", "D", "A"],
};

const measurementSequence = {
  "stem": ["stem"],
  "rotator": ["rotator"],
};

class DataProcessor {
  final String initCyl;
  final List<String> cylSequence;
  final List<String> valveSequence;
  final List<String> measurementSequence;

  DataProcessor({
    required this.initCyl,
    required this.cylSequence,
    required this.valveSequence,
    required this.measurementSequence,
  });

  Map<String, CylinderMeasurement> convertCsvToDataTable(String csvData) {
    final List<List<dynamic>> rawData = const CsvToListConverter(
      eol: "\n",
      shouldParseNumbers: false,
    ).convert(csvData);
    Map<String, CylinderMeasurement> output = {};
    int dataRowIndex = 1;
    int cylIndex = cylSequence.indexOf(initCyl);
    int totalMeasurements = valveSequence.length * cylSequence.length * 2;

    while (dataRowIndex <= rawData.length && totalMeasurements > 0) {
      totalMeasurements -= 1;
      if (cylIndex >= cylSequence.length) {
        cylIndex = 0;
      }
      final cyl = cylSequence[cylIndex];

      CylinderMeasurement cylMeasure =
          CylinderMeasurement(name: cyl, values: {});
      Map<String, List<double>> valveValues = {};

      for (final valve in valveSequence) {
        if (dataRowIndex >= rawData.length - 1) return output;
        final v1 = double.tryParse(rawData[dataRowIndex][0]) ?? 0;
        final v2 = double.tryParse(rawData[dataRowIndex + 1][0]) ?? 0;

        if (measurementSequence.first == "stem") {
          valveValues.putIfAbsent(valve, () => [v1, v2]);
        } else {
          valveValues.putIfAbsent(valve, () => [v2, v1]);
        }
        dataRowIndex += 2;
      }

      output[cyl] = cylMeasure.copyWith(values: valveValues);
      cylIndex += 1;
    }
    return output;
  }
}


