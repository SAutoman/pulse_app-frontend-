class Mission {
  final String id;
  final String createdAt;
  final String name;
  final String description;
  final String goalType;
  final int goalValue;
  final String measureUnit;
  final bool isActive;
  final String initialDay;
  final String endDay;
  final String sportType;
  final String imageUrl;

  Mission({
    required this.id,
    required this.createdAt,
    required this.name,
    required this.description,
    required this.goalType,
    required this.goalValue,
    required this.measureUnit,
    required this.isActive,
    required this.initialDay,
    required this.endDay,
    required this.sportType,
    required this.imageUrl,
  });

  factory Mission.fromJson(Map<String, dynamic> json) {
    return Mission(
      id: json['id'],
      createdAt: json['created_at'],
      name: json['name'],
      description: json['description'],
      goalType: json['goal_type'],
      goalValue: json['goal_value'],
      measureUnit: json['measure_unit'],
      isActive: json['is_active'],
      initialDay: json['initial_day'],
      endDay: json['end_day'],
      sportType: json['sport_type'],
      imageUrl: json['image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt,
      'name': name,
      'description': description,
      'goal_type': goalType,
      'goal_value': goalValue,
      'measure_unit': measureUnit,
      'is_active': isActive,
      'initial_day': initialDay,
      'end_day': endDay,
      'sport_type': sportType,
      'image_url': imageUrl,
    };
  }
}
