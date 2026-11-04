class AssetModel {
  final String id;
  final String symbol;
  final String name;
  final double amount;
  final double currentPriceUsd;
  final double change24h;
  final String category;
  final List<double> sparkline;

  AssetModel({
    required this.id,
    required this.symbol,
    required this.name,
    required this.amount,
    required this.currentPriceUsd,
    required this.change24h,
    required this.category,
    required this.sparkline,
  });

  double get totalValueUsd => amount * currentPriceUsd;

  AssetModel copyWith({
    String? id,
    String? symbol,
    String? name,
    double? amount,
    double? currentPriceUsd,
    double? change24h,
    String? category,
    List<double>? sparkline,
  }) {
    return AssetModel(
      id: id ?? this.id,
      symbol: symbol ?? this.symbol,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      currentPriceUsd: currentPriceUsd ?? this.currentPriceUsd,
      change24h: change24h ?? this.change24h,
      category: category ?? this.category,
      sparkline: sparkline ?? this.sparkline,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'symbol': symbol,
      'name': name,
      'amount': amount,
      'currentPriceUsd': currentPriceUsd,
      'change24h': change24h,
      'category': category,
      'sparkline': sparkline,
    };
  }

  factory AssetModel.fromJson(Map<String, dynamic> json) {
    return AssetModel(
      id: json['id'] as String,
      symbol: json['symbol'] as String,
      name: json['name'] as String,
      amount: (json['amount'] as num).toDouble(),
      currentPriceUsd: (json['currentPriceUsd'] as num).toDouble(),
      change24h: (json['change24h'] as num).toDouble(),
      category: json['category'] as String,
      sparkline: (json['sparkline'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
    );
  }
}

