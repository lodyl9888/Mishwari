import 'package:hive/hive.dart';

// هذا السطر مهم لـ Hive لإنشاء الكود المساعد تلقائيًا
part 'transaction.g.dart';

@HiveType(typeId: 0)
class Transaction extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late double amount;

  @HiveField(2)
  late DateTime date;

  @HiveField(3)
  late String description;

  @HiveField(4)
  late String category; // "دخل", "بنزين", "صيانة", "شخصي", "أخرى"

  @HiveField(5)
  late bool isExpense; // true للمصروف, false للدخل

  Transaction({
    required this.id,
    required this.amount,
    required this.date,
    required this.description,
    required this.category,
    required this.isExpense,
  });
}
