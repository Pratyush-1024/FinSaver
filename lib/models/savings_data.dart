class SavingsData {
  final String month;
  final double balance;
  final double amountSpent;

  SavingsData({
    required this.month,
    required this.balance,
    required this.amountSpent,
  });

  factory SavingsData.fromJson(Map<String, dynamic> json) {
    return SavingsData(
      month: json['month'] ?? '',
      balance: json['balance']?.toDouble() ?? 0.0,
      amountSpent: json['amountSpent']?.toDouble() ?? 0.0,
    );
  }
}
