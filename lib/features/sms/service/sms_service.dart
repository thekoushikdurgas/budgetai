import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:budgetai/features/sms/model/sms_model.dart';

class SmsService {
  static final SmsService _instance = SmsService._internal();

  factory SmsService() => _instance;

  SmsService._internal();

  static const MethodChannel _channel =
      MethodChannel('com.durgas.budgetai/sms');

  // Check if SMS permission is granted
  Future<bool> checkSmsPermission() async {
    try {
      final bool isGranted = await _channel.invokeMethod('checkSmsPermission');
      return isGranted;
    } on PlatformException catch (e) {
      print('Failed to check SMS permission: ${e.message}');
      return false;
    }
  }

  // Request SMS permission
  Future<void> requestSmsPermission() async {
    try {
      await _channel.invokeMethod('requestSmsPermission');
    } on PlatformException catch (e) {
      print('Failed to request SMS permission: ${e.message}');
    }
  }

  // Get all SMS messages with pagination
  Future<List<SmsModel>> getAllSms(
      {String? filter, int limit = 100, int page = 1}) async {
    try {
      final bool hasPermission = await checkSmsPermission();
      if (!hasPermission) {
        await requestSmsPermission();
        // Check again after requesting permission
        final bool permissionGranted = await checkSmsPermission();
        if (!permissionGranted) {
          return [];
        }
      }

      final int offset = (page - 1) * limit;

      final String response = await _channel.invokeMethod('getAllSms', {
        'filter': filter,
        'limit': limit,
        'offset': offset,
      });

      final List<dynamic> jsonList = jsonDecode(response);
      return jsonList.map((json) => SmsModel.fromMap(json)).toList();
    } on PlatformException catch (e) {
      print('Failed to get SMS messages: ${e.message}');
      return [];
    }
  }

  // Get only financial SMS messages with pagination
  Future<List<SmsModel>> getFinancialSms(
      {int limit = 100, int page = 1}) async {
    final allSms = await getAllSms(limit: limit, page: page);
    return allSms.where((sms) => sms.containsFinancialInfo()).toList();
  }

  // Extract transactions from SMS messages with pagination
  Future<List<Map<String, dynamic>>> extractTransactions(
      {int limit = 100, int page = 1}) async {
    final financialSms = await getFinancialSms(limit: limit, page: page);
    final transactions = <Map<String, dynamic>>[];

    for (final sms in financialSms) {
      final amount = sms.extractAmount();
      if (amount != null) {
        final bodyLower = sms.body.toLowerCase();
        final isCredit = bodyLower.contains('credit') ||
            bodyLower.contains('received') ||
            bodyLower.contains('added');

        transactions.add({
          'date': sms.date,
          'amount': amount,
          'type': isCredit ? 'income' : 'expense',
          'source': sms.address,
          'description': sms.body,
          'rawSms': sms.toMap(),
        });
      }
    }

    return transactions;
  }
}
