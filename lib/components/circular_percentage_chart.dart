import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CircularPercentageChart extends StatelessWidget {
  final int allValue;
  final int percentageValue;
  final String allvalueLegend;
  final String percentualValueLegend;
  const CircularPercentageChart({
    Key? key,
    required this.allValue,
    required this.percentageValue,
    required this.allvalueLegend,
    required this.percentualValueLegend,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<int> values = [
      (percentageValue * 100) ~/ allValue,
      100 - (percentageValue * 100) ~/ allValue
    ];
    return SfCircularChart(
      legend: Legend(
          // textStyle: TextStyle(fontSize: 10),

          isVisible: true,
          position: LegendPosition.bottom,
          isResponsive: true,
          overflowMode: LegendItemOverflowMode.wrap,
          orientation: LegendItemOrientation.vertical),
      series: <CircularSeries<int, String>>[
        DoughnutSeries(
            dataLabelMapper: (datum, index) => "$datum%",
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
              labelPosition: ChartDataLabelPosition.outside,
            ),
            dataSource: values,
            radius: "50%",
            innerRadius: "65%",
            pointColorMapper: (value, index) {
              return index == 1
                  ? Colors.grey[300]
                  : Theme.of(context).colorScheme.primary;
            },
            xValueMapper: (value, index) =>
                index == 1 ? allvalueLegend : percentualValueLegend,
            yValueMapper: (value, index) => value)
      ],
    );
  }
}
