import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:provider/provider.dart';
import 'package:salon_soft/models/appointments.dart';
import 'package:salon_soft/models/worker.dart';
import 'package:salon_soft/providers/appointment_provider.dart';
import 'package:salon_soft/providers/keys_provider.dart';
import 'package:salon_soft/providers/settings_provider.dart';
import '../components/header.dart';
import '../configurations/scroll_config.dart';
import '../models/appointment.dart';
import '../models/line.dart';
import '../models/time.dart';
import '../utils/slot.dart';
import 'appointment_state_selector.dart';

class LineComponent extends StatelessWidget {
  final ScrollController scroll;
  final double height;
  final double width;
  final Line line;
  final Color borderColor;
  final double timeSlotHeight;
  final TimeSlot timeSlot;
  final Time startTime;
  final Time endTime;
  final double headerHeight;

  const LineComponent({
    Key? key,
    required this.line,
    required this.height,
    required this.width,
    required this.headerHeight,
    required this.borderColor,
    required this.timeSlot,
    required this.timeSlotHeight,
    required this.startTime,
    required this.endTime,
    required this.scroll,
    
  }) : super(key: key);

  double convertTimeToMinutes(Time time) {
    return (time.hour * 60) + time.min.toDouble();
  }

  Time convertDateTimeInTime(DateTime dateTime) {
    return Time(dateTime.hour, dateTime.minute);
  }

