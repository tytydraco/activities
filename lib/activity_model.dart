class ActivityModel {
  final String activity;
  final String type;

  ActivityModel({
    required this.activity,
    required this.type
  });

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
      activity: json['activity'],
      type: json['type'],
    );
  }
}