import 'package:flutter/material.dart';
import 'package:pry_conjunta_mobiles/model/calcular_pagos_model.dart';
import 'package:pry_conjunta_mobiles/model/pago_mensual_model.dart';

class CalcularPagosController extends ChangeNotifier {
  late CalcularPagosModel _modelo;

  // Valores por defecto según el problema y para el formulario
  int _numeroDeMeses = 20;
  double _pagoInicial = 10.0;

  List<PagoMensualModel> _listaPagos = [];
  double _totalPagado = 0.0;
  int? _mesSeleccionadoParaInteraccion; // Para la interacción visual en la lista

  CalcularPagosController() {
    _modelo = CalcularPagosModel(
      totalMeses: _numeroDeMeses,
      pagoInicial: _pagoInicial,
    );
    // Realizar un cálculo inicial con los valores por defecto
    realizarCalculo();
  }

  // Getters para la vista
  int get numeroDeMeses => _numeroDeMeses;
  double get pagoInicial => _pagoInicial;
  List<PagoMensualModel> get listaPagos => _listaPagos;
  double get totalPagado => _totalPagado;
  int? get mesSeleccionadoParaInteraccion => _mesSeleccionadoParaInteraccion;

  // Métodos para actualizar desde el formulario
  void actualizarNumeroDeMeses(String mesesStr) {
    final meses = int.tryParse(mesesStr);
    if (meses != null && meses > 0) {
      _numeroDeMeses = meses;
      // No notificamos aquí, solo al realizar el cálculo
    }
  }

  void actualizarPagoInicial(String pagoStr) {
    final pago = double.tryParse(pagoStr);
    if (pago != null && pago > 0) {
      _pagoInicial = pago;
      // No notificamos aquí, solo al realizar el cálculo
    }
  }

  // Método para manejar la selección de un mes en la lista
  void seleccionarMes(int? mes) {
    if (_mesSeleccionadoParaInteraccion == mes) {
      _mesSeleccionadoParaInteraccion = null; // Deseleccionar si ya está seleccionado
    } else {
      _mesSeleccionadoParaInteraccion = mes;
    }
    notifyListeners();
  }

  // Método principal para ejecutar el cálculo
  void realizarCalculo() {
    // Actualizar el modelo con los valores actuales del controlador
    _modelo.actualizarParametros(
        nuevosMeses: _numeroDeMeses, nuevoPagoInicial: _pagoInicial);
    
    _modelo.calcularPagos();
    _listaPagos = _modelo.pagos;
    _totalPagado = _modelo.totalPagado;
    _mesSeleccionadoParaInteraccion = null; // Resetear selección al recalcular
    notifyListeners(); // Notificar a los oyentes (la vista) que los datos han cambiado
  }
}