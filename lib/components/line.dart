import 'package:flutter/material.dart';
import '../components/header.dart';
import '../configurations/scroll_config.dart';
import '../models/appointment.dart';
import '../models/line.dart';
import '../models/time.dart';
import '../utils/slot.dart';

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

  @override
  Widget build(BuildContext context) {
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
                        Container(
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.only(
                              top: timeSlotHeight * Slot.calc(timeSlot),
                              left: 5,
                              right: 5),
                          height: timeSlotHeight * Slot.calc(timeSlot),
                          width: width,
                          decoration: BoxDecoration(
                              color: Colors.purple.withAlpha(100),
                              borderRadius: BorderRadius.circular(15)),
                          child: SizedBox(
                            child: Text(
                              appointment.title + "- Vitor Medeiros",
                              style: const TextStyle(
                                // color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        )
                    ],
                  )
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
          ),
        ),
      ],
    );
  }
}
