import React, { createContext, useContext, useState, useEffect, ReactNode } from 'react';
import { v4 as uuidv4 } from 'uuid';
import { 
  Transaction, 
  Budget, 
  AIRecommendation, 
  DailySpendingLimit,
  MonthlyBudgetSummary,
  SpendingTrend,
  CategoryBreakdown,
  TransactionCategory
} from '@/types';

interface BudgetContextType {
  // Transactions
  transactions: Transaction[];
  addTransaction: (transaction: Omit<Transaction, 'id' | 'createdAt' | 'updatedAt'>) => void;
  updateTransaction: (id: string, transaction: Partial<Transaction>) => void;
  deleteTransaction: (id: string) => void;
  
  // Budgets
  budgets: Budget[];
  addBudget: (budget: Omit<Budget, 'id' | 'createdAt' | 'updatedAt'>) => void;
  updateBudget: (id: string, budget: Partial<Budget>) => void;
  deleteBudget: (id: string) => void;
  
  // AI Recommendations
  recommendations: AIRecommendation[];
  
  // Summaries and Analytics
  dailySpendingLimit: DailySpendingLimit | null;
  monthlyBudgetSummary: MonthlyBudgetSummary | null;
  spendingTrends: SpendingTrend[];
  categoryBreakdown: CategoryBreakdown[];
  
  // Utility functions
  calculateRemainingBudget: () => number;
  getTransactionsByCategory: (category: TransactionCategory) => Transaction[];
  getTransactionsByDate: (startDate: string, endDate: string) => Transaction[];
}

const BudgetContext = createContext<BudgetContextType | undefined>(undefined);

// Sample data for demonstration
const SAMPLE_TRANSACTIONS: Transaction[] = [
  {
    id: '1',
    amount: 3000,
    type: 'income',
    category: 'salary',
    description: 'Monthly salary',
    date: new Date().toISOString(),
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString(),
  },
  {
    id: '2',
    amount: 50,
    type: 'expense',
    category: 'food',
    description: 'Grocery shopping',
    date: new Date().toISOString(),
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString(),
  },
  {
    id: '3',
    amount: 30,
    type: 'expense',
    category: 'transportation',
    description: 'Uber ride',
    date: new Date().toISOString(),
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString(),
  },
];

const SAMPLE_BUDGETS: Budget[] = [
  {
    id: '1',
    amount: 2000,
    period: 'monthly',
    startDate: new Date().toISOString(),
    endDate: new Date(new Date().setMonth(new Date().getMonth() + 1)).toISOString(),
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString(),
  },
];

const SAMPLE_RECOMMENDATIONS: AIRecommendation[] = [
  {
    id: '1',
    type: 'saving',
    message: 'You could save $200 this month by reducing your food expenses.',
    suggestedAmount: 200,
    category: 'food',
    createdAt: new Date().toISOString(),
  },
  {
    id: '2',
    type: 'budget',
    message: 'Based on your spending patterns, consider setting a monthly budget of $300 for entertainment.',
    suggestedAmount: 300,
    category: 'entertainment',
    createdAt: new Date().toISOString(),
  },
];

