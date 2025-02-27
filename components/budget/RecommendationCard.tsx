import React from 'react';
import { StyleSheet, View, TouchableOpacity } from 'react-native';
import { ThemedText } from '@/components/ThemedText';
import { IconSymbol } from '@/components/ui/IconSymbol';
import { Colors } from '@/constants/Colors';
import { useColorScheme } from '@/hooks/useColorScheme';
import { AIRecommendation } from '@/types';

// Map recommendation types to icons
const TYPE_ICONS = {
  saving: 'arrow.up',
  spending: 'arrow.down',
  budget: 'money.dollar',
};

interface RecommendationCardProps {
  recommendation: AIRecommendation;
  onPress?: () => void;
}

export function RecommendationCard({ recommendation, onPress }: RecommendationCardProps) {
  const colorScheme = useColorScheme() ?? 'light';
  const colors = Colors[colorScheme];
  
  const { type, message, suggestedAmount } = recommendation;
  
  // Determine card color based on recommendation type
  const getCardColor = () => {
    switch (type) {
      case 'saving':
        return colors.success;
      case 'spending':
        return colors.warning;
      case 'budget':
        return colors.info;
      default:
        return colors.tint;
    }
  };
  
  return (
    <TouchableOpacity 
      style={[
        styles.container, 
        { 
          backgroundColor: colors.card,
          borderLeftColor: getCardColor(),
        }
      ]} 
      onPress={onPress}
      disabled={!onPress}
      activeOpacity={onPress ? 0.7 : 1}
    >
      <View style={styles.header}>
        <View style={styles.iconContainer}>
          <IconSymbol 
            name={TYPE_ICONS[type] as any} 
            size={24} 
            color={getCardColor()} 
          />
        </View>
        
        <ThemedText style={styles.message}>{message}</ThemedText>
      </View>
      
      {suggestedAmount !== undefined && (
        <View style={styles.amountContainer}>
          <ThemedText type="defaultSemiBold" style={{ color: getCardColor() }}>
            ${suggestedAmount.toFixed(2)}
          </ThemedText>
        </View>
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
    borderLeftWidth: 4,
  },
  header: {
    flexDirection: 'row',
    alignItems: 'flex-start',
  },
  iconContainer: {
    marginRight: 12,
    paddingTop: 2,
  },
  message: {
    flex: 1,
    lineHeight: 22,
  },
  amountContainer: {
    marginTop: 12,
    alignItems: 'flex-end',
  },
}); 