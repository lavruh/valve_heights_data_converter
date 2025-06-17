import 'package:flutter/material.dart';
import 'package:valve_heights_data_converter/cylinder_measurement.dart';

class DataPreview extends StatelessWidget {
  const DataPreview({super.key, required this.data});
  final Map<String, CylinderMeasurement> data;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: getChildren("A")),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: getChildren("B")),
        )
      ],
    );
  }

  List<Widget> getChildren(String prefix) {
    List<Widget> out = [];
    for (int i = 0; i <= data.length; i++) {
      final n = "$prefix${i + 1}";
      final cyl = data[n];
      Widget content = Text("$n");
      if (cyl != null) {
        content = Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(cyl.name),
            ),
            Column(
              children: [
                Text("A: ${cyl.values['A']}"),
                Text("B: ${cyl.values['B']}"),
                Text("C: ${cyl.values['C']}"),
                Text("D: ${cyl.values['D']}"),
              ],
            ),
          ],
        );
      }
      out.add(SizedBox(
        width: 150,
        height: 100,
        child: content,
      ));
    }
    return out;
  }
}
