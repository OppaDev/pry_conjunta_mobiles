import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:pry_conjunta_mobiles/controller/calcular_pagos_controller.dart';
import 'package:pry_conjunta_mobiles/theme/app_themes.dart';
import 'package:pry_conjunta_mobiles/view/widgets/pago_chart_widget.dart';

class CalculadoraPagosScreen extends StatefulWidget {
  const CalculadoraPagosScreen({Key? key}) : super(key: key);

  @override
  State<CalculadoraPagosScreen> createState() => _CalculadoraPagosScreenState();
}

class _CalculadoraPagosScreenState extends State<CalculadoraPagosScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _mesesController;
  late TextEditingController _pagoInicialController;

  @override
  void initState() {
    super.initState();
    final controller = Provider.of<CalcularPagosController>(context, listen: false);
    _mesesController = TextEditingController(text: controller.numeroDeMeses.toString());
    _pagoInicialController = TextEditingController(text: controller.pagoInicial.toStringAsFixed(0)); // AsFixed(0) para quitar .0 si es entero
  }

  @override
  void dispose() {
    _mesesController.dispose();
    _pagoInicialController.dispose();
    super.dispose();
  }

  void _onCalcular() {
    if (_formKey.currentState!.validate()) {
      // Los valores ya se actualizaron en el controlador a través de onChanged
      // o puedes llamar a los métodos de actualización aquí si prefieres
      // controller.actualizarNumeroDeMeses(_mesesController.text);
      // controller.actualizarPagoInicial(_pagoInicialController.text);
      Provider.of<CalcularPagosController>(context, listen: false).realizarCalculo();
      FocusScope.of(context).unfocus(); // Ocultar teclado
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyles = theme.textTheme;
    final themeExtensions = theme.extension<AppThemeExtensions>();

    // Acceder al controlador
    final controller = Provider.of<CalcularPagosController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora de Pagos'),
        actions: [
          IconButton(
            icon: Icon(
              Provider.of<ThemeNotifier>(context).value == ThemeMode.light
                  ? Icons.dark_mode_outlined
                  : Icons.light_mode_outlined,
            ),
            onPressed: () {
              Provider.of<ThemeNotifier>(context, listen: false).toggleTheme();
            },
          ),
        ],
      ),
      body: Container(
        width: double.infinity, // Asegurar que el Container ocupe todo el ancho
        height: double.infinity, // Asegurar que el Container ocupe todo el alto
        decoration: BoxDecoration(
          gradient: themeExtensions?.backgroundGradient,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- Formulario Interactivo ---
              Card(
                // Si quieres usar el gradiente de la tarjeta:
                // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                // clipBehavior: Clip.antiAlias,
                // child: Container(
                //   decoration: themeExtensions?.cardGradient != null
                //       ? BoxDecoration(gradient: themeExtensions.cardGradient, borderRadius: BorderRadius.circular(16))
                //       : BoxDecoration(color: theme.cardTheme.color, borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Configuración de Pagos", style: textStyles.titleLarge),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _mesesController,
                          decoration: const InputDecoration(
                            labelText: 'Número de Meses',
                            hintText: 'Ej: 20',
                            prefixIcon: Icon(Icons.calendar_today_outlined),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'Ingrese meses';
                            if (int.tryParse(value) == null || int.parse(value) <= 0) return 'Meses inválidos';
                            return null;
                          },
                          onChanged: (value) => controller.actualizarNumeroDeMeses(value),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _pagoInicialController,
                          decoration: const InputDecoration(
                            labelText: 'Pago Inicial (\$)',
                            hintText: 'Ej: 10',
                            prefixIcon: Icon(Icons.attach_money_outlined),
                          ),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
                           validator: (value) {
                            if (value == null || value.isEmpty) return 'Ingrese pago inicial';
                            if (double.tryParse(value) == null || double.parse(value) <= 0) return 'Monto inválido';
                            return null;
                          },
                          onChanged: (value) => controller.actualizarPagoInicial(value),
                        ),
                        const SizedBox(height: 24),
                        Center(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.calculate_outlined),
                            onPressed: _onCalcular,
                            label: const Text('Calcular Pagos'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // --- Resultados ---
              Text('Detalle de Pagos Mensuales:', style: textStyles.titleLarge),
              const SizedBox(height: 10),
              if (controller.listaPagos.isEmpty)
                const Center(child: Padding(padding: EdgeInsets.symmetric(vertical: 20), child: Text("No hay pagos para mostrar.")))
              else
                _buildListaPagos(context, controller),
              
              const SizedBox(height: 16),
              Card(
                 elevation: 2,
                 child: Padding(
                   padding: const EdgeInsets.all(16.0),
                   child: Text(
                    'Total Pagado: \$${controller.totalPagado.toStringAsFixed(2)}',
                    style: textStyles.headlineSmall?.copyWith(
                        color: theme.colorScheme.primary, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                   ),
                 ),
              ),
              const SizedBox(height: 24),

              // --- Gráfico con InteractiveViewer ---
              Text('Crecimiento Exponencial del Pago:', style: textStyles.titleLarge),
              const SizedBox(height: 10),
              if (controller.listaPagos.isNotEmpty)
                Card(
                  elevation: 4,
                  clipBehavior: Clip.antiAlias, // Para que el InteractiveViewer no se salga de los bordes
                  child: InteractiveViewer(
                    panEnabled: true,
                    boundaryMargin: const EdgeInsets.all(20), // Margen para el pan
                    minScale: 0.5,
                    maxScale: 4.0, // Permite hacer zoom hasta 4x
                    child: PagoChartWidget(pagos: controller.listaPagos),
                  ),
                )
              else
                 const Center(child: Padding(padding: EdgeInsets.symmetric(vertical: 20), child: Text("El gráfico se mostrará aquí."))),
              const SizedBox(height: 20), // Espacio al final
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListaPagos(BuildContext context, CalcularPagosController controller) {
    final theme = Theme.of(context);
    return ListView.builder(
      shrinkWrap: true, // Necesario dentro de SingleChildScrollView
      physics: const NeverScrollableScrollPhysics(), // Para evitar scroll anidado
      itemCount: controller.listaPagos.length,
      itemBuilder: (context, index) {
        final pago = controller.listaPagos[index];
        final isSelected = controller.mesSeleccionadoParaInteraccion == pago.mes;

        return Card(
          elevation: isSelected ? 8 : 3, // Más elevación si está seleccionado
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: isSelected 
                ? BorderSide(color: theme.colorScheme.primary, width: 2) 
                : BorderSide(color: theme.dividerColor, width: 0.5),
          ),
          child: InkWell( // Para efecto ripple y onTap
            onTap: () {
              controller.seleccionarMes(pago.mes);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Mes ${pago.mes} seleccionado. Monto: \$${pago.monto.toStringAsFixed(2)}'),
                  duration: const Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            borderRadius: BorderRadius.circular(12), // Para que el ripple coincida con la forma
            splashColor: theme.colorScheme.primary.withOpacity(0.2),
            highlightColor: theme.colorScheme.primary.withOpacity(0.1),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: isSelected ? theme.colorScheme.primary : theme.colorScheme.secondary,
                child: Text(
                  pago.mes.toString(),
                  style: TextStyle(
                    color: isSelected ? theme.colorScheme.onPrimary : theme.colorScheme.onSecondary,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
              title: Text('Mes ${pago.mes}', style: theme.textTheme.titleMedium),
              trailing: Text(
                '\$${pago.monto.toStringAsFixed(2)}',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? theme.colorScheme.primary : theme.textTheme.bodyLarge?.color,
                ),
              ),
              selected: isSelected,
              selectedTileColor: theme.colorScheme.primaryContainer.withOpacity(0.1),
            ),
          ),
        );
      },
    );
  }
}