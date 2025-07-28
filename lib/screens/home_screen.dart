import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mishwary/models/transaction.dart'; // سنحتاجه لعرض القائمة
import 'package:mishwary/providers/transaction_provider.dart'; // استيراد العقل المدبر

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // قراءة البيانات الحقيقية من الـ Providers
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
          // الجزء العلوي لعرض الملخص اليومي (يعرض الآن بيانات حقيقية)
          _buildSummaryCard(dailyIncome, dailyExpense, netProfit),

          // عنوان لقائمة المعاملات
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

          // عرض قائمة المعاملات الفعلية
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
                          subtitle: Text(transaction.description),
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
      // سنقوم بتفعيل هذا الزر في الخطوة التالية
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // للتجربة فقط: إضافة معاملة دخل وهمية
          ref.read(transactionNotifierProvider.notifier).addTransaction(
                amount: 50.0,
                description: 'مشوار تجريبي',
                category: 'دخل',
                isExpense: false,
              );
              
          // للتجربة فقط: إضافة معاملة مصروف وهمية
           ref.read(transactionNotifierProvider.notifier).addTransaction(
                amount: 10.0,
                description: 'بنزين تجريبي',
                category: 'بنزين',
                isExpense: true,
              );
        },
        child: const Icon(Icons.add),
        tooltip: 'إضافة معاملة',
      ),
    );
  }

  // ويدجت خاصة لعرض بطاقة الملخص
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

  // ويدجت خاصة لعرض كل عنصر في بطاقة الملخص
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
