import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Mi Primera App'),
          backgroundColor: Colors.indigo,
        ),
        body: const PaginaPrincipal(),
      ),
    );
  }
}

class PaginaPrincipal extends StatelessWidget {
  const PaginaPrincipal({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(20.0),
            margin: const EdgeInsets.symmetric(horizontal: 20.0),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.favorite, color: Colors.red, size: 30.0),
                SizedBox(width: 10),
                Text(
                  '¡Hola, Flutter!',
                  style: TextStyle(fontSize: 28.0, color: Colors.indigo),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SegundaPantalla(),
                ),
              );
              const snackBar = SnackBar(
                content: Text('¡Bienvenido a la segunda pagina! 🎉'),
                duration: Duration(seconds: 6),
                backgroundColor: Colors.indigo,
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
            child: const Text('Presióname'),
          ),
        ],
      ),
    );
  }
}

class SegundaPantalla extends StatefulWidget {
  const SegundaPantalla({super.key});

  @override
  State<SegundaPantalla> createState() => _SegundaPantallaState();
}

class _SegundaPantallaState extends State<SegundaPantalla> {
  final TextEditingController _numero1Controller = TextEditingController();
  final TextEditingController _numero2Controller = TextEditingController();
  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();

  // Resultados
  String _operacionRealizada = '';
  String _resultadoPrincipal = '';
  String _resultadosAdicionales = '';
  String _mensajeError = '';

  // Validar entradas
  bool _validarEntradas() {
    if (_numero1Controller.text.isEmpty || _numero2Controller.text.isEmpty) {
      _mostrarError('Por favor, ingresa ambos números');
      return false;
    }

    double? num1 = double.tryParse(_numero1Controller.text);
    double? num2 = double.tryParse(_numero2Controller.text);

    if (num1 == null || num2 == null) {
      _mostrarError('Por favor, ingresa números válidos');
      return false;
    }

    return true;
  }

  void _mostrarError(String mensaje) {
    setState(() {
      _mensajeError = mensaje;
      _operacionRealizada = '';
      _resultadoPrincipal = '';
      _resultadosAdicionales = '';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(mensaje)),
          ],
        ),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _mostrarExito(String operacion) {
    _focusNode1.unfocus();
    _focusNode2.unfocus();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Text('$operacion calculada exitosamente'),
          ],
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _calcularSuma() {
    if (!_validarEntradas()) return;

    double num1 = double.parse(_numero1Controller.text);
    double num2 = double.parse(_numero2Controller.text);
    double resultado = num1 + num2;

    setState(() {
      _mensajeError = '';
      _operacionRealizada = '$num1 + $num2';
      _resultadoPrincipal = resultado.toString();
      _resultadosAdicionales = '';
    });

    _mostrarExito('Suma');
  }

  void _calcularResta() {
    if (!_validarEntradas()) return;

    double num1 = double.parse(_numero1Controller.text);
    double num2 = double.parse(_numero2Controller.text);
    double resultado = num1 - num2;

    setState(() {
      _mensajeError = '';
      _operacionRealizada = '$num1 - $num2';
      _resultadoPrincipal = resultado.toString();
      _resultadosAdicionales = '';
    });

    _mostrarExito('Resta');
  }

  void _calcularMultiplicacion() {
    if (!_validarEntradas()) return;

    double num1 = double.parse(_numero1Controller.text);
    double num2 = double.parse(_numero2Controller.text);
    double resultado = num1 * num2;

    setState(() {
      _mensajeError = '';
      _operacionRealizada = '$num1 × $num2';
      _resultadoPrincipal = resultado.toString();
      _resultadosAdicionales = '';
    });

    _mostrarExito('Multiplicación');
  }

  void _calcularDivision() {
    if (!_validarEntradas()) return;

    double num1 = double.parse(_numero1Controller.text);
    double num2 = double.parse(_numero2Controller.text);

    if (num2 == 0) {
      _mostrarError('Error: No se puede dividir por cero');
      return;
    }

    double cociente = num1 / num2;
    int cocienteEntero = num1 ~/ num2;
    double residuo = num1 % num2;

    setState(() {
      _mensajeError = '';
      _operacionRealizada = '$num1 ÷ $num2';
      _resultadoPrincipal = cociente.toString();
      _resultadosAdicionales =
          'Cociente entero: $cocienteEntero\nResiduo: ${residuo.toStringAsFixed(2)}';
    });

    _mostrarExito('División');
  }

  void _calcularPotenciacion() {
    if (!_validarEntradas()) return;

    double base = double.parse(_numero1Controller.text);
    double exponente = double.parse(_numero2Controller.text);

    double resultado = math.pow(base, exponente).toDouble();

    setState(() {
      _mensajeError = '';
      _operacionRealizada = '$base^$exponente';
      _resultadoPrincipal = resultado.toString();
      _resultadosAdicionales = '';
    });

    _mostrarExito('Potenciación');
  }

