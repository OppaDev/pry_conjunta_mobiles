class PagoMensualModel {
  final int mes;
  final double monto;

  PagoMensualModel({
    required this.mes,
    required this.monto,
  });

  @override
  String toString() {
    return 'Mes $mes: \$${monto.toStringAsFixed(2)}';
  }
}