export function BudgetProvider({ children }: { children: ReactNode }) {
  const [transactions, setTransactions] = useState<Transaction[]>(SAMPLE_TRANSACTIONS);
  const [budgets, setBudgets] = useState<Budget[]>(SAMPLE_BUDGETS);
  const [recommendations, setRecommendations] = useState<AIRecommendation[]>(SAMPLE_RECOMMENDATIONS);
  
  // Calculated states
  const [dailySpendingLimit, setDailySpendingLimit] = useState<DailySpendingLimit | null>(null);
  const [monthlyBudgetSummary, setMonthlyBudgetSummary] = useState<MonthlyBudgetSummary | null>(null);
  const [spendingTrends, setSpendingTrends] = useState<SpendingTrend[]>([]);
  const [categoryBreakdown, setCategoryBreakdown] = useState<CategoryBreakdown[]>([]);
  
  // Calculate daily spending limit
  useEffect(() => {
    if (budgets.length > 0) {
      const monthlyBudget = budgets.find(b => b.period === 'monthly');
      if (monthlyBudget) {
        const daysInMonth = new Date(new Date().getFullYear(), new Date().getMonth() + 1, 0).getDate();
        const dailyAmount = monthlyBudget.amount / daysInMonth;
        
        // Calculate today's expenses
        const today = new Date().toISOString().split('T')[0];
        const todayExpenses = transactions
          .filter(t => t.type === 'expense' && t.date.startsWith(today))
          .reduce((sum, t) => sum + t.amount, 0);
        
        setDailySpendingLimit({
          amount: dailyAmount,
          date: today,
          remaining: dailyAmount - todayExpenses,
        });
      }
    }
  }, [budgets, transactions]);
  
  // Calculate monthly budget summary
  useEffect(() => {
    if (budgets.length > 0) {
      const monthlyBudget = budgets.find(b => b.period === 'monthly');
      if (monthlyBudget) {
        const currentMonth = new Date().getMonth();
        const currentYear = new Date().getFullYear();
        
        // Filter transactions for the current month
        const monthTransactions = transactions.filter(t => {
          const transactionDate = new Date(t.date);
          return transactionDate.getMonth() === currentMonth && 
                 transactionDate.getFullYear() === currentYear;
        });
        
        const totalSpent = monthTransactions
          .filter(t => t.type === 'expense')
          .reduce((sum, t) => sum + t.amount, 0);
        
        // Calculate spending by category
        const categories: Record<string, { budget: number; spent: number; remaining: number }> = {};
        
        monthTransactions.forEach(t => {
          if (t.type === 'expense') {
            if (!categories[t.category]) {
              categories[t.category] = { budget: 0, spent: 0, remaining: 0 };
            }
            categories[t.category].spent += t.amount;
          }
        });
        
        // Assign budget amounts to categories (simplified)
        Object.keys(categories).forEach(category => {
          categories[category].budget = monthlyBudget.amount * 0.2; // Simplified allocation
          categories[category].remaining = categories[category].budget - categories[category].spent;
        });
        
        setMonthlyBudgetSummary({
          totalBudget: monthlyBudget.amount,
          totalSpent,
          remaining: monthlyBudget.amount - totalSpent,
          categories: categories as MonthlyBudgetSummary['categories'],
        });
      }
    }
  }, [budgets, transactions]);
  
  // Calculate spending trends (last 6 months)
  useEffect(() => {
    const trends: SpendingTrend[] = [];
    const currentDate = new Date();
    
    for (let i = 5; i >= 0; i--) {
      const month = new Date(currentDate.getFullYear(), currentDate.getMonth() - i, 1);
      const monthName = month.toLocaleString('default', { month: 'short' });
      const year = month.getFullYear();
      const period = `${monthName} ${year}`;
      
      // Filter transactions for this month
      const monthTransactions = transactions.filter(t => {
        const transactionDate = new Date(t.date);
        return transactionDate.getMonth() === month.getMonth() && 
               transactionDate.getFullYear() === month.getFullYear() &&
               t.type === 'expense';
      });
      
      const amount = monthTransactions.reduce((sum, t) => sum + t.amount, 0);
      
      trends.push({ period, amount });
    }
    
    setSpendingTrends(trends);
  }, [transactions]);
  
  // Calculate category breakdown for the current month
  useEffect(() => {
    const currentMonth = new Date().getMonth();
    const currentYear = new Date().getFullYear();
    
    // Filter transactions for the current month
    const monthTransactions = transactions.filter(t => {
      const transactionDate = new Date(t.date);
      return transactionDate.getMonth() === currentMonth && 
             transactionDate.getFullYear() === currentYear &&
             t.type === 'expense';
    });
    
    const totalSpent = monthTransactions.reduce((sum, t) => sum + t.amount, 0);
    
    // Group by category
    const categoryMap: Record<string, number> = {};
    monthTransactions.forEach(t => {
      if (!categoryMap[t.category]) {
        categoryMap[t.category] = 0;
      }
      categoryMap[t.category] += t.amount;
    });
    
    // Convert to array and calculate percentages
    const breakdown: CategoryBreakdown[] = Object.entries(categoryMap).map(([category, amount]) => ({
      category: category as TransactionCategory,
      amount,
      percentage: totalSpent > 0 ? (amount / totalSpent) * 100 : 0,
    }));
    
    setCategoryBreakdown(breakdown);
  }, [transactions]);
  
  // Transaction functions
  const addTransaction = (transaction: Omit<Transaction, 'id' | 'createdAt' | 'updatedAt'>) => {
    const newTransaction: Transaction = {
      ...transaction,
      id: uuidv4(),
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString(),
    };
    
    setTransactions(prev => [...prev, newTransaction]);
  };
  
  const updateTransaction = (id: string, transaction: Partial<Transaction>) => {
    setTransactions(prev => 
      prev.map(t => 
        t.id === id 
          ? { ...t, ...transaction, updatedAt: new Date().toISOString() } 
          : t
      )
    );
  };
  
  const deleteTransaction = (id: string) => {
    setTransactions(prev => prev.filter(t => t.id !== id));
  };
  
  // Budget functions
  const addBudget = (budget: Omit<Budget, 'id' | 'createdAt' | 'updatedAt'>) => {
    const newBudget: Budget = {
      ...budget,
      id: uuidv4(),
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString(),
    };
    
    setBudgets(prev => [...prev, newBudget]);
  };
  
  const updateBudget = (id: string, budget: Partial<Budget>) => {
    setBudgets(prev => 
      prev.map(b => 
        b.id === id 
          ? { ...b, ...budget, updatedAt: new Date().toISOString() } 
          : b
      )
    );
  };
  
  const deleteBudget = (id: string) => {
    setBudgets(prev => prev.filter(b => b.id !== id));
  };
  
  // Utility functions
  const calculateRemainingBudget = () => {
    const monthlyBudget = budgets.find(b => b.period === 'monthly');
    if (!monthlyBudget) return 0;
    
    const currentMonth = new Date().getMonth();
    const currentYear = new Date().getFullYear();
    
    // Filter transactions for the current month
    const monthExpenses = transactions.filter(t => {
      const transactionDate = new Date(t.date);
      return transactionDate.getMonth() === currentMonth && 
             transactionDate.getFullYear() === currentYear &&
             t.type === 'expense';
    }).reduce((sum, t) => sum + t.amount, 0);
    
    return monthlyBudget.amount - monthExpenses;
  };
  
  const getTransactionsByCategory = (category: TransactionCategory) => {
    return transactions.filter(t => t.category === category);
  };
  
  const getTransactionsByDate = (startDate: string, endDate: string) => {
    return transactions.filter(t => {
      const date = new Date(t.date);
      return date >= new Date(startDate) && date <= new Date(endDate);
    });
  };
  
  return (
    <BudgetContext.Provider
      value={{
        transactions,
        addTransaction,
        updateTransaction,
        deleteTransaction,
        budgets,
        addBudget,
        updateBudget,
        deleteBudget,
        recommendations,
        dailySpendingLimit,
        monthlyBudgetSummary,
        spendingTrends,
        categoryBreakdown,
        calculateRemainingBudget,
        getTransactionsByCategory,
        getTransactionsByDate,
      }}
    >
      {children}
    </BudgetContext.Provider>
  );
}

export function useBudget() {
  const context = useContext(BudgetContext);
  if (context === undefined) {
    throw new Error('useBudget must be used within a BudgetProvider');
  }
  return context;
} 