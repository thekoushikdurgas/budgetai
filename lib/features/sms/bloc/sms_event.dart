import 'package:equatable/equatable.dart';

abstract class SmsEvent extends Equatable {
  const SmsEvent();

  @override
  List<Object?> get props => [];
}

class CheckSmsPermission extends SmsEvent {
  const CheckSmsPermission();
}

class RequestSmsPermission extends SmsEvent {
  const RequestSmsPermission();
}

class LoadAllSms extends SmsEvent {
  final String? filter;
  final int limit;
  
  const LoadAllSms({this.filter, this.limit = 100});
  
  @override
  List<Object?> get props => [filter, limit];
}

class LoadMoreSms extends SmsEvent {
  final String? filter;
  
  const LoadMoreSms({this.filter});
  
  @override
  List<Object?> get props => [filter];
}

class LoadFinancialSms extends SmsEvent {
  final int limit;
  
  const LoadFinancialSms({this.limit = 100});
  
  @override
  List<Object?> get props => [limit];
}

class LoadMoreFinancialSms extends SmsEvent {
  const LoadMoreFinancialSms();
}

class ExtractTransactions extends SmsEvent {
  final int limit;
  
  const ExtractTransactions({this.limit = 100});
  
  @override
  List<Object?> get props => [limit];
}

class LoadMoreTransactions extends SmsEvent {
  const LoadMoreTransactions();
}

class RefreshSms extends SmsEvent {
  const RefreshSms();
} 