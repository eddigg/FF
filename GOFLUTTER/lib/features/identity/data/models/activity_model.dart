
import 'package:equatable/equatable.dart';

class ActivityModel extends Equatable {
  final String type;
  final String title;
  final String time;
  final String icon;

  const ActivityModel({
    required this.type,
    required this.title,
    required this.time,
    required this.icon,
  });

  @override
  List<Object> get props => [type, title, time, icon];

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
      type: json['type'] ?? '',
      title: json['title'] ?? '',
      time: json['time'] ?? '',
      icon: json['icon'] ?? '',
    );
  }
}
