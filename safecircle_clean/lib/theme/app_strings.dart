class AppStrings {
  static bool isUrdu = false;

  // App Name
  static String get appName => isUrdu ? 'SafeCircle' : 'SafeCircle';
  static String get tagline => isUrdu ? 'Apnon Ki Hifazat' : 'Protect Your Loved Ones';
  static String get poweredBy => isUrdu ? 'Datanura AI ki taraf se' : 'Powered by Datanura AI';

  // Auth
  static String get login => isUrdu ? 'Login Karein' : 'Login';
  static String get signup => isUrdu ? 'Account Banayein' : 'Sign Up';
  static String get email => isUrdu ? 'Email' : 'Email';
  static String get password => isUrdu ? 'Password' : 'Password';
  static String get name => isUrdu ? 'Apna Naam' : 'Your Name';
  static String get forgotPassword => isUrdu ? 'Password bhool gaye?' : 'Forgot Password?';
  static String get noAccount => isUrdu ? 'Account nahi hai?' : 'Don\'t have an account?';
  static String get haveAccount => isUrdu ? 'Account hai?' : 'Already have an account?';

  // Role Selection
  static String get chooseRole => isUrdu ? 'Aap kaun hain?' : 'Who are you?';
  static String get guardian => isUrdu ? 'Guardian' : 'Guardian';
  static String get member => isUrdu ? 'Member' : 'Member';
  static String get guardianDesc => isUrdu ? 'Main family ki nigrani karna chahta hoon' : 'I want to monitor my family';
  static String get memberDesc => isUrdu ? 'Mujhe track kiya ja raha hai' : 'I am being monitored';

  // Dashboard
  static String get dashboard => isUrdu ? 'Dashboard' : 'Dashboard';
  static String get familyMembers => isUrdu ? 'Family Members' : 'Family Members';
  static String get addMember => isUrdu ? 'Member Add Karein' : 'Add Member';
  static String get alerts => isUrdu ? 'Alerts' : 'Alerts';
  static String get location => isUrdu ? 'Location' : 'Location';
  static String get activity => isUrdu ? 'Activity' : 'Activity';
  static String get reports => isUrdu ? 'Reports' : 'Reports';
  static String get settings => isUrdu ? 'Settings' : 'Settings';

  // Invite
  static String get inviteCode => isUrdu ? 'Invite Code' : 'Invite Code';
  static String get generateCode => isUrdu ? 'Code Banayein' : 'Generate Code';
  static String get enterCode => isUrdu ? 'Code Dalein' : 'Enter Code';
  static String get joinFamily => isUrdu ? 'Family Join Karein' : 'Join Family';
  static String get codeExpiry => isUrdu ? 'Yeh code 24 ghante mein expire hoga' : 'This code expires in 24 hours';
  static String get shareCode => isUrdu ? 'Yeh code member ko bhejein' : 'Share this code with member';

  // Activity
  static String get appUsage => isUrdu ? 'Apps ka Istemal' : 'App Usage';
  static String get screenTime => isUrdu ? 'Screen Time' : 'Screen Time';
  static String get callLogs => isUrdu ? 'Call History' : 'Call Logs';
  static String get websites => isUrdu ? 'Websites' : 'Websites Visited';
  static String get todayActivity => isUrdu ? 'Aaj ki Activity' : 'Today\'s Activity';
  static String get weeklyReport => isUrdu ? 'Hafta Bhar ki Report' : 'Weekly Report';

  // Alerts
  static String get alertNormal => isUrdu ? 'Sab Theek Hai' : 'All Normal';
  static String get alertCaution => isUrdu ? 'Dhyan Dein' : 'Caution';
  static String get alertDanger => isUrdu ? 'Foran Dekhein!' : 'Immediate Attention!';
  static String get suspiciousActivity => isUrdu ? 'Shak wali Activity' : 'Suspicious Activity';
  static String get lateNightUsage => isUrdu ? 'Raat ko Phone Use' : 'Late Night Usage';
  static String get locationAlert => isUrdu ? 'Location Alert' : 'Location Alert';
  static String get newAppInstalled => isUrdu ? 'Nai App Install Hui' : 'New App Installed';

  // Trust Score
  static String get trustScore => isUrdu ? 'Trust Score' : 'Trust Score';
  static String get excellent => isUrdu ? 'Zabardast' : 'Excellent';
  static String get good => isUrdu ? 'Acha' : 'Good';
  static String get needsAttention => isUrdu ? 'Dhyan Chahiye' : 'Needs Attention';

  // Safe Zones
  static String get safeZones => isUrdu ? 'Safe Ilaqe' : 'Safe Zones';
  static String get addZone => isUrdu ? 'Ilaqah Add Karein' : 'Add Zone';
  static String get home => isUrdu ? 'Ghar' : 'Home';
  static String get school => isUrdu ? 'School' : 'School';
  static String get leftZone => isUrdu ? 'Safe zone se bahar gaya!' : 'Left safe zone!';
  static String get enteredZone => isUrdu ? 'Safe zone mein aa gaya' : 'Entered safe zone';

  // General
  static String get save => isUrdu ? 'Save Karein' : 'Save';
  static String get cancel => isUrdu ? 'Radd Karein' : 'Cancel';
  static String get confirm => isUrdu ? 'Theek Hai' : 'Confirm';
  static String get loading => isUrdu ? 'Load ho raha hai...' : 'Loading...';
  static String get error => isUrdu ? 'Kuch Galat Hua' : 'Something went wrong';
  static String get success => isUrdu ? 'Ho Gaya!' : 'Success!';
  static String get online => isUrdu ? 'Online' : 'Online';
  static String get offline => isUrdu ? 'Offline' : 'Offline';
  static String get lastSeen => isUrdu ? 'Akhri baar' : 'Last seen';
  static String get viewDetails => isUrdu ? 'Tafseel Dekhein' : 'View Details';
  static String get disconnect => isUrdu ? 'Disconnect Karein' : 'Disconnect';
  static String get areYouSure => isUrdu ? 'Kya Aap Sure Hain?' : 'Are you sure?';
}
