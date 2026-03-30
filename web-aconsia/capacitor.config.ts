import type { CapacitorConfig } from '@capacitor/cli';

const config: CapacitorConfig = {
  appId: 'com.aconsia.app',
  appName: 'ACONSIA',
  webDir: 'dist',
  server: {
    androidScheme: 'https'
  },
  plugins: {
    SplashScreen: {
      launchShowDuration: 2000,
      backgroundColor: "#3b82f6",
      showSpinner: false,
      androidSpinnerStyle: "small",
      iosSpinnerStyle: "small"
    }
  }
};

export default config;