  @override
  Widget build(BuildContext context) {
    double maxHeight =
        (((endTime.hour - startTime.hour) * Slot.calc(timeSlot)) * 2) *
            timeSlotHeight /
            2;
    double hourCount =
        (((endTime.hour - startTime.hour) * Slot.calc(timeSlot)) * 1);
    double minutePerSlot = timeSlot == TimeSlot.oclock
        ? 60
        : timeSlot == TimeSlot.thirteen
            ? 30
            : 15;
    double heighPerMinute = (maxHeight / hourCount) / minutePerSlot;

    return Stack(
      children: [
        SizedBox(
          width: width,
          child: ScrollConfiguration(
            behavior: NoSwipeScroll(),
            child: SingleChildScrollView(
              controller: scroll,
              child: ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    height: headerHeight,
                  ),
                  Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border(right: BorderSide(color: borderColor)),
                        ),
                        child: SingleChildScrollView(
                          child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: ((endTime.hour - startTime.hour) *
                                      Slot.calc(timeSlot)) *
                                  2,
                              itemBuilder: (context, index) {
                                return Container(
                                  height: (timeSlotHeight / 2),
                                );
                              }),
                        ),
                      ),

                      for (Appointment appointment in line.appointments)
                        GridItem(
                          appointment,
                          heighPerMinute,
                          () {
                            GlobalKey Gkey = GlobalKey();
                            Provider.of<KeysProvider>(context, listen: false)
                                .keys
                                .putIfAbsent(
                                    appointment.appointments, () => Gkey);
                            return Gkey;
                          }.call(),
                          context,
                        )
                      // Card(
                      //   shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(15)),
                      //   elevation: 5,
                      //   child: Container(
                      //     padding: EdgeInsets.all(10),
                      //     margin: EdgeInsets.only(
                      //       top: timeSlotHeight * Slot.calc(timeSlot),
                      //     ),
                      //     height: timeSlotHeight * Slot.calc(timeSlot),
                      //     width: width,
                      //     decoration: BoxDecoration(
                      //         color: Colors.purple.withAlpha(100),
                      //         borderRadius: BorderRadius.circular(15)),
                      //     child: SizedBox(
                      //       child: Text(
                      //         appointment.title + "- Vitor Medeiros",
                      //         style: const TextStyle(
                      //           // color: Colors.white,
                      //           fontWeight: FontWeight.bold,
                      //           fontSize: 12,
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          child: HeaderComponent(
            header: line.header,
            height: headerHeight,
            width: width,
            worker: line.header.worker,
          ),
        ),
      ],
    );
  }

  Positioned GridItem(Appointment appointment, double heighPerMinute,
      GlobalKey Gkey, BuildContext context) {
    final ScrollController controller = ScrollController();
    SettingsProvider settingsProvider =
        Provider.of<SettingsProvider>(context, listen: false);
    int currentServiceIndex = 0;
    return Positioned(
        key: Gkey,
        top: (convertTimeToMinutes(appointment.start) -
                convertTimeToMinutes(startTime)) *
            heighPerMinute,
        width: width,
        height: (convertTimeToMinutes(appointment.end) -
                convertTimeToMinutes(appointment.start)) *
            heighPerMinute,
        child: InkWell(
          onTap: appointment.onTap,
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 5,
            margin: EdgeInsets.symmetric(horizontal: 5),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Provider.of<SettingsProvider>(context, listen: false)
                    .objectPrivate
                    .getStateColors()[appointment.appointments.situation ?? 0],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: SingleChildScrollView(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if ((convertTimeToMinutes(appointment.end) -
                                        convertTimeToMinutes(
                                            appointment.start)) *
                                    heighPerMinute >=
                                timeSlotHeight)
                              SizedBox(
                                height: timeSlotHeight,
                                child: StatefulBuilder(
                                  builder: (context, setState) => ListTile(
                                    contentPadding:
                                        EdgeInsets.only(left: 16, right: 0),
                                    leading: Icon(Icons.work_outline),
                                    title: Text(
                                      appointment.appointments
                                          .service[currentServiceIndex].name,
                                      softWrap: false,
                                    ),
                                    subtitle: Text(
                                      "${appointment.start.hour.toString().padLeft(2, "0")}:${appointment.start.min.toString().padLeft(2, "0")} ??s ${appointment.end.hour.toString().padLeft(2, "0")}:${appointment.end.min.toString().padLeft(2, "0")}",
                                      softWrap: false,
                                    ),
                                    trailing: !(appointment
                                                .appointments.service.length >
                                            1)
                                        ? null
                                        : FittedBox(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      if (currentServiceIndex >
                                                          0) {
                                                        currentServiceIndex--;
                                                      }
                                                    });
                                                  },
                                                  child: const Icon(
                                                      Icons.keyboard_arrow_up),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      if (currentServiceIndex <
                                                          appointment
                                                                  .appointments
                                                                  .service
                                                                  .length -
                                                              1) {
                                                        currentServiceIndex++;
                                                      }
                                                    });
                                                  },
                                                  child: const Icon(Icons
                                                      .keyboard_arrow_down),
                                                ),
                                              ],
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                            if ((convertTimeToMinutes(appointment.end) -
                                        convertTimeToMinutes(
                                            appointment.start)) *
                                    heighPerMinute >=
                                timeSlotHeight)
                              SizedBox(
                                height: timeSlotHeight,
                                child: ListTile(
                                  leading: Icon(Icons.person_outline),
                                  title: Text(
                                    "Cliente:",
                                    softWrap: false,
                                  ),
                                  subtitle: Text(
                                    appointment.appointments.client.first.name,
                                    softWrap: false,
                                  ),
                                ),
                              ),
                            if (!((convertTimeToMinutes(appointment.end) -
                                        convertTimeToMinutes(
                                            appointment.start)) *
                                    heighPerMinute >=
                                timeSlotHeight))
                              Baseline(
                                baseline: 18,
                                baselineType: TextBaseline.alphabetic,
                                child: Container(
                                  height: (convertTimeToMinutes(
                                          appointment.end) -
                                      convertTimeToMinutes(appointment.start)),
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  child: Text(appointment.title),
                                ),
                              )
                          ],
                        ),
                      ),
                      AppointmentStateSelector(
                        appointment: appointment.appointments,
                        elevation: 0,
                        borderColor: Colors.grey[600]!,
                        borderWidth: 2,
                        iconColor: Colors.grey[600]!,
                      ),
                      Tooltip(
                        message: "Detalhes",
                        child: Container(
                          margin: const EdgeInsets.only(right: 8, top: 8),
                          child: const Icon(
                            Icons.edit_note,
                            size: 25,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}

