import 'package:pry_conjunta_mobiles/model/pago_mensual_model.dart';

class CalcularPagosModel {
  final int totalMeses;
  final double pagoInicial;
  final double factor;

  List<PagoMensualModel> _pagos = [];

  CalcularPagosModel({
    required this.totalMeses,
    required this.pagoInicial,
    this.factor = 2.0,
  });
}
