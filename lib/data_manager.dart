import 'package:shared_preferences/shared_preferences.dart';

class DataManager {
  static Future<void> saveData(double income, double expense, double personalExpense) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('income', income);
    await prefs.setDouble('expense', expense);
    await prefs.setDouble('personalExpense', personalExpense);
  }

  static Future<Map<String, double>> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'income': prefs.getDouble('income') ?? 0,
      'expense': prefs.getDouble('expense') ?? 0,
      'personalExpense': prefs.getDouble('personalExpense') ?? 0,
    };
  }
}
