// main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:leaf_n_lit/screens/splash/splash_screen.dart';
import 'utilities/firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'utilities/app_state.dart';
import 'screens/home/home_page.dart';
import 'screens/registration/registration_screen.dart';
import 'screens/login/login_screen.dart';
import 'screens/library/library.dart';
import 'screens/library/search.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

void main() async {
  print('Application starting');
  WidgetsFlutterBinding.ensureInitialized();
  print('Initializing Firebase');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print('Firebase initialized successfully');
  runApp(
    ChangeNotifierProvider(
      create: (context) => ApplicationState(),
      builder: (context, child) => const MyApp(),
    ),
  );
  print('App running');
}

final GoRouter _router = GoRouter(
  navigatorKey: rootNavigatorKey,
  routes: [
    GoRoute(
      path: "/",
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: "/login",
      pageBuilder: (context, state) {
        print('Navigating to login screen');
        return CustomTransitionPage(
          key: state.pageKey,
          child: LoginScreen(),
          transitionDuration: const Duration(milliseconds: 800),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
      },
    ),
    GoRoute(
      path: "/home",
      pageBuilder: (context, state) {
        print('Navigating to home screen');
        return CustomTransitionPage(
          key: state.pageKey,
          child: const MyHomePage(title: "Leaf n' Lit"),
          transitionDuration: const Duration(milliseconds: 350),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        );
      },
    ),
    GoRoute(
      path: "/register",
      pageBuilder: (context, state) {
        print('Navigating to registration screen');
        return CustomTransitionPage(
          key: state.pageKey,
          child: const RegistrationScreen(),
          transitionDuration: const Duration(milliseconds: 350),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        );
      },
    ),
    GoRoute(
      path: "/library",
      builder: (context, state) {
        print('Navigating to library screen');
        return const LibraryPage();
      },
    ),
    GoRoute(
      path: "/search",
      pageBuilder: (context, state) {
        print('Navigating to search screen');
        return CustomTransitionPage(
          key: state.pageKey,
          child: const SearchScreen(),
          transitionDuration: const Duration(milliseconds: 350),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        );
      },
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        print('Screen tapped - resetting inactivity timer');
        Provider.of<ApplicationState>(context, listen: false).resetInactivityTimer();
      },
      onTapUp: (_) {
        print('Screen tap finished - resetting inactivity timer');
        Provider.of<ApplicationState>(context, listen: false).resetInactivityTimer();
      },
      child: MaterialApp.router(
        title: 'Leaf & Lit',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          useMaterial3: true,
        ),
        routerConfig: _router,
      ),
    );
  }
}
