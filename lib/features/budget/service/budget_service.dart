import 'package:budgetai/features/budget/model/budget_model.dart';
import 'package:uuid/uuid.dart';

class BudgetService {
  static final BudgetService _instance = BudgetService._internal();

  factory BudgetService() => _instance;

  BudgetService._internal();

  // Create a new budget with AI recommendations
  Future<BudgetModel> createBudget(
      double monthlySalary, DateTime startDate) async {
    // Generate a unique ID
    final String id = const Uuid().v4();

    // Get AI recommended category allocations
    final Map<String, double> categoryAllocations =
        _generateCategoryAllocations(monthlySalary);

    // Calculate daily spending limit based on the month
    final double dailyLimit =
        _calculateDailySpendingLimit(monthlySalary, startDate);

    // Generate AI budget suggestions
    final List<BudgetSuggestion> suggestions =
        _generateBudgetSuggestions(monthlySalary, categoryAllocations);

    // Create and return the budget model
    return BudgetModel(
      id: id,
      monthlySalary: monthlySalary,
      startDate: startDate,
      categoryAllocations: categoryAllocations,
      dailySpendingLimit: dailyLimit,
      suggestions: suggestions,
    );
  }

  // Generate AI-recommended category allocations
  Map<String, double> _generateCategoryAllocations(double monthlySalary) {
    // This would normally use a more sophisticated AI model,
    // but for now we'll use a standard percentage-based allocation
    final Map<String, double> allocations = {
      SpendingCategory.housing: monthlySalary * 0.30, // 30% for housing
      SpendingCategory.food: monthlySalary * 0.15, // 15% for food
      SpendingCategory.transportation:
          monthlySalary * 0.10, // 10% for transportation
      SpendingCategory.utilities: monthlySalary * 0.05, // 5% for utilities
      SpendingCategory.healthcare: monthlySalary * 0.05, // 5% for healthcare
      SpendingCategory.entertainment:
          monthlySalary * 0.05, // 5% for entertainment
      SpendingCategory.personal: monthlySalary * 0.05, // 5% for personal
      SpendingCategory.savings: monthlySalary * 0.20, // 20% for savings
      SpendingCategory.debt: monthlySalary * 0.05, // 5% for debt
    };

    return allocations;
  }

  // Calculate daily spending limit based on month length
  double _calculateDailySpendingLimit(
      double monthlySalary, DateTime startDate) {
    // Get the number of days in the month
    final int daysInMonth =
        DateTime(startDate.year, startDate.month + 1, 0).day;

    // Remove savings and housing from the calculation, as these are typically monthly fixed costs
    final double disposableIncome = monthlySalary -
        (monthlySalary * 0.20) // Subtract savings
        -
        (monthlySalary * 0.30); // Subtract housing

    // Calculate daily limit (rounded to 2 decimal places)
    return double.parse((disposableIncome / daysInMonth).toStringAsFixed(2));
  }

  // Generate budget suggestions based on the salary and allocations
  List<BudgetSuggestion> _generateBudgetSuggestions(
      double monthlySalary, Map<String, double> allocations) {
    List<BudgetSuggestion> suggestions = [];

    // This would normally use more advanced AI to generate personalized suggestions
    // Here are some example suggestions

    // Housing suggestion
    if (allocations[SpendingCategory.housing]! > monthlySalary * 0.4) {
      suggestions.add(
        BudgetSuggestion(
          category: SpendingCategory.housing,
          amount: monthlySalary * 0.30,
          reason: 'Try to keep housing costs under 30% of your monthly income',
        ),
      );
    }

    // Savings suggestion
    if (allocations[SpendingCategory.savings]! < monthlySalary * 0.15) {
      suggestions.add(
        BudgetSuggestion(
          category: SpendingCategory.savings,
          amount: monthlySalary * 0.20,
          reason: 'Try to save at least 20% of your monthly income',
        ),
      );
    }

    // Food suggestion
    suggestions.add(
      BudgetSuggestion(
        category: SpendingCategory.food,
        amount: monthlySalary * 0.15,
        reason: 'Meal planning and cooking at home can help reduce food costs',
      ),
    );

    // Transportation suggestion
    suggestions.add(
      BudgetSuggestion(
        category: SpendingCategory.transportation,
        amount: monthlySalary * 0.10,
        reason: 'Consider public transportation or carpooling to reduce costs',
      ),
    );

    return suggestions;
  }

  // Update budget with new values and recalculate recommendations
  Future<BudgetModel> updateBudget(
    BudgetModel budget, {
    double? monthlySalary,
    DateTime? startDate,
    Map<String, double>? categoryAllocations,
  }) async {
    final double newSalary = monthlySalary ?? budget.monthlySalary;
    final DateTime newStartDate = startDate ?? budget.startDate;

    // If categoryAllocations is provided, use it; otherwise recalculate if salary changed
    final Map<String, double> newAllocations = categoryAllocations ??
        (monthlySalary != null
            ? _generateCategoryAllocations(newSalary)
            : budget.categoryAllocations);

    // Recalculate daily spending limit
    final double newDailyLimit =
        _calculateDailySpendingLimit(newSalary, newStartDate);

    // Generate new suggestions if salary or allocations changed
    final List<BudgetSuggestion> newSuggestions =
        (monthlySalary != null || categoryAllocations != null)
            ? _generateBudgetSuggestions(newSalary, newAllocations)
            : budget.suggestions;

    // Return updated budget
    return budget.copyWith(
      monthlySalary: newSalary,
      startDate: newStartDate,
      categoryAllocations: newAllocations,
      dailySpendingLimit: newDailyLimit,
      suggestions: newSuggestions,
    );
  }

  // Check if spending on a specific day exceeds the daily limit
  bool isExceedingDailyLimit(BudgetModel budget, double amountSpent) {
    return amountSpent > budget.dailySpendingLimit;
  }

  // Calculate remaining budget for a category
  double getRemainingBudgetForCategory(
      BudgetModel budget, String category, double spent) {
    if (!budget.categoryAllocations.containsKey(category)) {
      return 0;
    }
    return budget.categoryAllocations[category]! - spent;
  }
}
