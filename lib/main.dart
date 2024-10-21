import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'utilities/firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'utilities/app_state.dart';
import 'screens/home/home_page.dart';
import 'screens/registration/registration_screen.dart';
import 'screens/login/login_screen.dart';
import 'screens/library/library.dart';
// import 'screens/library/search.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => ApplicationState(),
      builder: (context, child) => const MyApp(),
    ),
  );
}

// Define routes to switch between screens using GoRouter
final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      path: "/",
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: "/home",
      builder: (context, state) => const MyHomePage(title: 'Leaf & Lit'),
    ),
    GoRoute(
      path: "/register",
      builder: (context, state) => RegistrationScreen(),
    ),
    GoRoute(
      path: "/library",
      builder: (context, state) => LibraryPage(),
    ),
    // GoRoute(
    //   path: "/search",
    //   builder: (context, state) => const SearchScreen(),
    // ),
    // GoRoute(
    //   path: "/garden",
    //   builder:(context, state) => const GardenPage(),
    // ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Leaf & Lit',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}
