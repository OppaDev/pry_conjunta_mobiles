import 'package:pry_conjunta_mobiles/model/pago_mensual_model.dart';
import 'dart:math';

class CalcularPagosModel {
  int totalMeses;
  double pagoInicial;
  final double factor; // Factor de multiplicación para el crecimiento exponencial

  List<PagoMensualModel> _pagos = [];
  double _totalPagado = 0.0;

  CalcularPagosModel({
    required this.totalMeses,
    required this.pagoInicial,
    this.factor = 2.0, // El problema indica que se duplica (10, 20, 40...)
  });

  // Getters para acceder a los resultados
  List<PagoMensualModel> get pagos => List.unmodifiable(_pagos);
  double get totalPagado => _totalPagado;

  void calcularPagos() {
    _pagos.clear();
    _totalPagado = 0.0;
    double montoMesActual = pagoInicial;

    if (totalMeses <= 0 || pagoInicial <= 0) {
      // No calcular si los parámetros no son válidos
      return;
    }

    for (int i = 1; i <= totalMeses; i++) {
      _pagos.add(PagoMensualModel(mes: i, monto: montoMesActual));
      _totalPagado += montoMesActual;

      // Preparar el monto para el siguiente mes, si no es el último
      if (i < totalMeses) {
        montoMesActual *= factor;
      }
    }
  }

  // Método para actualizar los parámetros si es necesario desde fuera (opcional)
  void actualizarParametros({required int nuevosMeses, required double nuevoPagoInicial}) {
    this.totalMeses = nuevosMeses;
    this.pagoInicial = nuevoPagoInicial;
  }
}
