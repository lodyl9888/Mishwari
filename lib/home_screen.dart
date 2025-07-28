import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double _income = 0;
  double _expenses = 0;
  double _personalExpenses = 0;

  final _incomeController = TextEditingController();
  final _expenseController = TextEditingController();
  final _personalController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _income = prefs.getDouble('income') ?? 0;
      _expenses = prefs.getDouble('expenses') ?? 0;
      _personalExpenses = prefs.getDouble('personalExpenses') ?? 0;
    });
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('income', _income);
    await prefs.setDouble('expenses', _expenses);
    await prefs.setDouble('personalExpenses', _personalExpenses);
  }

  void _addTransaction(TextEditingController controller, Function(double) updateState) {
    final amount = double.tryParse(controller.text) ?? 0;
    if (amount > 0) {
      setState(() {
        updateState(amount);
        controller.clear();
        _saveData();
      });
    }
  }
      
  void _resetData() {
    setState(() {
      _income = 0;
      _expenses = 0;
      _personalExpenses = 0;
      _saveData();
    });
  }

  @override
  Widget build(BuildContext context) {
    double net = _income - _expenses - _personalExpenses;
    final currencyFormat = NumberFormat.currency(locale: 'ar_EG', symbol: 'ج.م');

    return Scaffold(
      appBar: AppBar(
        title: const Text('مشواري - الدخل والمصروفات'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetData,
            tooltip: 'تصفير البيانات',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              summaryTile("إجمالي الدخل", _income, currencyFormat, Colors.green),
              summaryTile("المصروفات التشغيلية", _expenses, currencyFormat, Colors.red),
              summaryTile("المصروفات الشخصية", _personalExpenses, currencyFormat, Colors.orange),
              const Divider(height: 30, thickness: 1),
              summaryTile("الصافي", net, currencyFormat, net >= 0 ? Colors.blue : Colors.red, isNet: true),
              const SizedBox(height: 20),
              inputSection("إضافة دخل", _incomeController, () => _addTransaction(_incomeController, (amount) => _income += amount)),
              inputSection("إضافة مصروف تشغيلي", _expenseController, () => _addTransaction(_expenseController, (amount) => _expenses += amount)),
              inputSection("إضافة مصروف شخصي", _personalController, () => _addTransaction(_personalController, (amount) => _personalExpenses += amount)),
            ],
          ),
        ),
      ),
    );
  }

  Widget inputSection(String label, TextEditingController controller, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: label,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text("أضف"),
          )
        ],
      ),
    );
  }

  Widget summaryTile(String title, double amount, NumberFormat format, Color color, {bool isNet = false}) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        trailing: Text(
          format.format(amount),
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: isNet ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
