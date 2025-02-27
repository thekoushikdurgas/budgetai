export type TransactionType = 'income' | 'expense';

export type TransactionCategory = 
  // Income categories
  | 'salary'
  | 'freelance'
  | 'investment'
  | 'gift'
  | 'other_income'
  // Expense categories
  | 'food'
  | 'transportation'
  | 'housing'
  | 'utilities'
  | 'entertainment'
  | 'healthcare'
  | 'education'
  | 'shopping'
  | 'personal'
  | 'travel'
  | 'debt'
  | 'savings'
  | 'other_expense';

export interface Transaction {
  id: string;
  amount: number;
  type: TransactionType;
  category: TransactionCategory;
  description: string;
  date: string; // ISO date string
  createdAt: string; // ISO date string
  updatedAt: string; // ISO date string
}

export interface Budget {
  id: string;
  amount: number;
  period: 'daily' | 'weekly' | 'monthly' | 'yearly';
  startDate: string; // ISO date string
  endDate: string; // ISO date string
  categories?: TransactionCategory[];
  createdAt: string; // ISO date string
  updatedAt: string; // ISO date string
}

export interface User {
  id: string;
  name: string;
  email: string;
  currency: string;
  createdAt: string; // ISO date string
  updatedAt: string; // ISO date string
}

export interface AIRecommendation {
  id: string;
  type: 'saving' | 'spending' | 'budget';
  message: string;
  suggestedAmount?: number;
  category?: TransactionCategory;
  createdAt: string; // ISO date string
}

export interface DailySpendingLimit {
  amount: number;
  date: string; // ISO date string
  remaining: number;
}

export interface MonthlyBudgetSummary {
  totalBudget: number;
  totalSpent: number;
  remaining: number;
  categories: {
    [key in TransactionCategory]?: {
      budget: number;
      spent: number;
      remaining: number;
    }
  };
}

export interface SpendingTrend {
  period: string; // e.g., "Jan 2023", "Feb 2023", etc.
  amount: number;
}

export interface CategoryBreakdown {
  category: TransactionCategory;
  amount: number;
  percentage: number;
} 