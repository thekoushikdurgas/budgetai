# BudgetAI - Personal Finance App with AI Recommendations

BudgetAI is a comprehensive personal finance application built with React Native and Expo. It helps users track expenses, manage budgets, and receive AI-powered financial recommendations.

![BudgetAI Logo](./assets/images/icon.png)

## Features

- **Dashboard**: Overview of your financial status with monthly budget and recent transactions
- **Transactions**: Track and categorize your income and expenses
- **Analytics**: Visualize your spending patterns with charts and graphs
- **AI Recommendations**: Get personalized financial advice based on your spending habits
- **Settings**: Customize app preferences and manage your account

## Technology Stack

- **Framework**: React Native with Expo
- **Navigation**: Expo Router (file-based routing)
- **State Management**: React Context API
- **UI Components**: Custom themed components
- **Charts**: Custom SVG-based charts (BarChart, PieChart)
- **Platform Support**: iOS, Android, and Web

## Getting Started

### Prerequisites

- Node.js (v14 or later)
- npm or yarn
- Expo CLI

### Installation

1. Clone the repository
   ```bash
   git clone https://github.com/yourusername/budgetai.git
   cd budgetai
   ```

2. Install dependencies
   ```bash
   npm install
   ```

3. Start the development server
   ```bash
   npx expo start
   ```

4. Open the app on your preferred platform:
   - Press `i` for iOS simulator
   - Press `a` for Android emulator
   - Press `w` for web browser

## Project Structure

```
budgetai/
├── app/                    # Main application screens (Expo Router)
│   ├── (tabs)/             # Tab-based navigation screens
│   │   ├── _layout.tsx     # Tab navigation configuration
│   │   ├── index.tsx       # Dashboard screen
│   │   ├── transactions.tsx # Transactions screen
│   │   ├── analytics.tsx   # Analytics screen
│   │   ├── settings.tsx    # Settings screen
│   │   └── explore.tsx     # Explore screen
│   ├── _layout.tsx         # Root layout with providers
│   └── +not-found.tsx      # 404 page
├── assets/                 # Static assets
│   ├── fonts/              # Custom fonts (SpaceMono)
│   └── images/             # App images and icons
├── components/             # Reusable UI components
│   ├── budget/             # Budget-specific components
│   │   ├── BarChart.tsx    # Bar chart visualization
│   │   ├── PieChart.tsx    # Pie chart visualization
│   │   ├── BudgetCard.tsx  # Budget summary card
│   │   ├── TransactionItem.tsx # Transaction list item
│   │   └── RecommendationCard.tsx # AI recommendation card
│   ├── ui/                 # Core UI components
│   │   ├── IconSymbol.tsx  # Icon component
│   │   └── TabBarBackground.tsx # Tab bar styling
│   ├── ThemedText.tsx      # Text with theme support
│   ├── ThemedView.tsx      # View with theme support
│   └── other components    # Additional UI components
├── constants/              # App constants
│   └── Colors.ts           # Theme colors
├── context/                # React context providers
│   └── BudgetContext.tsx   # Budget state management
├── hooks/                  # Custom React hooks
│   ├── useColorScheme.ts   # Theme detection
│   └── useThemeColor.ts    # Theme color utilities
├── services/               # Application services
│   └── AIService.ts        # AI recommendation service
├── types/                  # TypeScript type definitions
│   └── index.ts            # App type definitions
└── scripts/                # Utility scripts
    └── reset-project.js    # Project reset utility
```

## Core Components

### Data Management

- **BudgetContext**: Central state management for all budget-related data
- **Types**: Comprehensive type definitions for transactions, budgets, and analytics
- **AIService**: Service for generating AI-powered financial recommendations

### UI Components

- **Themed Components**: `ThemedText` and `ThemedView` for consistent styling
- **Chart Components**: `BarChart` and `PieChart` for data visualization
- **Card Components**: `BudgetCard`, `TransactionItem`, and `RecommendationCard`

### Screens

- **Dashboard**: Main screen with budget overview and recent transactions
- **Transactions**: List and manage all income and expenses
- **Analytics**: Visualize spending patterns with charts and insights
- **Settings**: Configure app preferences and account settings

## Development Workflow

### Adding New Features

1. Define the feature requirements and UI/UX design
2. Update types in `types/index.ts` if needed
3. Extend the data layer in `context/BudgetContext.tsx`
4. Create or update UI components in `components/`
5. Implement the feature in the appropriate screen
6. Test on multiple platforms (iOS, Android, web)

### Theming

The app supports both light and dark themes:
- Use `useColorScheme()` to detect the current theme
- Access theme colors from `Colors[colorScheme]`
- Use `ThemedText` and `ThemedView` for consistent styling

### Navigation

The app uses Expo Router for file-based navigation:
- Add new screens to the appropriate directory
- Use the `router` object for navigation between screens

## Code Change Tracking

### Version 1.0.0 (Initial Release)
- Created project structure with Expo and React Native
- Implemented tab-based navigation with Expo Router
- Added core UI components with theme support
- Created budget context for state management
- Implemented dashboard screen with budget overview
- Added transactions screen for managing income and expenses
- Created analytics screen with data visualizations
- Implemented settings screen for app configuration
- Added AI recommendation service for financial advice

### Version 1.1.0 (February 27, 2023)
- Enhanced dashboard with daily spending limits
- Improved transaction categorization
- Added bar chart and pie chart visualizations
- Implemented AI recommendations based on spending patterns
- Added theme support for light and dark modes
- Improved navigation between screens
- Fixed styling issues on different platforms

### Version 1.2.0 (Current)
- Added monthly budget summary
- Enhanced analytics with spending trends
- Improved category breakdown visualization
- Added transaction filtering by date and category
- Enhanced AI recommendations with more personalized advice
- Fixed navigation issues between tabs
- Improved performance and reduced bundle size

## Planned Features

- Budget goal setting
- Recurring transactions
- Export functionality for transaction data
- Biometric authentication
- Cloud sync for user data
- Receipt scanning
- Multi-currency support

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.
