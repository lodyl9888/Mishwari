import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// سنقوم بإنشاء هذا الملف لاحقًا لإدارة البيانات
// import '../providers/transaction_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // في المستقبل، سنقرأ البيانات الحقيقية من هنا
    // final transactions = ref.watch(transactionListProvider);

    // بيانات مؤقتة للعرض فقط
    final double dailyIncome = 100.0;
    final double dailyExpense = 30.0;
    final double netProfit = dailyIncome - dailyExpense;

    return Scaffold(
      appBar: AppBar(
        title: const Text('مشواري'),
        centerTitle: true,
        elevation: 1,
      ),
      body: Column(
        children: [
          // الجزء العلوي لعرض الملخص اليومي
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

          // هنا سنعرض قائمة المعاملات الفعلية لاحقًا
          Expanded(
            child: Center(
              child: Text('سيتم عرض قائمة المعاملات هنا'),
            ),
          ),
        ],
      ),
      // سنضيف أزرار إضافة الدخل والمصروف هنا لاحقًا
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // سيتم فتح شاشة إضافة معاملة جديدة من هنا
        },
        child: const Icon(Icons.add),
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
