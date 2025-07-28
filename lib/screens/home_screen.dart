import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mishwary/providers/transaction_provider.dart';
import 'package:mishwary/screens/add_transaction_sheet.dart'; // استيراد واجهة الإدخال

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void _openAddTransactionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // مهم ليظهر النموذج فوق لوحة المفاتيح
      builder: (_) => const AddTransactionSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dailyTransactions = ref.watch(dailyTransactionsProvider);
    final dailyIncome = ref.watch(dailyIncomeProvider);
    final dailyExpense = ref.watch(dailyExpenseProvider);
    final double netProfit = dailyIncome - dailyExpense;

    return Scaffold(
      appBar: AppBar(
        title: const Text('مشواري'),
        centerTitle: true,
        elevation: 1,
      ),
      body: Column(
        children: [
          _buildSummaryCard(dailyIncome, dailyExpense, netProfit),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(Icons.list_alt_rounded),
                SizedBox(width: 8),
                Text('معاملات اليوم', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Expanded(
            child: dailyTransactions.isEmpty
                ? const Center(
                    child: Text('لا توجد معاملات اليوم. ابدأ بإضافة واحدة!'),
                  )
                : ListView.builder(
                    itemCount: dailyTransactions.length,
                    itemBuilder: (context, index) {
                      final transaction = dailyTransactions[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: ListTile(
                          leading: Icon(
                            transaction.isExpense ? Icons.arrow_downward : Icons.arrow_upward,
                            color: transaction.isExpense ? Colors.red : Colors.green,
                          ),
                          title: Text(transaction.category),
                          subtitle: transaction.description.isEmpty ? null : Text(transaction.description),
                          trailing: Text(
                            '${transaction.isExpense ? '-' : '+'}${transaction.amount.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: transaction.isExpense ? Colors.red : Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAddTransactionSheet(context), // تم التعديل هنا
        child: const Icon(Icons.add),
        tooltip: 'إضافة معاملة',
      ),
    );
  }

  Widget _buildSummaryCard(double income, double expense, double netProfit) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildSummaryItem('الدخل', '▲ ${income.toStringAsFixed(2)}', Colors.green),
            _buildSummaryItem('المصروف', '▼ ${expense.toStringAsFixed(2)}', Colors.red),
            _buildSummaryItem('الصافي', '💰 ${netProfit.toStringAsFixed(2)}', Colors.blue),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String title, String value, Color color) {
    return Column(
      children: [
        Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }
}
