import 'package:equatable/equatable.dart';
import 'package:budgetai/features/sms/model/sms_model.dart';

class SmsState extends Equatable {
  final bool hasPermission;
  final bool isLoading;
  final bool isLoadingMore;
  final List<SmsModel> smsMessages;
  final List<SmsModel> financialSmsMessages;
  final List<Map<String, dynamic>> transactions;
  final String? errorMessage;
  final int currentPage;
  final bool hasReachedMax;
  final int pageSize;

  const SmsState({
    this.hasPermission = false,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.smsMessages = const [],
    this.financialSmsMessages = const [],
    this.transactions = const [],
    this.errorMessage,
    this.currentPage = 1,
    this.hasReachedMax = false,
    this.pageSize = 20,
  });

  SmsState copyWith({
    bool? hasPermission,
    bool? isLoading,
    bool? isLoadingMore,
    List<SmsModel>? smsMessages,
    List<SmsModel>? financialSmsMessages,
    List<Map<String, dynamic>>? transactions,
    String? errorMessage,
    int? currentPage,
    bool? hasReachedMax,
    int? pageSize,
  }) {
    return SmsState(
      hasPermission: hasPermission ?? this.hasPermission,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      smsMessages: smsMessages ?? this.smsMessages,
      financialSmsMessages: financialSmsMessages ?? this.financialSmsMessages,
      transactions: transactions ?? this.transactions,
      errorMessage: errorMessage,
      currentPage: currentPage ?? this.currentPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      pageSize: pageSize ?? this.pageSize,
    );
  }

  @override
  List<Object?> get props => [
        hasPermission,
        isLoading,
        isLoadingMore,
        smsMessages,
        financialSmsMessages,
        transactions,
        errorMessage,
        currentPage,
        hasReachedMax,
        pageSize,
      ];
}
