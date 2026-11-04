import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../theme/app_colors.dart';
import '../providers/asset_provider.dart';
import '../models/asset_model.dart';
import '../widgets/cyber_card.dart';
import '../widgets/cyber_button.dart';

class WealthMatrixScreen extends StatelessWidget {
  const WealthMatrixScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final assetProv = context.watch<AssetProvider>();
    final currencyFormatterUsd = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    final currencyFormatterIdr = NumberFormat.currency(symbol: 'Rp ', decimalDigits: 0, locale: 'id_ID');

    final isGain = assetProv.weightedChange24h >= 0;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Portofolio & Aset',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Sinkronisasi Pasar',
            icon: const Icon(Icons.sync_rounded, color: AppColors.cyan, size: 20),
            onPressed: () {
              assetProv.simulateMarketPulse();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: AppColors.surface,
                  content: Text(
                    'Harga pasar telah diperbarui.',
                    style: GoogleFonts.plusJakartaSans(fontSize: 12, color: AppColors.textPrimary),
                  ),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Total Balance Hero Card
              CyberCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TOTAL VALUASI PORTOFOLIO',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textMuted,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      currencyFormatterUsd.format(assetProv.totalPortfolioUsd),
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '≈ ${currencyFormatterIdr.format(assetProv.totalPortfolioIdr)}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: isGain
                                ? AppColors.neonEmerald.withOpacity(0.12)
                                : AppColors.neonRed.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                isGain ? Icons.trending_up : Icons.trending_down,
                                size: 14,
                                color: isGain ? AppColors.neonEmerald : AppColors.neonRed,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${isGain ? "+" : ""}${assetProv.weightedChange24h.toStringAsFixed(2)}%',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: isGain ? AppColors.neonEmerald : AppColors.neonRed,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '24 Jam Terakhir',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Chart Card
              CyberCard(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Kinerja Portofolio',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Row(
                          children: ['24H', '7D', '30D'].map((tf) {
                            final isSel = assetProv.selectedTimeframe == tf;
                            return GestureDetector(
                              onTap: () => assetProv.setTimeframe(tf),
                              child: Container(
                                margin: const EdgeInsets.only(left: 6),
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: isSel ? AppColors.cyan.withOpacity(0.15) : Colors.transparent,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: isSel ? AppColors.cyan.withOpacity(0.4) : AppColors.cardBorder,
                                  ),
                                ),
                                child: Text(
                                  tf,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 10,
                                    fontWeight: isSel ? FontWeight.w600 : FontWeight.w500,
                                    color: isSel ? AppColors.cyan : AppColors.textMuted,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 140,
                      child: LineChart(
                        LineChartData(
                          gridData: const FlGridData(show: false),
                          titlesData: const FlTitlesData(show: false),
                          borderData: FlBorderData(show: false),
                          lineBarsData: [
                            LineChartBarData(
                              spots: const [
                                FlSpot(0, 112000),
                                FlSpot(1, 114500),
                                FlSpot(2, 113800),
                                FlSpot(3, 117200),
                                FlSpot(4, 116400),
                                FlSpot(5, 120500),
                                FlSpot(6, 122800),
                              ],
                              isCurved: true,
                              color: AppColors.neonEmerald,
                              barWidth: 2.5,
                              dotData: const FlDotData(show: false),
                              belowBarData: BarAreaData(
                                show: true,
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.neonEmerald.withOpacity(0.15),
                                    AppColors.neonEmerald.withOpacity(0.0),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Asset List
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'DAFTAR ASET (${assetProv.assets.length})',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textMuted,
                      letterSpacing: 0.5,
                    ),
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.add_rounded, size: 16, color: AppColors.cyan),
                    label: Text(
                      'Tambah Aset',
                      style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.cyan),
                    ),
                    onPressed: () => _showAddAssetDialog(context, assetProv),
                  ),
                ],
              ),
              const SizedBox(height: 6),

              ...assetProv.assets.map((asset) => _buildAssetTile(asset, currencyFormatterUsd)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAssetTile(AssetModel asset, NumberFormat formatter) {
    final isPos = asset.change24h >= 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: CyberCard(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  asset.symbol.substring(0, 1),
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.cyan,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    asset.symbol,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    asset.name,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${asset.amount} ${asset.symbol}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  formatter.format(asset.totalValueUsd),
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isPos ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                      size: 16,
                      color: isPos ? AppColors.neonEmerald : AppColors.neonRed,
                    ),
                    Text(
                      '${isPos ? "+" : ""}${asset.change24h.toStringAsFixed(1)}%',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isPos ? AppColors.neonEmerald : AppColors.neonRed,
                      ),
                    ),
                  ],
                ),
                Text(
                  '@ ${formatter.format(asset.currentPriceUsd)}',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAddAssetDialog(BuildContext context, AssetProvider assetProv) {
    final symController = TextEditingController();
    final nameController = TextEditingController();
    final amountController = TextEditingController();
    final priceController = TextEditingController();
    String category = 'Teknologi & Infrastruktur';

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppColors.cardBorder),
          ),
          title: Text(
            'Tambah Aset Baru',
            style: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: symController,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: const InputDecoration(labelText: 'Simbol Aset (contoh: TECH)'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: nameController,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: const InputDecoration(labelText: 'Nama Perusahaan / Aset'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: const InputDecoration(labelText: 'Jumlah Unit (Quantity)'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: const InputDecoration(labelText: 'Harga per Unit (USD)'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Batal', style: TextStyle(color: AppColors.textMuted)),
            ),
            CyberButton(
              text: 'Simpan',
              height: 38,
              onPressed: () {
                final sym = symController.text.trim();
                final name = nameController.text.trim();
                final amt = double.tryParse(amountController.text.trim()) ?? 1.0;
                final price = double.tryParse(priceController.text.trim()) ?? 10.0;

                if (sym.isNotEmpty && name.isNotEmpty) {
                  assetProv.addSimulatedAsset(sym, name, amt, price, category);
                }
                Navigator.pop(ctx);
              },
            ),
          ],
        );
      },
    );
  }
}
