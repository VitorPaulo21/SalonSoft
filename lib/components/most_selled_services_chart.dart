import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon_soft/providers/date_time_provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../models/appointments.dart';
import '../models/service.dart';
import '../providers/appointment_provider.dart';
import '../providers/services_provider.dart';

class MostSelledServices extends StatefulWidget {
  const MostSelledServices({
    Key? key,
  }) : super(key: key);

  @override
  State<MostSelledServices> createState() => _MostSelledServicesState();
}

class _MostSelledServicesState extends State<MostSelledServices> {
  @override
  Widget build(BuildContext context) {
    ServicesProvider servicesProvider = Provider.of<ServicesProvider>(context);
    DateTimeProvider dateTimeProvider = Provider.of<DateTimeProvider>(context);
    AppointmentProvider appointmentProvider =
        Provider.of<AppointmentProvider>(context);
    Map<Service, Duration> selledServices = {};
    for (Service service in servicesProvider.objects) {
      List<Appointments> toAdd =
          appointmentProvider.getAppointmentsByService(
          dateTimeProvider.currentDateTime, service);
      if (toAdd.isNotEmpty) {
        selledServices.putIfAbsent(
            service,
            () => toAdd.fold<Duration>(
                  Duration(),
                  (previousValue, element) => Duration(
                    minutes: previousValue.inMinutes +
                        element.service
                            .fold<Duration>(
                              Duration(),
                              (previousServiceValue, serviceElement) =>
                                  Duration(
                                minutes: previousServiceValue.inMinutes +
                                    serviceElement.duration.inMinutes,
                              ),
                            )
                            .inMinutes,
                  ),
                ));
      }
    }

    List<MapEntry<Service, Duration>> mostSelledServices = [];
    for (MapEntry<Service, Duration> entry in selledServices.entries) {
      mostSelledServices.add(entry);
    }
    mostSelledServices.sort(
      (a, b) => a.value.compareTo(b.value),
    );
    if (mostSelledServices.length > 3) {
      while (mostSelledServices.length > 3) {
        mostSelledServices.removeLast();
      }
    }
    List<MapEntry<String, int>> dataSource = mostSelledServices
        .map<MapEntry<String, int>>(
            (entry) => MapEntry(entry.key.toString(), entry.value.inMinutes))
        .toList();
    print(selledServices);
    print(mostSelledServices);

    print(dataSource);
    return dataSource.isEmpty
        ? Center(child: Text("Nenhum serviço vendido ainda..."))
        : SfCircularChart(
            legend: Legend(
                // textStyle: TextStyle(fontSize: 10),

                isVisible: true,
                position: LegendPosition.bottom,
                isResponsive: true,
                overflowMode: LegendItemOverflowMode.wrap,
                orientation: LegendItemOrientation.vertical),
            series: <CircularSeries<MapEntry<String, int>, String>>[
              DoughnutSeries(
                  dataLabelMapper: (datum, index) {
                    int thisValue = (datum.value * 100);
                    int totalValue = dataSource.fold<int>(
                        0,
                        (previousValue, element) =>
                            previousValue + element.value);
                    return "${(thisValue / (totalValue <= 0 ? 1 : totalValue)).toStringAsFixed(2)}%";
                  },
                  dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    labelPosition: ChartDataLabelPosition.outside,
                  ),
                  dataSource: dataSource,
                  radius: "50%",
                  innerRadius: "65%",
                  xValueMapper: (value, index) => value.key,
                  yValueMapper: (value, index) => 25)
            ],
          );
  }
}
