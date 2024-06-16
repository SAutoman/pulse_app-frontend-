class SportType {
  String id;
  DateTime createdAt;
  String name;
  String? description;

  SportType({
    required this.id,
    required this.createdAt,
    required this.name,
    this.description,
  });

  // Factory constructor to create a SportType instance from a map (deserialize)
  factory SportType.fromJson(Map<String, dynamic> json) {
    return SportType(
      id: json['id'],
      createdAt: DateTime.parse(json['created_at']),
      name: json['name'],
      description: json['description'],
    );
  }

  // Method to convert a SportType instance into a map (serialize)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt.toIso8601String(),
      'name': name,
      'description': description,
    };
  }
}
