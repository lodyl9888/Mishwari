import 'package:flutter/material.dart';
import 'data_manager.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double income = 0;
  double expense = 0;
  double personalExpense = 0;

  final incomeController = TextEditingController();
  final expenseController = TextEditingController();
  final personalExpenseController = TextEditingController();

  @override
  void initState() {
    super.initState();
    DataManager.loadData().then((data) {
      setState(() {
        income = data['income'];
        expense = data['expense'];
        personalExpense = data['personalExpense'];
      });
    });
  }

  void updateData() {
    DataManager.saveData(income, expense, personalExpense);
  }

  @override
  Widget build(BuildContext context) {
    double total = income - expense - personalExpense;

    return Scaffold(
      appBar: AppBar(
        title: Text("Mashro3y"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            buildInput("دخل جديد", incomeController, () {
              setState(() {
                income += double.tryParse(incomeController.text) ?? 0;
                incomeController.clear();
                updateData();
              });
            }),
            buildInput("مصروف جديد", expenseController, () {
              setState(() {
                expense += double.tryParse(expenseController.text) ?? 0;
                expenseController.clear();
                updateData();
              });
            }),
            buildInput("مصروف شخصي", personalExpenseController, () {
              setState(() {
                personalExpense += double.tryParse(personalExpenseController.text) ?? 0;
                personalExpenseController.clear();
                updateData();
              });
            }),
            SizedBox(height: 20),
            Text("💰 الدخل: $income"),
            Text("💸 المصروفات: $expense"),
            Text("👤 المصروف الشخصي: $personalExpense"),
            Text("🧾 الصافي: $total", style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget buildInput(String label, TextEditingController controller, VoidCallback onPressed) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(labelText: label),
            keyboardType: TextInputType.number,
          ),
        ),
        SizedBox(width: 10),
        ElevatedButton(onPressed: onPressed, child: Text("أضف"))
      ],
    );
  }
}
