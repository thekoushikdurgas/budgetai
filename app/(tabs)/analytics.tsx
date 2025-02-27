import React, { useState } from 'react';
import { StyleSheet, ScrollView, View, TouchableOpacity, RefreshControl } from 'react-native';
import { useRouter } from 'expo-router';

import { ThemedText } from '@/components/ThemedText';
import { ThemedView } from '@/components/ThemedView';
import { BarChart } from '@/components/budget/BarChart';
import { PieChart } from '@/components/budget/PieChart';
import { Colors } from '@/constants/Colors';
import { useColorScheme } from '@/hooks/useColorScheme';
import { useBudget } from '@/context/BudgetContext';

export default function AnalyticsScreen() {
  const router = useRouter();
  const colorScheme = useColorScheme() ?? 'light';
  const colors = Colors[colorScheme];
  const [refreshing, setRefreshing] = useState(false);
  const [selectedPeriod, setSelectedPeriod] = useState<'week' | 'month' | 'year'>('month');
  
  const { 
    transactions, 
    spendingTrends, 
    categoryBreakdown,
    monthlyBudgetSummary
  } = useBudget();
  
  // Handle refresh
  const onRefresh = () => {
    setRefreshing(true);
    // In a real app, you would fetch new data here
    setTimeout(() => {
      setRefreshing(false);
    }, 1000);
  };
  
  // Format spending trends data for bar chart
  const spendingTrendsData = spendingTrends.map(trend => ({
    label: trend.period,
    value: trend.amount,
  }));
  
  // Format category breakdown data for pie chart
  const categoryBreakdownData = categoryBreakdown.map(item => ({
    label: item.category
      .split('_')
      .map(word => word.charAt(0).toUpperCase() + word.slice(1))
      .join(' '),
    value: item.amount,
  }));
  
  // Calculate total income and expenses
  const totalIncome = transactions
    .filter(t => t.type === 'income')
    .reduce((sum, t) => sum + t.amount, 0);
  
  const totalExpenses = transactions
    .filter(t => t.type === 'expense')
    .reduce((sum, t) => sum + t.amount, 0);
  
  const savings = totalIncome - totalExpenses;
  const savingsPercentage = totalIncome > 0 ? (savings / totalIncome) * 100 : 0;
  
  return (
    <ThemedView style={styles.container}>
      <ScrollView
        style={styles.scrollView}
        contentContainerStyle={styles.scrollContent}
        refreshControl={
          <RefreshControl refreshing={refreshing} onRefresh={onRefresh} />
        }
      >
        <View style={styles.header}>
          <ThemedText type="title">Analytics</ThemedText>
        </View>
        
        {/* Summary Cards */}
        <View style={styles.summaryContainer}>
          <View style={[styles.summaryCard, { backgroundColor: colors.card }]}>
            <ThemedText style={styles.summaryLabel}>Income</ThemedText>
            <ThemedText style={[styles.summaryValue, { color: colors.income }]}>
              ${totalIncome.toFixed(2)}
            </ThemedText>
          </View>
          
          <View style={[styles.summaryCard, { backgroundColor: colors.card }]}>
            <ThemedText style={styles.summaryLabel}>Expenses</ThemedText>
            <ThemedText style={[styles.summaryValue, { color: colors.expense }]}>
              ${totalExpenses.toFixed(2)}
            </ThemedText>
          </View>
          
          <View style={[styles.summaryCard, { backgroundColor: colors.card }]}>
            <ThemedText style={styles.summaryLabel}>Savings</ThemedText>
            <ThemedText 
              style={[
                styles.summaryValue, 
                { color: savings >= 0 ? colors.income : colors.expense }
              ]}
            >
              ${savings.toFixed(2)}
            </ThemedText>
            <ThemedText style={styles.savingsPercentage}>
              {savingsPercentage.toFixed(1)}% of income
            </ThemedText>
          </View>
        </View>
        
        {/* Spending Trends */}
        <View style={styles.section}>
          <ThemedText type="subtitle">Spending Trends</ThemedText>
          <ThemedText>Your spending over the last 6 months</ThemedText>
          
          {spendingTrendsData.length > 0 ? (
            <BarChart data={spendingTrendsData} height={200} />
          ) : (
            <ThemedView style={styles.emptyChart}>
              <ThemedText>Not enough data to show spending trends.</ThemedText>
            </ThemedView>
          )}
        </View>
        
        {/* Category Breakdown */}
        <View style={styles.section}>
          <ThemedText type="subtitle">Category Breakdown</ThemedText>
          <ThemedText>Your spending by category</ThemedText>
          
          {categoryBreakdownData.length > 0 ? (
            <PieChart data={categoryBreakdownData} size={250} />
          ) : (
            <ThemedView style={styles.emptyChart}>
              <ThemedText>Not enough data to show category breakdown.</ThemedText>
            </ThemedView>
          )}
        </View>
        
        {/* AI Insights */}
        <View style={styles.section}>
          <ThemedText type="subtitle">AI Insights</ThemedText>
          
          <ThemedView style={[styles.insightCard, { backgroundColor: colors.card }]}>
            <ThemedText>Your spending on food has increased by 15% compared to last month.</ThemedText>
          </ThemedView>
          
          <ThemedView style={[styles.insightCard, { backgroundColor: colors.card }]}>
            <ThemedText>You've been consistent with your savings goals. Great job!</ThemedText>
          </ThemedView>
          
          <ThemedView style={[styles.insightCard, { backgroundColor: colors.card }]}>
            <ThemedText>Consider setting up automatic transfers to your savings account.</ThemedText>
          </ThemedView>
        </View>
      </ScrollView>
    </ThemedView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  scrollView: {
    flex: 1,
  },
  scrollContent: {
    padding: 16,
    paddingTop: 60, // Account for status bar
  },
  header: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 24,
  },
  summaryContainer: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    marginBottom: 24,
  },
  summaryCard: {
    flex: 1,
    borderRadius: 12,
    padding: 12,
    marginHorizontal: 4,
    alignItems: 'center',
  },
  summaryLabel: {
    fontSize: 14,
    marginBottom: 4,
  },
  summaryValue: {
    fontSize: 18,
    fontWeight: 'bold',
  },
  savingsPercentage: {
    fontSize: 12,
    opacity: 0.7,
    marginTop: 2,
  },
  section: {
    marginBottom: 24,
  },
  emptyChart: {
    height: 200,
    justifyContent: 'center',
    alignItems: 'center',
    borderRadius: 12,
    marginVertical: 16,
  },
  insightCard: {
    borderRadius: 12,
    padding: 16,
    marginBottom: 12,
  },
}); 