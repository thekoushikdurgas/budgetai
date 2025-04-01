import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:budgetai/features/budget/bloc/budget_bloc.dart';
import 'package:budgetai/features/budget/bloc/budget_event.dart';
import 'package:budgetai/features/budget/bloc/budget_state.dart';
import 'package:budgetai/features/budget/model/budget_model.dart';
import 'package:budgetai/common/widgets/custom_scaffold.dart';
import 'package:budgetai/common/helpers/ui_helper.dart';
import 'package:budgetai/features/theme/bloc/theme_bloc.dart';
import 'package:budgetai/features/theme/bloc/theme_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:budgetai/generated/codegen_loader.g.dart';

class BudgetView extends StatefulWidget {
  const BudgetView({super.key});

  @override
  State<BudgetView> createState() => _BudgetViewState();
}

class _BudgetViewState extends State<BudgetView> {
  final BudgetBloc _budgetBloc = BudgetBloc();
  final TextEditingController _salaryController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _budgetBloc.add(const LoadBudget());
  }

  @override
  void dispose() {
    _salaryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _budgetBloc,
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return BlocBuilder<BudgetBloc, BudgetState>(
            builder: (context, state) {
              return CustomScaffold(
                title: LocaleKeys.budget.tr(),
                onRefresh: () async {
                  _budgetBloc.add(const LoadBudget());
                  await Future.delayed(const Duration(seconds: 1));
                },
                children: [
                  const SizedBox(height: 10),
                  _buildContent(context, state),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, BudgetState state) {
    if (state.isLoading) {
      return const Center(child: CupertinoActivityIndicator());
    }

    if (!state.hasBudget) {
      return _buildCreateBudgetForm(context);
    }

    return _buildBudgetDetails(context, state.budget!);
  }

  Widget _buildCreateBudgetForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.create_budget.tr(),
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        Text(LocaleKeys.monthly_salary.tr()),
        const SizedBox(height: 10),
        CupertinoTextField(
          controller: _salaryController,
          keyboardType: TextInputType.number,
          placeholder: LocaleKeys.enter_monthly_salary.tr(),
          prefix: const Padding(
            padding: EdgeInsets.only(left: 10),
            child: Text('₹'),
          ),
        ),
        const SizedBox(height: 20),
        Text(LocaleKeys.budget_start_date.tr()),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () => _showDatePicker(context),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.withAlpha(100)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(DateFormat('MMM dd, yyyy').format(_selectedDate)),
                const Icon(CupertinoIcons.calendar, size: 20),
              ],
            ),
          ),
        ),
        const SizedBox(height: 30),
        SizedBox(
          width: double.infinity,
          child: CupertinoButton.filled(
            onPressed: () => _createBudget(context),
            child: Text(LocaleKeys.create_ai_budget.tr()),
          ),
        ),
      ],
    );
  }

  Widget _buildBudgetDetails(BuildContext context, BudgetModel budget) {
    // Format currency for display
    final currencyFormat = NumberFormat.currency(
      symbol: '₹',
      decimalDigits: 2,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Monthly salary section
        _buildInfoCard(
          context,
          title: LocaleKeys.monthly_salary.tr(),
          value: currencyFormat.format(budget.monthlySalary),
          icon: CupertinoIcons.money_dollar_circle,
          color: Colors.green,
        ),
        const SizedBox(height: 15),

        // Daily spending limit section
        _buildInfoCard(
          context,
          title: LocaleKeys.daily_spending_limit.tr(),
          value: currencyFormat.format(budget.dailySpendingLimit),
          subtitle: LocaleKeys.per_day.tr(),
          icon: CupertinoIcons.calendar_badge_plus,
          color: Colors.blue,
        ),
        const SizedBox(height: 20),

        // Category allocations section
        Text(
          LocaleKeys.category_allocations.tr(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),

        // Category allocation cards
        ..._buildCategoryCards(context, budget),

        const SizedBox(height: 20),

        // AI suggestions section
        if (budget.suggestions.isNotEmpty) ...[
          Text(
            LocaleKeys.ai_suggestions.tr(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),

          // Suggestion cards
          ..._buildSuggestionCards(context, budget),
        ],

        const SizedBox(height: 30),

        // Reset budget button
        SizedBox(
          width: double.infinity,
          child: CupertinoButton(
            color: Colors.red,
            onPressed: () => _resetBudget(context),
            child: Text(LocaleKeys.reset_budget.tr()),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildCategoryCards(BuildContext context, BudgetModel budget) {
    final currencyFormat = NumberFormat.currency(
      symbol: '₹',
      decimalDigits: 0,
    );

    return budget.categoryAllocations.entries.map((entry) {
      final category = entry.key;
      final amount = entry.value;

      // Determine icon based on category
      IconData icon;
      Color color;

      switch (category) {
        case SpendingCategory.housing:
          icon = CupertinoIcons.home;
          color = Colors.brown;
          break;
        case SpendingCategory.food:
          icon = CupertinoIcons.cart;
          color = Colors.orange;
          break;
        case SpendingCategory.transportation:
          icon = CupertinoIcons.car;
          color = Colors.blue;
          break;
        case SpendingCategory.utilities:
          icon = CupertinoIcons.lightbulb;
          color = Colors.yellow;
          break;
        case SpendingCategory.healthcare:
          icon = CupertinoIcons.heart;
          color = Colors.red;
          break;
        case SpendingCategory.entertainment:
          icon = CupertinoIcons.film;
          color = Colors.purple;
          break;
        case SpendingCategory.personal:
          icon = CupertinoIcons.person;
          color = Colors.teal;
          break;
        case SpendingCategory.savings:
          icon = CupertinoIcons.money_dollar;
          color = Colors.green;
          break;
        case SpendingCategory.debt:
          icon = CupertinoIcons.creditcard;
          color = Colors.red.shade700;
          break;
        default:
          icon = CupertinoIcons.circle;
          color = Colors.grey;
          break;
      }

      return Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: color.withAlpha(26),
          borderRadius: UIHelper.borderRadius,
          border: Border.all(color: color, width: 1),
        ),
        child: CupertinoListTile(
          leading: Icon(icon, color: color),
          title: Text(category),
          trailing: Text(
            currencyFormat.format(amount),
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }).toList();
  }

  List<Widget> _buildSuggestionCards(BuildContext context, BudgetModel budget) {
    final currencyFormat = NumberFormat.currency(
      symbol: '₹',
      decimalDigits: 0,
    );

    return budget.suggestions.map((suggestion) {
      return Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.blue.withAlpha(26),
          borderRadius: UIHelper.borderRadius,
        ),
        child: CupertinoListTile(
          title: Text(suggestion.category),
          subtitle: Text(suggestion.reason),
          trailing: Text(
            currencyFormat.format(suggestion.amount),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required String title,
    required String value,
    String? subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: UIHelper.borderRadius,
        border: Border.all(
          color: color.withAlpha(100),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withAlpha(50),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(width: 5),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDatePicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Column(
            children: [
              SizedBox(
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      child: Text(LocaleKeys.cancel.tr()),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    CupertinoButton(
                      child: Text(LocaleKeys.done.tr()),
                      onPressed: () {
                        Navigator.of(context).pop();
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: _selectedDate,
                  onDateTimeChanged: (DateTime newDate) {
                    setState(() {
                      _selectedDate = newDate;
                    });
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _createBudget(BuildContext context) {
    final salaryText = _salaryController.text.trim();
    if (salaryText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(LocaleKeys.enter_salary_prompt.tr())),
      );
      return;
    }

    final salary = double.tryParse(salaryText);
    if (salary == null || salary <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(LocaleKeys.enter_valid_salary.tr())),
      );
      return;
    }

    _budgetBloc.add(CreateBudget(
      monthlySalary: salary,
      startDate: _selectedDate,
    ));
  }

  void _resetBudget(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(LocaleKeys.reset_budget.tr()),
          content: Text(LocaleKeys.reset_budget_confirmation.tr()),
          actions: [
            CupertinoDialogAction(
              child: Text(LocaleKeys.cancel.tr()),
              onPressed: () => Navigator.of(context).pop(),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () {
                Navigator.of(context).pop();
                _budgetBloc.add(const ResetBudget());
                _salaryController.clear();
                setState(() {
                  _selectedDate = DateTime.now();
                });
              },
              child: Text(LocaleKeys.reset.tr()),
            ),
          ],
        );
      },
    );
  }
}
