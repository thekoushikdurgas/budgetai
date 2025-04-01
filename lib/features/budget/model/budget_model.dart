import 'dart:convert';

class BudgetModel {
  final String id;
  final double monthlySalary;
  final DateTime startDate;
  final Map<String, double> categoryAllocations;
  final double dailySpendingLimit;
  final List<BudgetSuggestion> suggestions;

  BudgetModel({
    required this.id,
    required this.monthlySalary,
    required this.startDate,
    required this.categoryAllocations,
    required this.dailySpendingLimit,
    this.suggestions = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'monthlySalary': monthlySalary,
      'startDate': startDate.toIso8601String(),
      'categoryAllocations': categoryAllocations,
      'dailySpendingLimit': dailySpendingLimit,
      'suggestions': suggestions.map((s) => s.toMap()).toList(),
    };
  }

  factory BudgetModel.fromMap(Map<String, dynamic> map) {
    return BudgetModel(
      id: map['id'],
      monthlySalary: map['monthlySalary'],
      startDate: DateTime.parse(map['startDate']),
      categoryAllocations: Map<String, double>.from(map['categoryAllocations']),
      dailySpendingLimit: map['dailySpendingLimit'],
      suggestions: map['suggestions'] != null
          ? List<BudgetSuggestion>.from(
              map['suggestions']?.map((x) => BudgetSuggestion.fromMap(x)))
          : [],
    );
  }

  String toJson() => json.encode(toMap());

  factory BudgetModel.fromJson(String source) =>
      BudgetModel.fromMap(json.decode(source));

  BudgetModel copyWith({
    String? id,
    double? monthlySalary,
    DateTime? startDate,
    Map<String, double>? categoryAllocations,
    double? dailySpendingLimit,
    List<BudgetSuggestion>? suggestions,
  }) {
    return BudgetModel(
      id: id ?? this.id,
      monthlySalary: monthlySalary ?? this.monthlySalary,
      startDate: startDate ?? this.startDate,
      categoryAllocations: categoryAllocations ?? this.categoryAllocations,
      dailySpendingLimit: dailySpendingLimit ?? this.dailySpendingLimit,
      suggestions: suggestions ?? this.suggestions,
    );
  }
}

class BudgetSuggestion {
  final String category;
  final double amount;
  final String reason;

  BudgetSuggestion({
    required this.category,
    required this.amount,
    required this.reason,
  });

  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'amount': amount,
      'reason': reason,
    };
  }

  factory BudgetSuggestion.fromMap(Map<String, dynamic> map) {
    return BudgetSuggestion(
      category: map['category'],
      amount: map['amount'],
      reason: map['reason'],
    );
  }
}

class SpendingCategory {
  static const String housing = 'Housing';
  static const String food = 'Food';
  static const String transportation = 'Transportation';
  static const String utilities = 'Utilities';
  static const String healthcare = 'Healthcare';
  static const String entertainment = 'Entertainment';
  static const String personal = 'Personal';
  static const String savings = 'Savings';
  static const String debt = 'Debt';
  static const String other = 'Other';

  static List<String> getAllCategories() {
    return [
      housing,
      food,
      transportation,
      utilities,
      healthcare,
      entertainment,
      personal,
      savings,
      debt,
      other,
    ];
  }
}
