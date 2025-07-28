import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:mishwary/models/transaction.dart';

// 1. Provider للوصول إلى "صندوق" قاعدة البيانات
final transactionBoxProvider = Provider<Box<Transaction>>((ref) {
  return Hive.box<Transaction>('transactions');
});

// 2. Provider لجلب قائمة بكل المعاملات لليوم الحالي
final dailyTransactionsProvider = Provider<List<Transaction>>((ref) {
  final box = ref.watch(transactionBoxProvider);
  final today = DateTime.now();
      
  // فلترة المعاملات لتشمل اليوم الحالي فقط
  return box.values.where((transaction) {
    return transaction.date.year == today.year &&
           transaction.date.month == today.month &&
           transaction.date.day == today.day;
  }).toList();
});

// 3. Provider لحساب إجمالي الدخل اليومي
final dailyIncomeProvider = Provider<double>((ref) {
  final dailyTransactions = ref.watch(dailyTransactionsProvider);
  return dailyTransactions
      .where((t) => !t.isExpense) // فلترة الدخل فقط
      .fold(0.0, (sum, item) => sum + item.amount);
});

// 4. Provider لحساب إجمالي المصروفات اليومية
final dailyExpenseProvider = Provider<double>((ref) {
  final dailyTransactions = ref.watch(dailyTransactionsProvider);
  return dailyTransactions
      .where((t) => t.isExpense) // فلترة المصروفات فقط
      .fold(0.0, (sum, item) => sum + item.amount);
});

// 5. Provider لإضافة معاملة جديدة (هذا من نوع مختلف لأنه "يغير" البيانات)
class TransactionNotifier extends Notifier<void> {
  @override
  void build() {
    // لا نحتاج لحالة هنا
  }

  void addTransaction({
    required double amount,
    required String description,
    required String category,
    required bool isExpense,
  }) {
    final box = ref.read(transactionBoxProvider);
    final newTransaction = Transaction(
      id: DateTime.now().toIso8601String(), // رقم تعريفي فريد
      amount: amount,
      date: DateTime.now(),
      description: description,
      category: category,
      isExpense: isExpense,
    );
    box.add(newTransaction);
  }
}

final transactionNotifierProvider = NotifierProvider<TransactionNotifier, void>(() {
  return TransactionNotifier();
});