  void _calcularRaiz() {
    if (!_validarEntradas()) return;

    double radicando = double.parse(_numero1Controller.text);
    double indice = double.parse(_numero2Controller.text);

    if (radicando < 0 && indice % 2 == 0) {
      _mostrarError('Error: No se puede calcular raíz par de número negativo');
      return;
    }

    if (indice == 0) {
      _mostrarError('Error: El índice de la raíz no puede ser cero');
      return;
    }

    double resultado;
    if (indice == 2) {
      resultado = math.sqrt(radicando);
    } else {
      resultado = math.pow(radicando, 1 / indice).toDouble();
    }

    setState(() {
      _mensajeError = '';
      _operacionRealizada = '${indice}√$radicando';
      _resultadoPrincipal = resultado.toString();
      _resultadosAdicionales = '';
    });

    _mostrarExito('Radicación');
  }

  void _limpiarCampos() {
    setState(() {
      _numero1Controller.clear();
      _numero2Controller.clear();
      _operacionRealizada = '';
      _resultadoPrincipal = '';
      _resultadosAdicionales = '';
      _mensajeError = '';
    });
  }

  Widget _buildOperationButton(
    String text,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        shadowColor: color.withValues(alpha: 0.4),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20),
          const SizedBox(height: 4),
          Text(
            text,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _numero1Controller.dispose();
    _numero2Controller.dispose();
    _focusNode1.dispose();
    _focusNode2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Calculadora',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        backgroundColor: Colors.indigo,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.indigo.shade50, Colors.white],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Título de la sección
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: const Text(
                    'Calculadora Avanzada',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 24),

                // Campo para el primer número
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.indigo.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _numero1Controller,
                    focusNode: _focusNode1,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Primer Número',
                      labelStyle: TextStyle(
                        color: Colors.indigo.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                      prefixIcon: Icon(
                        Icons.looks_one,
                        color: Colors.indigo.shade600,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Icono de suma
                Container(
                  alignment: Alignment.center,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.indigo.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.add,
                      color: Colors.indigo.shade700,
                      size: 24,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Campo para el segundo número
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.indigo.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _numero2Controller,
                    focusNode: _focusNode2,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Segundo Número / Exponente / Índice',
                      labelStyle: TextStyle(
                        color: Colors.indigo.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                      prefixIcon: Icon(
                        Icons.looks_two,
                        color: Colors.indigo.shade600,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Botones de operaciones matemáticas
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.indigo.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Operaciones Matemáticas',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo.shade700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),

                      // Primera fila de botones
                      Row(
                        children: [
                          Expanded(
                            child: _buildOperationButton(
                              '+ Suma',
                              Icons.add,
                              Colors.green,
                              _calcularSuma,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildOperationButton(
                              '- Resta',
                              Icons.remove,
                              Colors.orange,
                              _calcularResta,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Segunda fila de botones
                      Row(
                        children: [
                          Expanded(
                            child: _buildOperationButton(
                              '× Multiplicar',
                              Icons.close,
                              Colors.purple,
                              _calcularMultiplicacion,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildOperationButton(
                              '÷ Dividir',
                              Icons.horizontal_rule,
                              Colors.red,
                              _calcularDivision,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Tercera fila de botones
                      Row(
                        children: [
                          Expanded(
                            child: _buildOperationButton(
                              '^  Potencia',
                              Icons.trending_up,
                              Colors.blue,
                              _calcularPotenciacion,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildOperationButton(
                              '√ Raíz',
                              Icons.functions,
                              Colors.teal,
                              _calcularRaiz,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Botón limpiar
                      OutlinedButton(
                        onPressed: _limpiarCampos,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.indigo,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: BorderSide(
                            color: Colors.indigo.shade300,
                            width: 2,
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.clear_all, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Limpiar Todo',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Área de resultados
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.indigo.shade600, Colors.indigo.shade800],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.indigo.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.calculate, color: Colors.white, size: 24),
                          SizedBox(width: 8),
                          Text(
                            'Resultados',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Mensaje de error
                      if (_mensajeError.isNotEmpty) ...[
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.red.shade100,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.red.shade300),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.error, color: Colors.red.shade700),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _mensajeError,
                                  style: TextStyle(
                                    color: Colors.red.shade700,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      // Operación realizada
                      if (_operacionRealizada.isNotEmpty) ...[
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Operación: $_operacionRealizada',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],

                      // Resultado principal
                      if (_resultadoPrincipal.isNotEmpty) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Resultado Principal',
                                style: TextStyle(
                                  color: Colors.indigo.shade600,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _resultadoPrincipal,
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.indigo.shade800,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ],

                      // Resultados adicionales
                      if (_resultadosAdicionales.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Detalles Adicionales:',
                                style: TextStyle(
                                  color: Colors.indigo.shade700,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _resultadosAdicionales,
                                style: TextStyle(
                                  color: Colors.indigo.shade600,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      // Mensaje por defecto si no hay resultados
                      if (_operacionRealizada.isEmpty &&
                          _mensajeError.isEmpty) ...[
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                            ),
                          ),
                          child: const Column(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: Colors.white,
                                size: 32,
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Ingresa dos números y selecciona una operación para ver los resultados aquí',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Botón volver
                ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.arrow_back, size: 20),
                  label: const Text(
                    'Volver Atrás',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
