import 'dart:ui';

class Meeting {
  Meeting(this.eventName, this.description, this.from, this.to, this.background,
      this.isAllDay);

  String description;
  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}
