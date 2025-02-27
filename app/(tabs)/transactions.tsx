import React, { useState } from 'react';
import { StyleSheet, ScrollView, View, TouchableOpacity, RefreshControl, TextInput } from 'react-native';
import { useRouter } from 'expo-router';

import { ThemedText } from '@/components/ThemedText';
import { ThemedView } from '@/components/ThemedView';
import { IconSymbol } from '@/components/ui/IconSymbol';
import { TransactionItem } from '@/components/budget/TransactionItem';
import { Colors } from '@/constants/Colors';
import { useColorScheme } from '@/hooks/useColorScheme';
import { useBudget } from '@/context/BudgetContext';
import { Transaction, TransactionType } from '@/types';

export default function TransactionsScreen() {
  const router = useRouter();
  const colorScheme = useColorScheme() ?? 'light';
  const colors = Colors[colorScheme];
  const [refreshing, setRefreshing] = useState(false);
  const [searchQuery, setSearchQuery] = useState('');
  const [filterType, setFilterType] = useState<TransactionType | 'all'>('all');
  
  const { transactions } = useBudget();
  
  // Filter transactions based on search query and filter type
  const filteredTransactions = transactions.filter(transaction => {
    const matchesSearch = 
      transaction.description.toLowerCase().includes(searchQuery.toLowerCase()) ||
      transaction.category.toLowerCase().includes(searchQuery.toLowerCase());
    
    const matchesType = filterType === 'all' || transaction.type === filterType;
    
    return matchesSearch && matchesType;
  });
  
  // Sort transactions by date (newest first)
  const sortedTransactions = [...filteredTransactions].sort(
    (a, b) => new Date(b.date).getTime() - new Date(a.date).getTime()
  );
  
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
          <ThemedText type="title">Transactions</ThemedText>
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
        
        {/* Search and Filter */}
        <View style={styles.searchContainer}>
          <View style={[styles.searchInputContainer, { backgroundColor: colors.card }]}>
            <IconSymbol name="chevron.right" size={20} color={colors.icon} />
            <TextInput
              style={[styles.searchInput, { color: colors.text }]}
              placeholder="Search transactions..."
              placeholderTextColor={colors.icon}
              value={searchQuery}
              onChangeText={setSearchQuery}
            />
          </View>
          
          <View style={styles.filterContainer}>
            <TouchableOpacity
              style={[
                styles.filterButton,
                filterType === 'all' && { backgroundColor: colors.tint }
              ]}
              onPress={() => setFilterType('all')}
            >
              <ThemedText 
                style={[
                  styles.filterText,
                  filterType === 'all' && { color: '#fff' }
                ]}
              >
                All
              </ThemedText>
            </TouchableOpacity>
            
            <TouchableOpacity
              style={[
                styles.filterButton,
                filterType === 'income' && { backgroundColor: colors.income }
              ]}
              onPress={() => setFilterType('income')}
            >
              <ThemedText 
                style={[
                  styles.filterText,
                  filterType === 'income' && { color: '#fff' }
                ]}
              >
                Income
              </ThemedText>
            </TouchableOpacity>
            
            <TouchableOpacity
              style={[
                styles.filterButton,
                filterType === 'expense' && { backgroundColor: colors.expense }
              ]}
              onPress={() => setFilterType('expense')}
            >
              <ThemedText 
                style={[
                  styles.filterText,
                  filterType === 'expense' && { color: '#fff' }
                ]}
              >
                Expense
              </ThemedText>
            </TouchableOpacity>
          </View>
        </View>
        
        {/* Transactions List */}
        <ThemedView style={styles.transactionsContainer}>
          {sortedTransactions.length > 0 ? (
            sortedTransactions.map(transaction => (
              <TransactionItem
                key={transaction.id}
                transaction={transaction}
                onPress={(transaction) => {
                  // Navigate to transaction details
                  // router.push(`/transaction/${transaction.id}`);
                  alert(`Transaction details for ${transaction.description} coming soon!`);
                }}
              />
            ))
          ) : (
            <View style={styles.emptyState}>
              <ThemedText>No transactions found.</ThemedText>
              {searchQuery || filterType !== 'all' ? (
                <TouchableOpacity
                  onPress={() => {
                    setSearchQuery('');
                    setFilterType('all');
                  }}
                >
                  <ThemedText type="link">Clear filters</ThemedText>
                </TouchableOpacity>
              ) : (
                <TouchableOpacity
                  onPress={() => {
                    // Navigate to add transaction
                    // router.push('/add-transaction');
                    alert('Add transaction feature coming soon!');
                  }}
                >
                  <ThemedText type="link">Add your first transaction</ThemedText>
                </TouchableOpacity>
              )}
            </View>
          )}
        </ThemedView>
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
  searchContainer: {
    marginBottom: 16,
  },
  searchInputContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    borderRadius: 12,
    paddingHorizontal: 12,
    marginBottom: 12,
  },
  searchInput: {
    flex: 1,
    height: 48,
    paddingHorizontal: 8,
  },
  filterContainer: {
    flexDirection: 'row',
    justifyContent: 'space-between',
  },
  filterButton: {
    paddingVertical: 8,
    paddingHorizontal: 16,
    borderRadius: 20,
    backgroundColor: Colors.light.card,
  },
  filterText: {
    fontSize: 14,
    fontWeight: '500',
  },
  transactionsContainer: {
    borderRadius: 12,
    overflow: 'hidden',
  },
  emptyState: {
    padding: 24,
    alignItems: 'center',
    justifyContent: 'center',
    gap: 8,
  },
}); 