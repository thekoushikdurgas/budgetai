import 'dart:convert';

class SmsModel {
  final String address;
  final String body;
  final String date;
  final int dateMillis;
  final int type;
  final String typeText;

  SmsModel({
    required this.address,
    required this.body,
    required this.date,
    required this.dateMillis,
    required this.type,
    required this.typeText,
  });

  Map<String, dynamic> toMap() {
    return {
      'address': address,
      'body': body,
      'date': date,
      'dateMillis': dateMillis,
      'type': type,
      'typeText': typeText,
    };
  }

  factory SmsModel.fromMap(Map<String, dynamic> map) {
    return SmsModel(
      address: map['address'] ?? '',
      body: map['body'] ?? '',
      date: map['date'] ?? '',
      dateMillis: map['dateMillis']?.toInt() ?? 0,
      type: map['type']?.toInt() ?? 0,
      typeText: map['typeText'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory SmsModel.fromJson(String source) => SmsModel.fromMap(json.decode(source));
  
  // Helper method to extract possible financial information from SMS
  bool containsFinancialInfo() {
    final bodyLower = body.toLowerCase();
    return bodyLower.contains('payment') ||
        bodyLower.contains('transaction') ||
        bodyLower.contains('credit') ||
        bodyLower.contains('debit') ||
        bodyLower.contains('transfer') ||
        bodyLower.contains('account') ||
        bodyLower.contains('balance') ||
        bodyLower.contains('upi') ||
        bodyLower.contains('bank') ||
        bodyLower.contains('spent') ||
        bodyLower.contains('received') ||
        bodyLower.contains('rs.') ||
        bodyLower.contains('inr');
  }
  
  // Extract amount from SMS if available
  double? extractAmount() {
    // Common patterns for amount in SMS
    final regexList = [
      RegExp(r'rs\.?\s*([0-9,]+\.?[0-9]*)', caseSensitive: false),
      RegExp(r'inr\.?\s*([0-9,]+\.?[0-9]*)', caseSensitive: false),
      RegExp(r'amount\s*:?\s*rs\.?\s*([0-9,]+\.?[0-9]*)', caseSensitive: false),
      RegExp(r'([0-9,]+\.?[0-9]*)\s*rs', caseSensitive: false),
      RegExp(r'([0-9,]+\.?[0-9]*)\s*inr', caseSensitive: false),
    ];
    
    for (final regex in regexList) {
      final match = regex.firstMatch(body);
      if (match != null && match.groupCount >= 1) {
        final amountStr = match.group(1)?.replaceAll(',', '');
        if (amountStr != null) {
          try {
            return double.parse(amountStr);
          } catch (_) {
            // Continue to next pattern if parsing fails
          }
        }
      }
    }
    
    return null;
  }
} 