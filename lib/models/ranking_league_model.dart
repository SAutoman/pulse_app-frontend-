// --------------------------------------------------------
// ----------------- RANKING LEAGUE -----------------------
// --------------------------------------------------------

class RankingLeague {
  final String id;
  final int level;
  final String categoryId;
  final RankingCategory category;

  RankingLeague({
    required this.id,
    required this.level,
    required this.categoryId,
    required this.category,
  });

  factory RankingLeague.fromJson(Map<String, dynamic> json) {
    return RankingLeague(
      id: json['id'],
      level: json['level'],
      categoryId: json['category_id'],
      category: RankingCategory.fromJson(json['category']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'level': level,
      'category_id': categoryId,
      'category': category.toJson(),
    };
  }
}

// ----------------------------------------------------------
// ----------------- RANKING CATEGORY -----------------------
// ----------------------------------------------------------

class RankingCategory {
  final String id;
  final String name;
  final int order;

  RankingCategory({
    required this.id,
    required this.name,
    required this.order,
  });

  factory RankingCategory.fromJson(Map<String, dynamic> json) {
    return RankingCategory(
      id: json['id'],
      name: json['name'],
      order: json['order'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'order': order,
    };
  }
}
