import 'package:budgetai/features/budget/bloc/budget_event.dart';
import 'package:budgetai/features/budget/bloc/budget_state.dart';
import 'package:budgetai/features/budget/model/budget_model.dart';
import 'package:budgetai/features/budget/service/budget_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:budegetai/features/budget/bloc/budget_event.dart';
// import 'package:budegetai/features/budget/bloc/budget_state.dart';
// import 'package:budegetai/features/budget/service/budget_service.dart';
// import 'package:budegetai/features/budget/model/budget_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert';

class BudgetBloc extends Bloc<BudgetEvent, BudgetState> {
  final BudgetService _budgetService = BudgetService();
  static const String _budgetKey = 'budget_data';

  BudgetBloc() : super(const BudgetState()) {
    on<CreateBudget>(_onCreateBudget);
    on<UpdateBudget>(_onUpdateBudget);
    on<LoadBudget>(_onLoadBudget);
    on<ResetBudget>(_onResetBudget);
    on<CheckExceedingDailyLimit>(_onCheckExceedingDailyLimit);
    on<CheckCategoryBudget>(_onCheckCategoryBudget);
  }

  Future<void> _onCreateBudget(
    CreateBudget event,
    Emitter<BudgetState> emit,
  ) async {
    try {
      emit(state.copyWith(
        isLoading: true,
        isCreatingBudget: true,
      ));

      final budget = await _budgetService.createBudget(
        event.monthlySalary,
        event.startDate,
      );

      // Save budget to local storage
      await _saveBudget(budget);

      emit(state.copyWith(
        isLoading: false,
        budget: budget,
        isCreatingBudget: false,
        hasBudget: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
        isCreatingBudget: false,
      ));
    }
  }

  Future<void> _onUpdateBudget(
    UpdateBudget event,
    Emitter<BudgetState> emit,
  ) async {
    if (state.budget == null) {
      emit(state.copyWith(
        errorMessage: 'No budget found to update',
      ));
      return;
    }

    try {
      emit(state.copyWith(isLoading: true));

      final updatedBudget = await _budgetService.updateBudget(
        state.budget!,
        monthlySalary: event.monthlySalary,
        startDate: event.startDate,
        categoryAllocations: event.categoryAllocations,
      );

      // Save updated budget to local storage
      await _saveBudget(updatedBudget);

      emit(state.copyWith(
        isLoading: false,
        budget: updatedBudget,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onLoadBudget(
    LoadBudget event,
    Emitter<BudgetState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));

      // Load budget from local storage
      final budget = await _loadBudget();

      emit(state.copyWith(
        isLoading: false,
        budget: budget,
        hasBudget: budget != null,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onResetBudget(
    ResetBudget event,
    Emitter<BudgetState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));

      // Clear budget from local storage
      await _clearBudget();

      emit(const BudgetState());
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onCheckExceedingDailyLimit(
    CheckExceedingDailyLimit event,
    Emitter<BudgetState> emit,
  ) {
    if (state.budget == null) {
      emit(state.copyWith(
        errorMessage: 'No budget found',
      ));
      return;
    }

    _budgetService.isExceedingDailyLimit(
      state.budget!,
      event.amountSpent,
    );

    // Just check and return, no state changes needed
    // The UI can access the result from the budgetService directly
  }

  void _onCheckCategoryBudget(
    CheckCategoryBudget event,
    Emitter<BudgetState> emit,
  ) {
    if (state.budget == null) {
      emit(state.copyWith(
        errorMessage: 'No budget found',
      ));
      return;
    }

    _budgetService.getRemainingBudgetForCategory(
      state.budget!,
      event.category,
      event.amountSpent,
    );

    // Just check and return, no state changes needed
    // The UI can access the result from the budgetService directly
  }

  // Helper methods for local storage
  Future<void> _saveBudget(BudgetModel budget) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_budgetKey, budget.toJson());
  }

  Future<BudgetModel?> _loadBudget() async {
    final prefs = await SharedPreferences.getInstance();
    final String? budgetJson = prefs.getString(_budgetKey);

    if (budgetJson == null) {
      return null;
    }

    try {
      return BudgetModel.fromJson(budgetJson);
    } catch (e) {
      print('Error parsing budget: $e');
      return null;
    }
  }

  Future<void> _clearBudget() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_budgetKey);
  }
}
