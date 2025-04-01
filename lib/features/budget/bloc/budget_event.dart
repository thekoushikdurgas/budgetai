import 'package:equatable/equatable.dart';

abstract class BudgetEvent extends Equatable {
  const BudgetEvent();

  @override
  List<Object?> get props => [];
}

class CreateBudget extends BudgetEvent {
  final double monthlySalary;
  final DateTime startDate;

  const CreateBudget({
    required this.monthlySalary,
    required this.startDate,
  });

  @override
  List<Object?> get props => [monthlySalary, startDate];
}

class UpdateBudget extends BudgetEvent {
  final double? monthlySalary;
  final DateTime? startDate;
  final Map<String, double>? categoryAllocations;

  const UpdateBudget({
    this.monthlySalary,
    this.startDate,
    this.categoryAllocations,
  });

  @override
  List<Object?> get props => [monthlySalary, startDate, categoryAllocations];
}

class LoadBudget extends BudgetEvent {
  const LoadBudget();
}

class ResetBudget extends BudgetEvent {
  const ResetBudget();
}

class CheckExceedingDailyLimit extends BudgetEvent {
  final double amountSpent;

  const CheckExceedingDailyLimit({
    required this.amountSpent,
  });

  @override
  List<Object?> get props => [amountSpent];
}

class CheckCategoryBudget extends BudgetEvent {
  final String category;
  final double amountSpent;

  const CheckCategoryBudget({
    required this.category,
    required this.amountSpent,
  });

  @override
  List<Object?> get props => [category, amountSpent];
} 