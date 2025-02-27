import { Transaction, TransactionCategory, AIRecommendation } from '@/types';

// This is a mock AI service that would be replaced with actual API calls to OpenRouter or another AI service
export class AIService {
  // Generate budget recommendations based on transaction history
  static async generateBudgetRecommendations(
    transactions: Transaction[],
    monthlyIncome: number
  ): Promise<AIRecommendation[]> {
    // In a real implementation, this would call an AI API
    // For now, we'll return mock recommendations
    
    // Calculate total spending by category
    const categorySpending: Record<string, number> = {};
    const expenseTransactions = transactions.filter(t => t.type === 'expense');
    
    expenseTransactions.forEach(transaction => {
      if (!categorySpending[transaction.category]) {
        categorySpending[transaction.category] = 0;
      }
      categorySpending[transaction.category] += transaction.amount;
    });
    
    // Find the highest spending category
    let highestCategory: TransactionCategory | null = null;
    let highestAmount = 0;
    
    Object.entries(categorySpending).forEach(([category, amount]) => {
      if (amount > highestAmount) {
        highestAmount = amount;
        highestCategory = category as TransactionCategory;
      }
    });
    
    // Generate recommendations
    const recommendations: AIRecommendation[] = [];
    
    if (highestCategory) {
      // Recommend reducing spending in highest category
      const suggestedReduction = Math.round(highestAmount * 0.2); // Suggest 20% reduction
      
      recommendations.push({
        id: '1',
        type: 'saving',
        message: `You could save $${suggestedReduction} by reducing your ${highestCategory} expenses by 20%.`,
        suggestedAmount: suggestedReduction,
        category: highestCategory,
        createdAt: new Date().toISOString(),
      });
    }
    
    // Recommend budget allocation
    const totalExpenses = expenseTransactions.reduce((sum, t) => sum + t.amount, 0);
    const savingsRate = 0.2; // Recommend saving 20% of income
    const suggestedSavings = Math.round(monthlyIncome * savingsRate);
    
    recommendations.push({
      id: '2',
      type: 'budget',
      message: `Based on your income of $${monthlyIncome}, consider saving $${suggestedSavings} (20%) each month.`,
      suggestedAmount: suggestedSavings,
      category: 'savings',
      createdAt: new Date().toISOString(),
    });
    
    // Recommend daily spending limit
    const daysInMonth = 30; // Approximate
    const dailyLimit = Math.round((monthlyIncome - suggestedSavings) / daysInMonth);
    
    recommendations.push({
      id: '3',
      type: 'spending',
      message: `To stay within your budget, try to limit daily spending to $${dailyLimit}.`,
      suggestedAmount: dailyLimit,
      createdAt: new Date().toISOString(),
    });
    
    return recommendations;
  }
  
  // Generate personalized financial insights
  static async generateInsights(transactions: Transaction[]): Promise<string[]> {
    // In a real implementation, this would call an AI API
    // For now, we'll return mock insights
    
    const insights = [
      "Your spending on food has increased by 15% compared to last month.",
      "You've been consistent with your savings goals. Great job!",
      "Consider setting up automatic transfers to your savings account.",
      "Your transportation costs are lower than average for your income level.",
    ];
    
    return insights;
  }
  
  // Analyze SMS messages for transactions (mock implementation)
  static async analyzeSMS(messages: string[]): Promise<Transaction[]> {
    // In a real implementation, this would use AI to extract transaction data from SMS
    // For now, we'll return mock transactions
    
    const mockTransactions: Omit<Transaction, 'id' | 'createdAt' | 'updatedAt'>[] = [
      {
        amount: 45.99,
        type: 'expense',
        category: 'food',
        description: 'Grocery purchase',
        date: new Date().toISOString(),
      },
      {
        amount: 9.99,
        type: 'expense',
        category: 'entertainment',
        description: 'Subscription payment',
        date: new Date().toISOString(),
      },
    ];
    
    // Add IDs and timestamps
    return mockTransactions.map(t => ({
      ...t,
      id: Math.random().toString(36).substring(2, 15),
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString(),
    }));
  }
} 