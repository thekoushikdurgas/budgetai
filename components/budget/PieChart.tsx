import React from 'react';
import { StyleSheet, View, Text } from 'react-native';
import Svg, { G, Circle, Path, Text as SvgText } from 'react-native-svg';
import { ThemedText } from '@/components/ThemedText';
import { ThemedView } from '@/components/ThemedView';
import { Colors } from '@/constants/Colors';
import { useColorScheme } from '@/hooks/useColorScheme';

interface PieChartProps {
  data: {
    label: string;
    value: number;
    color?: string;
  }[];
  size?: number;
  showLabels?: boolean;
}

export function PieChart({ 
  data, 
  size = 200,
  showLabels = true
}: PieChartProps) {
  const colorScheme = useColorScheme() ?? 'light';
  const colors = Colors[colorScheme];
  
  // Calculate total value
  const total = data.reduce((sum, item) => sum + item.value, 0);
  
  // Calculate angles for each segment
  let startAngle = 0;
  const segments = data.map((item, index) => {
    const percentage = total > 0 ? (item.value / total) * 100 : 0;
    const angle = total > 0 ? (item.value / total) * 360 : 0;
    const endAngle = startAngle + angle;
    
    // Calculate path
    const x1 = size / 2 + (size / 2) * Math.cos((startAngle * Math.PI) / 180);
    const y1 = size / 2 + (size / 2) * Math.sin((startAngle * Math.PI) / 180);
    const x2 = size / 2 + (size / 2) * Math.cos((endAngle * Math.PI) / 180);
    const y2 = size / 2 + (size / 2) * Math.sin((endAngle * Math.PI) / 180);
    
    const largeArcFlag = angle > 180 ? 1 : 0;
    
    const path = `
      M ${size / 2} ${size / 2}
      L ${x1} ${y1}
      A ${size / 2} ${size / 2} 0 ${largeArcFlag} 1 ${x2} ${y2}
      Z
    `;
    
    // Calculate label position
    const labelAngle = startAngle + angle / 2;
    const labelRadius = size / 2 * 0.7; // 70% of radius
    const labelX = size / 2 + labelRadius * Math.cos((labelAngle * Math.PI) / 180);
    const labelY = size / 2 + labelRadius * Math.sin((labelAngle * Math.PI) / 180);
    
    const segment = {
      path,
      color: item.color || getChartColor(index),
      percentage,
      labelX,
      labelY,
      label: item.label,
    };
    
    startAngle = endAngle;
    return segment;
  });
  
  // Get color from chart colors
  function getChartColor(index: number) {
    const chartColors = [
      colors.chart.primary,
      colors.chart.secondary,
      colors.chart.tertiary,
      colors.chart.quaternary,
      colors.chart.quinary,
    ];
    
    return chartColors[index % chartColors.length];
  }
  
  return (
    <ThemedView style={styles.container}>
      <Svg width={size} height={size} viewBox={`0 0 ${size} ${size}`}>
        <G>
          {segments.map((segment, index) => (
            <React.Fragment key={index}>
              <Path
                d={segment.path}
                fill={segment.color}
                stroke={colors.background}
                strokeWidth={1}
              />
              {showLabels && segment.percentage > 5 && (
                <SvgText
                  x={segment.labelX}
                  y={segment.labelY}
                  fontSize="12"
                  fontWeight="bold"
                  fill={colors.text}
                  textAnchor="middle"
                  alignmentBaseline="middle"
                >
                  {Math.round(segment.percentage)}%
                </SvgText>
              )}
            </React.Fragment>
          ))}
        </G>
      </Svg>
      
      {showLabels && (
        <View style={styles.legend}>
          {segments.map((segment, index) => (
            <View key={index} style={styles.legendItem}>
              <View 
                style={[
                  styles.legendColor, 
                  { backgroundColor: segment.color }
                ]} 
              />
              <ThemedText style={styles.legendLabel}>
                {segment.label} ({Math.round(segment.percentage)}%)
              </ThemedText>
            </View>
          ))}
        </View>
      )}
    </ThemedView>
  );
}

const styles = StyleSheet.create({
  container: {
    alignItems: 'center',
    marginVertical: 16,
  },
  legend: {
    marginTop: 16,
    width: '100%',
  },
  legendItem: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 8,
  },
  legendColor: {
    width: 16,
    height: 16,
    borderRadius: 8,
    marginRight: 8,
  },
  legendLabel: {
    fontSize: 14,
  },
}); 