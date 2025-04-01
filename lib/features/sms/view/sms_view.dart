import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:budgetai/features/sms/bloc/sms_bloc.dart';
import 'package:budgetai/features/sms/bloc/sms_event.dart';
import 'package:budgetai/features/sms/bloc/sms_state.dart';
import 'package:budgetai/features/theme/bloc/theme_bloc.dart';
import 'package:budgetai/features/theme/bloc/theme_state.dart';
import 'package:budgetai/common/helpers/ui_helper.dart';
import 'package:budgetai/common/widgets/custom_scaffold.dart';
import 'package:budgetai/core/constants/color_constants.dart';
import 'package:budgetai/generated/codegen_loader.g.dart';
import 'package:easy_localization/easy_localization.dart';
// import 'package:easy_localization/easy_localization.dart';

class SmsView extends StatefulWidget {
  const SmsView({super.key});

  @override
  State<SmsView> createState() => _SmsViewState();
}

class _SmsViewState extends State<SmsView> {
  final SmsBloc _smsBloc = SmsBloc();
  int _selectedSegment = 0;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _smsBloc.add(const RefreshSms());
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      switch (_selectedSegment) {
        case 0:
          _smsBloc.add(const LoadMoreSms());
          break;
        case 1:
          _smsBloc.add(const LoadMoreFinancialSms());
          break;
        case 2:
          _smsBloc.add(const LoadMoreTransactions());
          break;
      }
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    // When we're 200 pixels from the bottom, load more
    return currentScroll >= (maxScroll - 200);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _smsBloc,
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return BlocBuilder<SmsBloc, SmsState>(
            builder: (context, smsState) {
              return CustomScaffold(
                title: LocaleKeys.sms_analysis.tr(),
                onRefresh: () async {
                  _smsBloc.add(const RefreshSms());
                  await Future.delayed(const Duration(seconds: 1));
                },
                scrollController: _scrollController,
                children: [
                  const SizedBox(height: 10),
                  _buildSegmentedControl(themeState, smsState),
                  const SizedBox(height: 20),
                  _buildBody(smsState),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildSegmentedControl(ThemeState themeState, SmsState smsState) {
    return CupertinoSlidingSegmentedControl<int>(
      groupValue: _selectedSegment,
      backgroundColor: themeState.isDark
          ? ColorConstants.darkItem
          : ColorConstants.lightBackground,
      thumbColor: themeState.isDark
          ? ColorConstants.darkBackgroundColorActivated
          : ColorConstants.lightBackgroundColorActivated,
      children: {
        0: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            '${LocaleKeys.all_sms.tr()} (${smsState.smsMessages.length})',
            style: TextStyle(
              color: _selectedSegment == 0
                  ? themeState.isDark
                      ? CupertinoColors.white
                      : CupertinoColors.black
                  : themeState.isDark
                      ? ColorConstants.darkInactive
                      : ColorConstants.lightInactive,
            ),
          ),
        ),
        1: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            '${LocaleKeys.financial_sms.tr()} (${smsState.financialSmsMessages.length})',
            style: TextStyle(
              color: _selectedSegment == 1
                  ? themeState.isDark
                      ? CupertinoColors.white
                      : CupertinoColors.black
                  : themeState.isDark
                      ? ColorConstants.darkInactive
                      : ColorConstants.lightInactive,
            ),
          ),
        ),
        2: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            '${LocaleKeys.transactions.tr()} (${smsState.transactions.length})',
            style: TextStyle(
              color: _selectedSegment == 2
                  ? themeState.isDark
                      ? CupertinoColors.white
                      : CupertinoColors.black
                  : themeState.isDark
                      ? ColorConstants.darkInactive
                      : ColorConstants.lightInactive,
            ),
          ),
        ),
      },
      onValueChanged: (value) {
        if (value != null) {
          setState(() {
            _selectedSegment = value;
          });
        }
      },
    );
  }

  Widget _buildBody(SmsState smsState) {
    if (smsState.isLoading &&
        (smsState.smsMessages.isEmpty &&
            smsState.financialSmsMessages.isEmpty &&
            smsState.transactions.isEmpty)) {
      return const Center(
        child: CupertinoActivityIndicator(),
      );
    }

    if (!smsState.hasPermission) {
      return _buildPermissionRequest();
    }

    switch (_selectedSegment) {
      case 0:
        return _buildAllSmsList(smsState);
      case 1:
        return _buildFinancialSmsList(smsState);
      case 2:
        return _buildTransactionsList(smsState);
      default:
        return const SizedBox();
    }
  }

  Widget _buildPermissionRequest() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            LocaleKeys.sms_permission_required.tr(),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          CupertinoButton.filled(
            child: Text(LocaleKeys.grant_permission.tr()),
            onPressed: () {
              _smsBloc.add(const RequestSmsPermission());
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAllSmsList(SmsState smsState) {
    final messages = smsState.smsMessages;

    if (messages.isEmpty) {
      return Center(
        child: Text(
          smsState.isLoading
              ? LocaleKeys.loading_sms.tr()
              : LocaleKeys.no_sms_found.tr(),
        ),
      );
    }

    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final sms = messages[index];
            return _buildSmsCard(sms.address, sms.body, sms.date, sms.typeText);
          },
        ),
        if (smsState.isLoadingMore)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Center(child: CupertinoActivityIndicator()),
          ),
        if (smsState.hasReachedMax)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Center(
              child: Text(
                'No more messages to load',
                style: TextStyle(
                  color: Theme.of(context).disabledColor,
                  fontSize: 14,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildFinancialSmsList(SmsState smsState) {
    final messages = smsState.financialSmsMessages;

    if (messages.isEmpty) {
      return Center(
        child: Text(
          smsState.isLoading
              ? LocaleKeys.loading_financial_sms.tr()
              : LocaleKeys.no_financial_sms_found.tr(),
        ),
      );
    }

    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final sms = messages[index];
            return _buildSmsCard(sms.address, sms.body, sms.date, sms.typeText);
          },
        ),
        if (smsState.isLoadingMore)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Center(child: CupertinoActivityIndicator()),
          ),
        if (smsState.hasReachedMax)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Center(
              child: Text(
                'No more financial messages to load',
                style: TextStyle(
                  color: Theme.of(context).disabledColor,
                  fontSize: 14,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTransactionsList(SmsState smsState) {
    final transactions = smsState.transactions;

    if (transactions.isEmpty) {
      return Center(
        child: Text(
          smsState.isLoading
              ? LocaleKeys.extracting_transactions.tr()
              : LocaleKeys.no_transactions_found.tr(),
        ),
      );
    }

    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            final transaction = transactions[index];
            final amount = transaction['amount'] as double;
            final type = transaction['type'] as String;
            final date = transaction['date'] as String;
            final source = transaction['source'] as String;
            final description = transaction['description'] as String;

            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: type == 'income'
                    ? Colors.green.withAlpha(26)
                    : Colors.red.withAlpha(26),
                borderRadius: UIHelper.borderRadius,
                border: Border.all(
                  color: type == 'income' ? Colors.green : Colors.red,
                  width: 1,
                ),
              ),
              child: CupertinoListTile(
                title: Text(
                  source,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(date),
                    const SizedBox(height: 5),
                    Text(
                      description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                trailing: Text(
                  '${type == 'income' ? '+' : '-'} ₹${amount.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: type == 'income' ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        ),
        if (smsState.isLoadingMore)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Center(child: CupertinoActivityIndicator()),
          ),
        if (smsState.hasReachedMax)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Center(
              child: Text(
                'No more transactions to load',
                style: TextStyle(
                  color: Theme.of(context).disabledColor,
                  fontSize: 14,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSmsCard(String sender, String body, String date, String type) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: type == 'Inbox'
            ? Colors.blue.withAlpha(26)
            : Colors.grey.withAlpha(26),
        borderRadius: UIHelper.borderRadius,
      ),
      child: CupertinoListTile(
        title: Text(
          sender,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(date),
            const SizedBox(height: 5),
            Text(body),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: type == 'Inbox' ? Colors.blue : Colors.grey,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            type,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
