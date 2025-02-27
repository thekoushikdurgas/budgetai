import React from 'react';
import { StyleSheet, View, Text, Dimensions } from 'react-native';
import { ThemedText } from '@/components/ThemedText';
import { ThemedView } from '@/components/ThemedView';
import { Colors } from '@/constants/Colors';
import { useColorScheme } from '@/hooks/useColorScheme';

interface BarChartProps {
  data: {
    label: string;
    value: number;
  }[];
  height?: number;
  barColor?: string;
  showValues?: boolean;
}

export function BarChart({ 
  data, 
  height = 200, 
  barColor,
  showValues = true 
}: BarChartProps) {
  const colorScheme = useColorScheme() ?? 'light';
  const colors = Colors[colorScheme];
  
  // Find the maximum value for scaling
  const maxValue = Math.max(...data.map(item => item.value), 1);
  
  // Calculate bar width based on number of bars
  const screenWidth = Dimensions.get('window').width;
  const chartWidth = screenWidth - 64; // Account for padding
  const barWidth = (chartWidth / data.length) * 0.7; // 70% of available space
  const barSpacing = (chartWidth / data.length) * 0.3; // 30% of available space
  
  return (
    <ThemedView style={styles.container}>
      <View style={[styles.chartContainer, { height }]}>
        {data.map((item, index) => {
          const barHeight = (item.value / maxValue) * (height - 40); // Leave space for labels
          
          return (
            <View key={index} style={styles.barContainer}>
              <View style={styles.barWrapper}>
                {showValues && (
                  <ThemedText style={styles.barValue}>
                    ${item.value.toFixed(0)}
                  </ThemedText>
                )}
                <View 
                  style={[
                    styles.bar, 
                    { 
                      height: barHeight, 
                      width: barWidth,
                      backgroundColor: barColor || colors.tint,
                    }
                  ]} 
                />
              </View>
              <ThemedText style={styles.barLabel} numberOfLines={1}>
                {item.label}
              </ThemedText>
            </View>
          );
        })}
      </View>
    </ThemedView>
  );
}

const styles = StyleSheet.create({
  container: {
    marginVertical: 16,
  },
  chartContainer: {
    flexDirection: 'row',
    alignItems: 'flex-end',
    justifyContent: 'space-between',
    paddingHorizontal: 8,
  },
  barContainer: {
    alignItems: 'center',
    flex: 1,
  },
  barWrapper: {
    alignItems: 'center',
    justifyContent: 'flex-end',
    height: '100%',
  },
  bar: {
    borderRadius: 4,
  },
  barValue: {
    fontSize: 12,
    marginBottom: 4,
  },
  barLabel: {
    fontSize: 12,
    marginTop: 8,
    textAlign: 'center',
  },
}); 