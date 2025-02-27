/**
 * Below are the colors that are used in the app. The colors are defined in the light and dark mode.
 * There are many other ways to style your app. For example, [Nativewind](https://www.nativewind.dev/), [Tamagui](https://tamagui.dev/), [unistyles](https://reactnativeunistyles.vercel.app), etc.
 */

const tintColorLight = '#0a7ea4';
const tintColorDark = '#fff';

export const Colors = {
  light: {
    text: '#11181C',
    background: '#fff',
    tint: tintColorLight,
    icon: '#687076',
    tabIconDefault: '#687076',
    tabIconSelected: tintColorLight,
    income: '#4CAF50',
    expense: '#F44336',
    card: '#F5F5F5',
    border: '#E0E0E0',
    success: '#4CAF50',
    warning: '#FFC107',
    error: '#F44336',
    info: '#2196F3',
    chart: {
      primary: '#0a7ea4',
      secondary: '#4CAF50',
      tertiary: '#FFC107',
      quaternary: '#F44336',
      quinary: '#9C27B0',
    }
  },
  dark: {
    text: '#ECEDEE',
    background: '#151718',
    tint: tintColorDark,
    icon: '#9BA1A6',
    tabIconDefault: '#9BA1A6',
    tabIconSelected: tintColorDark,
    income: '#81C784',
    expense: '#E57373',
    card: '#1E1E1E',
    border: '#333333',
    success: '#81C784',
    warning: '#FFD54F',
    error: '#E57373',
    info: '#64B5F6',
    chart: {
      primary: '#64B5F6',
      secondary: '#81C784',
      tertiary: '#FFD54F',
      quaternary: '#E57373',
      quinary: '#CE93D8',
    }
  },
};
