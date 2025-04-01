import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:budgetai/features/sms/bloc/sms_event.dart';
import 'package:budgetai/features/sms/bloc/sms_state.dart';
import 'package:budgetai/features/sms/service/sms_service.dart';

class SmsBloc extends Bloc<SmsEvent, SmsState> {
  final SmsService _smsService = SmsService();

  SmsBloc() : super(const SmsState()) {
    on<CheckSmsPermission>(_onCheckSmsPermission);
    on<RequestSmsPermission>(_onRequestSmsPermission);
    on<LoadAllSms>(_onLoadAllSms);
    on<LoadMoreSms>(_onLoadMoreSms);
    on<LoadFinancialSms>(_onLoadFinancialSms);
    on<LoadMoreFinancialSms>(_onLoadMoreFinancialSms);
    on<ExtractTransactions>(_onExtractTransactions);
    on<LoadMoreTransactions>(_onLoadMoreTransactions);
    on<RefreshSms>(_onRefreshSms);
  }

  Future<void> _onCheckSmsPermission(
    CheckSmsPermission event,
    Emitter<SmsState> emit,
  ) async {
    try {
      final hasPermission = await _smsService.checkSmsPermission();
      emit(state.copyWith(hasPermission: hasPermission));
    } catch (e) {
      emit(state.copyWith(
        hasPermission: false,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onRequestSmsPermission(
    RequestSmsPermission event,
    Emitter<SmsState> emit,
  ) async {
    try {
      await _smsService.requestSmsPermission();
      final hasPermission = await _smsService.checkSmsPermission();
      emit(state.copyWith(hasPermission: hasPermission));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onLoadAllSms(
    LoadAllSms event,
    Emitter<SmsState> emit,
  ) async {
    try {
      emit(state.copyWith(
        isLoading: true,
        currentPage: 1,
        hasReachedMax: false,
      ));

      final messages = await _smsService.getAllSms(
        filter: event.filter,
        limit: state.pageSize,
        page: 1,
      );

      final hasReachedMax = messages.length < state.pageSize;

      emit(state.copyWith(
        isLoading: false,
        smsMessages: messages,
        currentPage: 1,
        hasReachedMax: hasReachedMax,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onLoadMoreSms(
    LoadMoreSms event,
    Emitter<SmsState> emit,
  ) async {
    if (state.hasReachedMax) return;

    try {
      emit(state.copyWith(isLoadingMore: true));

      final nextPage = state.currentPage + 1;
      final messages = await _smsService.getAllSms(
        filter: event.filter,
        limit: state.pageSize,
        page: nextPage,
      );

      if (messages.isEmpty) {
        emit(state.copyWith(
          isLoadingMore: false,
          hasReachedMax: true,
        ));
        return;
      }

      emit(state.copyWith(
        isLoadingMore: false,
        smsMessages: [...state.smsMessages, ...messages],
        currentPage: nextPage,
        hasReachedMax: messages.length < state.pageSize,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoadingMore: false,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onLoadFinancialSms(
    LoadFinancialSms event,
    Emitter<SmsState> emit,
  ) async {
    try {
      emit(state.copyWith(
        isLoading: true,
        currentPage: 1,
        hasReachedMax: false,
      ));

      final messages = await _smsService.getFinancialSms(
        limit: state.pageSize,
        page: 1,
      );

      final hasReachedMax = messages.length < state.pageSize;

      emit(state.copyWith(
        isLoading: false,
        financialSmsMessages: messages,
        currentPage: 1,
        hasReachedMax: hasReachedMax,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onLoadMoreFinancialSms(
    LoadMoreFinancialSms event,
    Emitter<SmsState> emit,
  ) async {
    if (state.hasReachedMax) return;

    try {
      emit(state.copyWith(isLoadingMore: true));

      final nextPage = state.currentPage + 1;
      final messages = await _smsService.getFinancialSms(
        limit: state.pageSize,
        page: nextPage,
      );

      if (messages.isEmpty) {
        emit(state.copyWith(
          isLoadingMore: false,
          hasReachedMax: true,
        ));
        return;
      }

      emit(state.copyWith(
        isLoadingMore: false,
        financialSmsMessages: [...state.financialSmsMessages, ...messages],
        currentPage: nextPage,
        hasReachedMax: messages.length < state.pageSize,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoadingMore: false,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onExtractTransactions(
    ExtractTransactions event,
    Emitter<SmsState> emit,
  ) async {
    try {
      emit(state.copyWith(
        isLoading: true,
        currentPage: 1,
        hasReachedMax: false,
      ));

      final transactions = await _smsService.extractTransactions(
        limit: state.pageSize,
        page: 1,
      );

      final hasReachedMax = transactions.length < state.pageSize;

      emit(state.copyWith(
        isLoading: false,
        transactions: transactions,
        currentPage: 1,
        hasReachedMax: hasReachedMax,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onLoadMoreTransactions(
    LoadMoreTransactions event,
    Emitter<SmsState> emit,
  ) async {
    if (state.hasReachedMax) return;

    try {
      emit(state.copyWith(isLoadingMore: true));

      final nextPage = state.currentPage + 1;
      final transactions = await _smsService.extractTransactions(
        limit: state.pageSize,
        page: nextPage,
      );

      if (transactions.isEmpty) {
        emit(state.copyWith(
          isLoadingMore: false,
          hasReachedMax: true,
        ));
        return;
      }

      emit(state.copyWith(
        isLoadingMore: false,
        transactions: [...state.transactions, ...transactions],
        currentPage: nextPage,
        hasReachedMax: transactions.length < state.pageSize,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoadingMore: false,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onRefreshSms(
    RefreshSms event,
    Emitter<SmsState> emit,
  ) async {
    try {
      emit(state.copyWith(
        isLoading: true,
        currentPage: 1,
        hasReachedMax: false,
      ));

      // Check permission first
      final hasPermission = await _smsService.checkSmsPermission();
      if (!hasPermission) {
        await _smsService.requestSmsPermission();
      }

      // Load all data
      final allSms = await _smsService.getAllSms(
        limit: state.pageSize,
        page: 1,
      );

      final financialSms = await _smsService.getFinancialSms(
        limit: state.pageSize,
        page: 1,
      );

      final transactions = await _smsService.extractTransactions(
        limit: state.pageSize,
        page: 1,
      );

      emit(state.copyWith(
        isLoading: false,
        hasPermission: await _smsService.checkSmsPermission(),
        smsMessages: allSms,
        financialSmsMessages: financialSms,
        transactions: transactions,
        currentPage: 1,
        hasReachedMax: allSms.length < state.pageSize,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }
}
