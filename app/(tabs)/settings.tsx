import React, { useState } from 'react';
import { StyleSheet, ScrollView, View, TouchableOpacity, Switch, Alert } from 'react-native';
import { useRouter } from 'expo-router';

import { ThemedText } from '@/components/ThemedText';
import { ThemedView } from '@/components/ThemedView';
import { IconSymbol } from '@/components/ui/IconSymbol';
import { Colors } from '@/constants/Colors';
import { useColorScheme } from '@/hooks/useColorScheme';

export default function SettingsScreen() {
  const router = useRouter();
  const colorScheme = useColorScheme() ?? 'light';
  const colors = Colors[colorScheme];
  
  // Settings state
  const [notificationsEnabled, setNotificationsEnabled] = useState(true);
  const [smsReadingEnabled, setSmsReadingEnabled] = useState(false);
  const [biometricAuthEnabled, setBiometricAuthEnabled] = useState(false);
  const [currency, setCurrency] = useState('USD');
  
  // Handle logout
  const handleLogout = () => {
    Alert.alert(
      'Logout',
      'Are you sure you want to logout?',
      [
        {
          text: 'Cancel',
          style: 'cancel',
        },
        {
          text: 'Logout',
          onPress: () => {
            // In a real app, you would implement logout logic here
            alert('Logout functionality coming soon!');
          },
          style: 'destructive',
        },
      ]
    );
  };
  
  // Handle account deletion
  const handleDeleteAccount = () => {
    Alert.alert(
      'Delete Account',
      'Are you sure you want to delete your account? This action cannot be undone.',
      [
        {
          text: 'Cancel',
          style: 'cancel',
        },
        {
          text: 'Delete',
          onPress: () => {
            // In a real app, you would implement account deletion logic here
            alert('Account deletion functionality coming soon!');
          },
          style: 'destructive',
        },
      ]
    );
  };
  
  // Render a setting item with a switch
  const renderSwitchSetting = (
    title: string,
    description: string,
    value: boolean,
    onValueChange: (value: boolean) => void
  ) => (
    <View style={[styles.settingItem, { borderBottomColor: colors.border }]}>
      <View style={styles.settingContent}>
        <ThemedText type="defaultSemiBold">{title}</ThemedText>
        <ThemedText style={styles.settingDescription}>{description}</ThemedText>
      </View>
      <Switch
        value={value}
        onValueChange={onValueChange}
        trackColor={{ false: colors.border, true: colors.tint }}
        thumbColor={colors.background}
      />
    </View>
  );
  
  // Render a setting item with navigation
  const renderNavigationSetting = (
    title: string,
    description: string,
    onPress: () => void
  ) => (
    <TouchableOpacity 
      style={[styles.settingItem, { borderBottomColor: colors.border }]}
      onPress={onPress}
    >
      <View style={styles.settingContent}>
        <ThemedText type="defaultSemiBold">{title}</ThemedText>
        <ThemedText style={styles.settingDescription}>{description}</ThemedText>
      </View>
      <IconSymbol name="chevron.right" size={20} color={colors.icon} />
    </TouchableOpacity>
  );
  
  return (
    <ThemedView style={styles.container}>
      <ScrollView style={styles.scrollView} contentContainerStyle={styles.scrollContent}>
        <View style={styles.header}>
          <ThemedText type="title">Settings</ThemedText>
        </View>
        
        {/* Account Section */}
        <View style={styles.section}>
          <ThemedText type="subtitle">Account</ThemedText>
          
          <ThemedView style={styles.settingGroup}>
            {renderNavigationSetting(
              'Profile',
              'Manage your personal information',
              () => alert('Profile settings coming soon!')
            )}
            
            {renderNavigationSetting(
              'Security',
              'Manage your password and security settings',
              () => alert('Security settings coming soon!')
            )}
            
            {renderSwitchSetting(
              'Biometric Authentication',
              'Use fingerprint or face recognition to login',
              biometricAuthEnabled,
              setBiometricAuthEnabled
            )}
          </ThemedView>
        </View>
        
        {/* Preferences Section */}
        <View style={styles.section}>
          <ThemedText type="subtitle">Preferences</ThemedText>
          
          <ThemedView style={styles.settingGroup}>
            {renderNavigationSetting(
              'Currency',
              `Current: ${currency}`,
              () => alert('Currency settings coming soon!')
            )}
            
            {renderNavigationSetting(
              'Theme',
              `Current: ${colorScheme === 'dark' ? 'Dark' : 'Light'}`,
              () => alert('Theme settings coming soon!')
            )}
            
            {renderSwitchSetting(
              'Notifications',
              'Receive budget alerts and reminders',
              notificationsEnabled,
              setNotificationsEnabled
            )}
          </ThemedView>
        </View>
        
        {/* Data Section */}
        <View style={styles.section}>
          <ThemedText type="subtitle">Data</ThemedText>
          
          <ThemedView style={styles.settingGroup}>
            {renderSwitchSetting(
              'SMS Reading',
              'Automatically detect transactions from SMS',
              smsReadingEnabled,
              setSmsReadingEnabled
            )}
            
            {renderNavigationSetting(
              'Export Data',
              'Export your budget data as CSV',
              () => alert('Export functionality coming soon!')
            )}
            
            {renderNavigationSetting(
              'Backup & Restore',
              'Backup your data to the cloud',
              () => alert('Backup functionality coming soon!')
            )}
          </ThemedView>
        </View>
        
        {/* About Section */}
        <View style={styles.section}>
          <ThemedText type="subtitle">About</ThemedText>
          
          <ThemedView style={styles.settingGroup}>
            {renderNavigationSetting(
              'About BudgetAI',
              'Learn more about the app',
              () => alert('About page coming soon!')
            )}
            
            {renderNavigationSetting(
              'Privacy Policy',
              'Read our privacy policy',
              () => alert('Privacy policy coming soon!')
            )}
            
            {renderNavigationSetting(
              'Terms of Service',
              'Read our terms of service',
              () => alert('Terms of service coming soon!')
            )}
          </ThemedView>
        </View>
        
        {/* Logout and Delete Account */}
        <View style={styles.section}>
          <TouchableOpacity 
            style={[styles.button, styles.logoutButton, { borderColor: colors.tint }]}
            onPress={handleLogout}
          >
            <ThemedText style={[styles.buttonText, { color: colors.tint }]}>
              Logout
            </ThemedText>
          </TouchableOpacity>
          
          <TouchableOpacity 
            style={[styles.button, styles.deleteButton, { borderColor: colors.error }]}
            onPress={handleDeleteAccount}
          >
            <ThemedText style={[styles.buttonText, { color: colors.error }]}>
              Delete Account
            </ThemedText>
          </TouchableOpacity>
        </View>
        
        <ThemedText style={styles.versionText}>
          BudgetAI v1.0.0
        </ThemedText>
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
    marginBottom: 24,
  },
  section: {
    marginBottom: 24,
  },
  settingGroup: {
    borderRadius: 12,
    overflow: 'hidden',
    marginTop: 8,
  },
  settingItem: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingVertical: 16,
    paddingHorizontal: 16,
    borderBottomWidth: 1,
  },
  settingContent: {
    flex: 1,
    marginRight: 16,
  },
  settingDescription: {
    fontSize: 14,
    opacity: 0.7,
    marginTop: 2,
  },
  button: {
    borderWidth: 1,
    borderRadius: 12,
    paddingVertical: 16,
    alignItems: 'center',
    marginBottom: 12,
  },
  logoutButton: {
    backgroundColor: 'transparent',
  },
  deleteButton: {
    backgroundColor: 'transparent',
  },
  buttonText: {
    fontWeight: '600',
  },
  versionText: {
    textAlign: 'center',
    marginTop: 16,
    marginBottom: 32,
    opacity: 0.5,
  },
}); 