import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'routes/app_routes.dart';
import 'utils/constants.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    print('Checking API Initialization...');
    await ApiClient.init(); 
    print('API Initialized successfully.');
  } catch (e) {
    print('Initialization Error: $e');
  }

  runApp(
    MultiProvider(
      providers: [
        Provider<String>(create: (_) => 'AppDiDong'),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Perfume App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFDEAEB)),
        textTheme: GoogleFonts.outfitTextTheme(Theme.of(context).textTheme),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: AppRoutes.login, 
      routes: AppRoutes.getRoutes(),
      debugShowCheckedModeBanner: false,
    );
  }
}

