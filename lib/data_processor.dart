import 'package:csv/csv.dart';

const cylinderSequence = {
  "PS_ME": ["A1", "B1"],
  "SB_ME": ["A1", "B1"],
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
  "rotor": ["rotor"],
};

class DataProcessor {
  final List<String> cylSequence;
  final List<String> valveSequence;
  final List<String> measurementSequence;

  DataProcessor({
    required this.cylSequence,
    required this.valveSequence,
    required this.measurementSequence,
  });

  convertCsvToDataTable(String csvData) {}
}
