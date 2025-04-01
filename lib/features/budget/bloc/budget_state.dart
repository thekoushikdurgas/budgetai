import 'package:equatable/equatable.dart';
import 'package:budgetai/features/budget/model/budget_model.dart';

class BudgetState extends Equatable {
  final bool isLoading;
  final BudgetModel? budget;
  final String? errorMessage;
  final bool isCreatingBudget;
  final bool hasBudget;

  const BudgetState({
    this.isLoading = false,
    this.budget,
    this.errorMessage,
    this.isCreatingBudget = false,
    this.hasBudget = false,
  });

  BudgetState copyWith({
    bool? isLoading,
    BudgetModel? budget,
    String? errorMessage,
    bool? isCreatingBudget,
    bool? hasBudget,
  }) {
    return BudgetState(
      isLoading: isLoading ?? this.isLoading,
      budget: budget ?? this.budget,
      errorMessage: errorMessage,
      isCreatingBudget: isCreatingBudget ?? this.isCreatingBudget,
      hasBudget: hasBudget ?? this.hasBudget,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        budget,
        errorMessage,
        isCreatingBudget,
        hasBudget,
      ];
}
