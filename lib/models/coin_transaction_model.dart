class CoinTransaction {
  final String id;
  final String userId;
  final int amount;
  final String type;
  final String description;
  final String createdAtEpochMs;

  CoinTransaction({
    required this.id,
    required this.userId,
    required this.amount,
    required this.type,
    required this.description,
    required this.createdAtEpochMs,
  });

  factory CoinTransaction.fromJson(Map<String, dynamic> json) {
    return CoinTransaction(
      id: json['id'],
      userId: json['user_id'],
      amount: json['amount'],
      type: json['type'],
      description: json['description'],
      createdAtEpochMs: json['created_at_epoch_ms'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user_id': userId,
      'amount': amount,
      'type': type,
      'description': description,
      'created_at_epoch_ms': createdAtEpochMs,
    };
  }
}
