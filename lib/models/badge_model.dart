class BadgeItem {
  final String id;
  final String name;
  final String description;
  final String? imageUrl;
  final String? iconUrl;
  final Map<String, dynamic> criteria;
  final String type;
  final int? level;
  final String? expiresAt;
  final String visibility;
  final int? pointsValue;
  final List<String> tags;
  final String createdAtEpochMs;
  final String updatedAtEpochMs;
  final List<String> prerequisites;

  BadgeItem({
    required this.id,
    required this.name,
    required this.description,
    this.imageUrl,
    this.iconUrl,
    required this.criteria,
    required this.type,
    this.level,
    this.expiresAt,
    required this.visibility,
    this.pointsValue,
    required this.tags,
    required this.createdAtEpochMs,
    required this.updatedAtEpochMs,
    required this.prerequisites,
  });

  factory BadgeItem.fromJson(Map<String, dynamic> json) {
    return BadgeItem(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['image_url'],
      iconUrl: json['icon_url'],
      criteria: json['criteria'] != null
          ? Map<String, dynamic>.from(json['criteria'])
          : {},
      type: json['type'],
      level: json['level'],
      expiresAt: json['expires_at'],
      visibility: json['visibility'],
      pointsValue: json['points_value'],
      tags: List<String>.from(json['tags']),
      createdAtEpochMs: json['created_at_epoch_ms'],
      updatedAtEpochMs: json['updated_at_epoch_ms'],
      prerequisites: List<String>.from(json['prerequisites']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image_url': imageUrl,
      'icon_url': iconUrl,
      'criteria': criteria,
      'type': type,
      'level': level,
      'expires_at': expiresAt,
      'visibility': visibility,
      'points_value': pointsValue,
      'tags': tags,
      'created_at_epoch_ms': createdAtEpochMs,
      'updated_at_epoch_ms': updatedAtEpochMs,
      'prerequisites': prerequisites,
    };
  }
}
