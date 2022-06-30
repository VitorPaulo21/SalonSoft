import 'package:flutter/material.dart';
import '../components/line.dart';
import '../components/time_line.dart';
import '../configurations/scroll_config.dart';
import '../models/line.dart';
import '../models/time.dart';
import '../models/time_line_style.dart';
import '../scroll_engine.dart';
import '../utils/slot.dart';

class TeamCalendar extends StatefulWidget {
  final List<Line> resources;

  final Time startTime;
  final Time endTime;

  final double lineWidth;

  final TimeSlot timeSlot;

  final double timeSlotHeight;
  final double timeSlotWidth;

  final TimeLineStyle timeLineStyle;

  const TeamCalendar({
    Key? key,
    this.resources = const <Line>[],
    required this.startTime,
    required this.endTime,
    this.lineWidth = 200,
    this.timeLineStyle = const TimeLineStyle(),
    this.timeSlotHeight = 50,
    this.timeSlotWidth = 48,
    this.timeSlot = TimeSlot.thirteen,
  }) : super(key: key);

  @override
  State<TeamCalendar> createState() => _TeamCalendarState();
}

late ScrollLinker _scrollLinker;
List<ScrollController> _scrollControllers = <ScrollController>[];

class _TeamCalendarState extends State<TeamCalendar> {
  @override
  void initState() {
    super.initState();
    _scrollLinker = ScrollLinker();

    _scrollControllers.add(ScrollController());
    _scrollControllers[0] = _scrollLinker.addAndGet();

    for (int i = 0; i < widget.resources.length; i++) {
      _scrollControllers.add(ScrollController());
      _scrollControllers[i + 1] = _scrollLinker.addAndGet();
    }

    _lineHeight = (Slot.calc(widget.timeSlot) * widget.timeSlotHeight);
  }

  @override
  void dispose() {
    for (ScrollController controller in _scrollControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  late double _lineHeight;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 1000,
        child: Stack(
          children: [
            ScrollConfiguration(
              behavior: NoSwipeScroll(),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.resources.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return SizedBox(
                      width: widget.timeSlotWidth,
                    );
                  } else {
                    return LineComponent(
                      scroll: _scrollControllers[index],
                      line: widget.resources[index - 1],
                      height: _lineHeight,
                      headerHeight: widget.timeSlotHeight,
                      borderColor: Colors.grey,
                      timeSlot: widget.timeSlot,
                      timeSlotHeight: widget.timeSlotHeight,
                      startTime: widget.startTime,
                      endTime: widget.endTime,
                      width: widget.lineWidth,
                    );
                  }
                },
              ),
            ),
            TimeLineComponent(
              startTime: widget.startTime,
              endTime: widget.endTime,
              timeSlot: widget.timeSlot,
              height: widget.timeSlotHeight,
              width: widget.timeSlotWidth,
              scroll: _scrollControllers[0],
              style: widget.timeLineStyle,
            ),
          ],
        ));
  }
}
