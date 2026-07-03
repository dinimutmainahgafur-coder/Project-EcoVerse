import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'core/theme.dart';
import 'providers/auth_provider.dart';
import 'providers/mission_provider.dart';
import 'providers/journal_provider.dart';
import 'providers/academy_provider.dart';
import 'providers/leaderboard_provider.dart';

import 'screens/splash/splash_screen.dart';
import 'screens/login/login_screen.dart';
import 'screens/register/register_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/journal/journal_screen.dart';
import 'screens/mission/mission_screen.dart';
import 'screens/mission_detail/mission_detail_screen.dart';
import 'screens/upload/upload_screen.dart';
import 'screens/academy/academy_screen.dart';
import 'screens/challenge/challenge_screen.dart';
import 'screens/leaderboard/leaderboard_screen.dart';
import 'screens/profile/profile_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const EcoVerseApp());
}

class EcoVerseApp extends StatelessWidget {
  const EcoVerseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => MissionProvider()),
        ChangeNotifierProvider(create: (_) => JournalProvider()),
        ChangeNotifierProvider(create: (_) => AcademyProvider()),
        ChangeNotifierProvider(create: (_) => LeaderboardProvider()),
      ],
      child: MaterialApp(
        title: 'EcoVerse',
        debugShowCheckedModeBanner: false,
        theme: EcoTheme.lightTheme,
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/dashboard': (context) => const DashboardScreen(),
          '/journal': (context) => const JournalScreen(),
          '/mission': (context) => const MissionScreen(),
          '/mission_detail': (context) => const MissionDetailScreen(),
          '/upload': (context) => const UploadScreen(),
          '/academy': (context) => const AcademyScreen(),
          '/challenge': (context) => const ChallengeScreen(),
          '/leaderboard': (context) => const LeaderboardScreen(),
          '/profile': (context) => const ProfileScreen(),
        },
      ),
    );
  }
}
