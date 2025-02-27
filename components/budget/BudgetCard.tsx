import React from 'react';
import { StyleSheet, View, TouchableOpacity } from 'react-native';
import { ThemedText } from '@/components/ThemedText';
import { ThemedView } from '@/components/ThemedView';
import { IconSymbol } from '@/components/ui/IconSymbol';
import { Colors } from '@/constants/Colors';
import { useColorScheme } from '@/hooks/useColorScheme';

interface BudgetCardProps {
  title: string;
  amount: number;
  spent?: number;
  remaining?: number;
  icon?: string;
  onPress?: () => void;
}

export function BudgetCard({ 
  title, 
  amount, 
  spent, 
  remaining, 
  icon = 'money.dollar',
  onPress 
}: BudgetCardProps) {
  const colorScheme = useColorScheme() ?? 'light';
  const colors = Colors[colorScheme];
  
  const progress = spent !== undefined && amount > 0 
    ? Math.min(spent / amount, 1) 
    : 0;
  
  return (
    <TouchableOpacity 
      style={[styles.container, { backgroundColor: colors.card }]} 
      onPress={onPress}
      disabled={!onPress}
      activeOpacity={onPress ? 0.7 : 1}
    >
      <View style={styles.header}>
        <View style={styles.titleContainer}>
          <IconSymbol name={icon as any} size={24} color={colors.icon} />
          <ThemedText type="defaultSemiBold">{title}</ThemedText>
        </View>
        <ThemedText type="defaultSemiBold">${amount.toFixed(2)}</ThemedText>
      </View>
      
      {spent !== undefined && (
        <>
          <View style={styles.progressContainer}>
            <View 
              style={[
                styles.progressBar, 
                { 
                  backgroundColor: colors.border,
                  width: '100%' 
                }
              ]} 
            />
            <View 
              style={[
                styles.progressFill, 
                { 
                  backgroundColor: progress > 0.9 ? colors.error : colors.tint,
                  width: `${progress * 100}%` 
                }
              ]} 
            />
          </View>
          
          <View style={styles.footer}>
            <ThemedText>Spent: ${spent.toFixed(2)}</ThemedText>
            {remaining !== undefined && (
              <ThemedText style={{ color: remaining < 0 ? colors.error : colors.text }}>
                Remaining: ${remaining.toFixed(2)}
              </ThemedText>
            )}
          </View>
        </>
      )}
    </TouchableOpacity>
  );
}

const styles = StyleSheet.create({
  container: {
    borderRadius: 12,
    padding: 16,
    marginBottom: 16,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 4,
    elevation: 2,
  },
  header: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 12,
  },
  titleContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 8,
  },
  progressContainer: {
    height: 8,
    borderRadius: 4,
    overflow: 'hidden',
    position: 'relative',
    marginBottom: 12,
  },
  progressBar: {
    position: 'absolute',
    height: '100%',
    borderRadius: 4,
  },
  progressFill: {
    position: 'absolute',
    height: '100%',
    borderRadius: 4,
  },
  footer: {
    flexDirection: 'row',
    justifyContent: 'space-between',
  },
}); 