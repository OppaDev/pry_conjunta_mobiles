import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:pry_conjunta_mobiles/model/pago_mensual_model.dart';
import 'package:pry_conjunta_mobiles/theme/color_palette.dart'; // Para colores del tema

class PagoChartWidget extends StatelessWidget {
  final List<PagoMensualModel> pagos;

  const PagoChartWidget({Key? key, required this.pagos}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color lineColor = isDarkMode ? modernDarkAccent : modernLightAccent;
    final Color belowBarColor =
        (isDarkMode ? modernDarkAccent : modernLightAccent).withOpacity(0.3);
    final Color textColor = isDarkMode ? modernDarkText : modernLightText;
    final Color gridColor = (isDarkMode ? modernDarkText : modernLightText)
        .withOpacity(0.2);

    if (pagos.isEmpty) {
      return AspectRatio(
        aspectRatio: 1.7,
        child: Center(
          child: Text(
            "No hay datos para mostrar.",
            style: TextStyle(color: textColor),
          ),
        ),
      );
    }

    List<FlSpot> spots =
        pagos.map((pago) => FlSpot(pago.mes.toDouble(), pago.monto)).toList();

    double maxY = 0;
    if (spots.isNotEmpty) {
      maxY = spots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b);
    }
    if (maxY == 0) maxY = 10; // Evitar gráfico plano si todos los montos son 0

    return AspectRatio(
      aspectRatio: 1.7, // Proporción del gráfico
      child: Padding(
        padding: const EdgeInsets.only(
          right: 18.0,
          left: 6.0,
          top: 24,
          bottom: 12,
        ),
        child: LineChart(
          LineChartData(
            gridData: FlGridData(
              show: true,
              drawVerticalLine: true,
              getDrawingHorizontalLine:
                  (value) => FlLine(color: gridColor, strokeWidth: 0.5),
              getDrawingVerticalLine:
                  (value) => FlLine(color: gridColor, strokeWidth: 0.5),
              horizontalInterval: (maxY / 5).ceilToDouble().clamp(
                1.0,
                double.infinity,
              ),
              verticalInterval: (pagos.length /
                      (pagos.length > 10 ? 5.0 : pagos.length.toDouble()))
                  .ceilToDouble()
                  .clamp(1.0, double.infinity),
            ),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  interval: (maxY / 5).ceilToDouble().clamp(
                    1.0,
                    double.infinity,
                  ),
                  getTitlesWidget:
                      (value, meta) => Text(
                        meta.formattedValue, // Usa el valor formateado por el propio eje
                        style: TextStyle(color: textColor, fontSize: 10),
                        textAlign: TextAlign.left,
                      ),
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 30,
                  interval: (pagos.length /
                          (pagos.length > 10 ? 5.0 : pagos.length.toDouble()))
                      .ceilToDouble()
                      .clamp(1.0, double.infinity),
                  getTitlesWidget: (value, meta) {
                    // Solo mostrar si el valor es un mes existente y es un entero
                    if (value.toInt() > 0 &&
                        value.toInt() <= pagos.length &&
                        value == value.toInt().toDouble()) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          value.toInt().toString(),
                          style: TextStyle(color: textColor, fontSize: 10),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border.all(color: gridColor, width: 1),
            ),
            minX: 1,
            maxX: pagos.length.toDouble(),
            minY: 0,
            maxY: maxY * 1.1, // Un poco de espacio por encima del valor máximo
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                color: lineColor,
                barWidth: 3,
                isStrokeCapRound: true,
                dotData: const FlDotData(show: true),
                belowBarData: BarAreaData(show: true, color: belowBarColor),
              ),
            ],
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                getTooltipColor:
                    (touchedSpot) =>
                        Theme.of(context).colorScheme.surface.withOpacity(0.8),
                getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                  return touchedBarSpots.map((barSpot) {
                    return LineTooltipItem(
                      'Mes ${barSpot.x.toInt()}: \$${barSpot.y.toStringAsFixed(2)}',
                      TextStyle(color: textColor, fontWeight: FontWeight.bold),
                    );
                  }).toList();
                },
              ),
              handleBuiltInTouches: true,
            ),
          ),
        ),
      ),
    );
  }
}
