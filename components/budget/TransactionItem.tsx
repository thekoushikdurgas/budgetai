import React from 'react';
import { StyleSheet, View, TouchableOpacity } from 'react-native';
import { ThemedText } from '@/components/ThemedText';
import { IconSymbol } from '@/components/ui/IconSymbol';
import { Colors } from '@/constants/Colors';
import { useColorScheme } from '@/hooks/useColorScheme';
import { Transaction, TransactionCategory } from '@/types';

// Map categories to icons
const CATEGORY_ICONS: Record<TransactionCategory, string> = {
  salary: 'money.dollar',
  freelance: 'money.dollar',
  investment: 'money.dollar',
  gift: 'money.dollar',
  other_income: 'money.dollar',
  food: 'money.dollar',
  transportation: 'money.dollar',
  housing: 'money.dollar',
  utilities: 'money.dollar',
  entertainment: 'money.dollar',
  healthcare: 'money.dollar',
  education: 'money.dollar',
  shopping: 'money.dollar',
  personal: 'money.dollar',
  travel: 'money.dollar',
  debt: 'money.dollar',
  savings: 'money.dollar',
  other_expense: 'money.dollar',
};

// Format category for display
function formatCategory(category: TransactionCategory): string {
  return category
    .split('_')
    .map(word => word.charAt(0).toUpperCase() + word.slice(1))
    .join(' ');
}

interface TransactionItemProps {
  transaction: Transaction;
  onPress?: (transaction: Transaction) => void;
}

export function TransactionItem({ transaction, onPress }: TransactionItemProps) {
  const colorScheme = useColorScheme() ?? 'light';
  const colors = Colors[colorScheme];
  
  const { amount, type, category, description, date } = transaction;
  const formattedDate = new Date(date).toLocaleDateString();
  const isIncome = type === 'income';
  
  return (
    <TouchableOpacity 
      style={[styles.container, { borderBottomColor: colors.border }]} 
      onPress={() => onPress?.(transaction)}
      disabled={!onPress}
      activeOpacity={onPress ? 0.7 : 1}
    >
      <View style={styles.iconContainer}>
        <IconSymbol 
          name={CATEGORY_ICONS[category] as any} 
          size={24} 
          color={isIncome ? colors.income : colors.expense} 
        />
      </View>
      
      <View style={styles.contentContainer}>
        <View style={styles.topRow}>
          <ThemedText type="defaultSemiBold">{formatCategory(category)}</ThemedText>
          <ThemedText 
            type="defaultSemiBold" 
            style={{ color: isIncome ? colors.income : colors.expense }}
          >
            {isIncome ? '+' : '-'}${amount.toFixed(2)}
          </ThemedText>
        </View>
        
        <View style={styles.bottomRow}>
          <ThemedText style={styles.description} numberOfLines={1}>
            {description}
          </ThemedText>
          <ThemedText style={styles.date}>{formattedDate}</ThemedText>
        </View>
      </View>
    </TouchableOpacity>
  );
}

const styles = StyleSheet.create({
  container: {
    flexDirection: 'row',
    paddingVertical: 16,
    borderBottomWidth: 1,
  },
  iconContainer: {
    marginRight: 16,
    justifyContent: 'center',
  },
  contentContainer: {
    flex: 1,
  },
  topRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    marginBottom: 4,
  },
  bottomRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
  },
  description: {
    flex: 1,
    fontSize: 14,
    opacity: 0.7,
  },
  date: {
    fontSize: 14,
    opacity: 0.7,
  },
}); 