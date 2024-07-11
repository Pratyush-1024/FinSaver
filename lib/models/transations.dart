class Transaction {
  final String id;
  final String recipient;
  final double amount;
  final String type;
  final String imageUrl;
  final String transactionId;
  final DateTime date;

  Transaction({
    required this.id,
    required this.recipient,
    required this.amount,
    required this.type,
    required this.imageUrl,
    required this.transactionId,
    required this.date,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['_id'] ?? '',
      recipient: json['recipient'] ?? '',
      amount: (json['amount'] ?? 0.0).toDouble(),
      type: json['type'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      transactionId: json['transactionId'] ?? '',
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'recipient': recipient,
      'amount': amount,
      'type': type,
      'imageUrl': imageUrl,
      'transactionId': transactionId,
      'date': date.toIso8601String(),
    };
  }
}
