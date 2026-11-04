import 'dart:math';
import 'package:flutter/foundation.dart';
import '../models/asset_model.dart';

class AssetProvider with ChangeNotifier {
  final List<AssetModel> _assets = [
    AssetModel(
      id: '1',
      symbol: 'VGT',
      name: 'Vanguard Information Tech',
      amount: 45.0,
      currentPriceUsd: 548.75,
      change24h: 2.4,
      category: 'Teknologi Global',
      sparkline: [535.0, 538.5, 542.0, 540.0, 545.2, 546.8, 548.75],
    ),
    AssetModel(
      id: '2',
      symbol: 'ICLN',
      name: 'Global Clean Energy ETF',
      amount: 220.0,
      currentPriceUsd: 18.90,
      change24h: 1.8,
      category: 'Energi Hijau',
      sparkline: [18.2, 18.4, 18.3, 18.6, 18.5, 18.7, 18.9],
    ),
    AssetModel(
      id: '3',
      symbol: 'BTC',
      name: 'Bitcoin Digital Reserve',
      amount: 0.65,
      currentPriceUsd: 89450.00,
      change24h: 3.2,
      category: 'Aset Digital',
      sparkline: [86000.0, 87200.0, 86800.0, 88100.0, 87900.0, 89100.0, 89450.0],
    ),
    AssetModel(
      id: '4',
      symbol: 'ETH',
      name: 'Ethereum Network',
      amount: 4.2,
      currentPriceUsd: 4150.00,
      change24h: 2.1,
      category: 'Infrastruktur Digital',
      sparkline: [3980.0, 4010.0, 4050.0, 4030.0, 4090.0, 4120.0, 4150.0],
    ),
    AssetModel(
      id: '5',
      symbol: 'SMH',
      name: 'VanEck Semiconductor ETF',
      amount: 35.0,
      currentPriceUsd: 260.40,
      change24h: 4.5,
      category: 'Industri Semikonduktor',
      sparkline: [248.0, 252.0, 250.5, 255.0, 258.0, 259.0, 260.4],
    ),
  ];

  String _selectedTimeframe = '24H';
  final double _usdToIdrRate = 16200.0;

  List<AssetModel> get assets => _assets;
  String get selectedTimeframe => _selectedTimeframe;

  double get totalPortfolioUsd {
    return _assets.fold(0.0, (sum, item) => sum + item.totalValueUsd);
  }

  double get totalPortfolioIdr {
    return totalPortfolioUsd * _usdToIdrRate;
  }

  double get weightedChange24h {
    if (totalPortfolioUsd == 0) return 0;
    double totalWeighted = _assets.fold(0.0, (sum, item) {
      return sum + (item.change24h * item.totalValueUsd);
    });
    return totalWeighted / totalPortfolioUsd;
  }

  void setTimeframe(String tf) {
    _selectedTimeframe = tf;
    notifyListeners();
  }

  void simulateMarketPulse() {
    final rand = Random();
    for (int i = 0; i < _assets.length; i++) {
      final delta = (rand.nextDouble() * 3.0 - 1.2); // -1.2% to +1.8%
      final newPrice = _assets[i].currentPriceUsd * (1 + delta / 100);
      final newChange = _assets[i].change24h + delta;

      final updatedSparkline = List<double>.from(_assets[i].sparkline);
      updatedSparkline.removeAt(0);
      updatedSparkline.add(newPrice);

      _assets[i] = _assets[i].copyWith(
        currentPriceUsd: newPrice,
        change24h: double.parse(newChange.toStringAsFixed(2)),
        sparkline: updatedSparkline,
      );
    }
    notifyListeners();
  }

  void addSimulatedAsset(String symbol, String name, double amount, double price, String category) {
    final newAsset = AssetModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      symbol: symbol.toUpperCase(),
      name: name,
      amount: amount,
      currentPriceUsd: price,
      change24h: 1.5,
      category: category,
      sparkline: [price * 0.96, price * 0.98, price * 0.97, price * 0.99, price],
    );
    _assets.add(newAsset);
    notifyListeners();
  }
}
