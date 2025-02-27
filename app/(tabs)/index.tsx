import React, { useState } from 'react';
import { StyleSheet, ScrollView, View, TouchableOpacity, RefreshControl } from 'react-native';
import { useRouter } from 'expo-router';

import { ThemedText } from '@/components/ThemedText';
import { ThemedView } from '@/components/ThemedView';
import { IconSymbol } from '@/components/ui/IconSymbol';
import { BudgetCard } from '@/components/budget/BudgetCard';
import { TransactionItem } from '@/components/budget/TransactionItem';
import { RecommendationCard } from '@/components/budget/RecommendationCard';
import { Colors } from '@/constants/Colors';
import { useColorScheme } from '@/hooks/useColorScheme';
import { useBudget } from '@/context/BudgetContext';

export default function DashboardScreen() {
  const router = useRouter();
  const colorScheme = useColorScheme() ?? 'light';
  const colors = Colors[colorScheme];
  const [refreshing, setRefreshing] = useState(false);
  
  const { 
    transactions, 
    budgets, 
    recommendations, 
    dailySpendingLimit,
    monthlyBudgetSummary,
    calculateRemainingBudget
  } = useBudget();
  
  // Get recent transactions (last 5)
  const recentTransactions = [...transactions]
    .sort((a, b) => new Date(b.date).getTime() - new Date(a.date).getTime())
    .slice(0, 5);
  
  // Handle refresh
  const onRefresh = () => {
    setRefreshing(true);
    // In a real app, you would fetch new data here
    setTimeout(() => {
      setRefreshing(false);
    }, 1000);
  };
  
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
          <ThemedText type="title">Dashboard</ThemedText>
          <TouchableOpacity 
            style={styles.addButton}
            onPress={() => {
              // Navigate to add transaction screen
              // router.push('/add-transaction');
              alert('Add transaction feature coming soon!');
            }}
          >
            <IconSymbol name="plus" size={24} color={colors.background} />
          </TouchableOpacity>
        </View>
        
        {/* Monthly Budget Summary */}
        {monthlyBudgetSummary ? (
          <BudgetCard
            title="Monthly Budget"
            amount={monthlyBudgetSummary.totalBudget}
            spent={monthlyBudgetSummary.totalSpent}
            remaining={monthlyBudgetSummary.remaining}
            onPress={() => {
              // Navigate to budget details
              // router.push('/budget-details');
              alert('Budget details feature coming soon!');
            }}
          />
        ) : (
          <BudgetCard
            title="Monthly Budget"
            amount={0}
            onPress={() => {
              // Navigate to create budget
              // router.push('/create-budget');
              alert('Create budget feature coming soon!');
            }}
          />
        )}
        
        {/* Daily Spending Limit */}
        {dailySpendingLimit && (
          <BudgetCard
            title="Today's Spending Limit"
            amount={dailySpendingLimit.amount}
            spent={dailySpendingLimit.amount - dailySpendingLimit.remaining}
            remaining={dailySpendingLimit.remaining}
            icon="calendar"
          />
        )}
        
        {/* AI Recommendations */}
        {recommendations.length > 0 && (
          <View style={styles.section}>
            <View style={styles.sectionHeader}>
              <ThemedText type="subtitle">AI Recommendations</ThemedText>
              <TouchableOpacity onPress={() => {
                // Navigate to all recommendations
                // router.push('/recommendations');
                alert('All recommendations feature coming soon!');
              }}>
                <ThemedText type="link">See All</ThemedText>
              </TouchableOpacity>
            </View>
            
            {recommendations.slice(0, 2).map(recommendation => (
              <RecommendationCard
                key={recommendation.id}
                recommendation={recommendation}
              />
            ))}
          </View>
        )}
        
        {/* Recent Transactions */}
        <View style={styles.section}>
          <View style={styles.sectionHeader}>
            <ThemedText type="subtitle">Recent Transactions</ThemedText>
            <TouchableOpacity onPress={() => {
              // Navigate to the transactions tab using type assertion
              router.replace("transactions" as any);
            }}>
              <ThemedText type="link">See All</ThemedText>
            </TouchableOpacity>
          </View>
          
          {recentTransactions.length > 0 ? (
            <ThemedView style={styles.transactionsContainer}>
              {recentTransactions.map(transaction => (
                <TransactionItem
                  key={transaction.id}
                  transaction={transaction}
                  onPress={() => {
                    // Navigate to transaction details
                    // router.push(`/transaction/${transaction.id}`);
                    alert(`Transaction details for ${transaction.description} coming soon!`);
                  }}
                />
              ))}
            </ThemedView>
          ) : (
            <ThemedView style={styles.emptyState}>
              <ThemedText>No transactions yet. Add your first transaction!</ThemedText>
            </ThemedView>
          )}
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
  addButton: {
    width: 48,
    height: 48,
    borderRadius: 24,
    backgroundColor: Colors.light.tint,
    justifyContent: 'center',
    alignItems: 'center',
  },
  section: {
    marginBottom: 24,
  },
  sectionHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 16,
  },
  transactionsContainer: {
    borderRadius: 12,
    overflow: 'hidden',
  },
  emptyState: {
    padding: 24,
    alignItems: 'center',
    justifyContent: 'center',
    borderRadius: 12,
  },
});
