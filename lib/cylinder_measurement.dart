class CylinderMeasurement {
  final String name;
  final Map<String, List<double>> values;

  CylinderMeasurement({required this.name, required this.values});

  CylinderMeasurement copyWith({
    String? name,
    Map<String, List<double>>? values,
  }) {
    return CylinderMeasurement(
      name: name ?? this.name,
      values: values ?? this.values,
    );
  }

  @override
  String toString() {
    return '$values'
        .replaceAll("]", "]\n")
        .replaceAll("{", "\n")
        .replaceAll("}", "\n");
  }
}
