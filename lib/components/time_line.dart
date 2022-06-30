import 'package:flutter/material.dart';
import '../configurations/scroll_config.dart';
import '../models/time.dart';
import '../models/time_line_style.dart';
import '../utils/expand_equally.dart';
import '../utils/slot.dart';

class TimeLineComponent extends StatelessWidget {
  final Time startTime;
  final Time endTime;
  final TimeSlot timeSlot;
  final TimeLineStyle style;
  final double height;
  final double width;

  final ScrollController scroll;
  const TimeLineComponent(
      {Key? key,
      required this.startTime,
      this.style = const TimeLineStyle(),
      required this.endTime,
      required this.height,
      required this.width,
      required this.timeSlot,
      required this.scroll})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
          color: style.backgroundColor,
          border: Border(
              right: BorderSide(
                  color:
                      Theme.of(context).colorScheme.primary.withOpacity(0.6)))),
      child: ScrollConfiguration(
        behavior: NoSwipeScroll(),
        child: ListView.builder(
          controller: scroll,
          padding: EdgeInsets.zero,
          itemCount: endTime.hour - startTime.hour,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              margin: EdgeInsets.only(top: index == 0 ? height - 8 : 0),
              height: height * Slot.calc(timeSlot),
              width: width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var i = 1; i <= Slot.calc(timeSlot); i++)
                    Text(
                      startTime.refactor(i, index),
                      style: TextStyle(
                          color: Colors.black.withOpacity(0.6), fontSize: 12),
                    )
                ].expandEqually().toList(),
              ),
            );
          },
        ),
      ),
    );
  }
}
