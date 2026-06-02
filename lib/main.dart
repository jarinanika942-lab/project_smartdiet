import 'package:flutter/material.dart';
import 'package:project_smartdiet/auth/auth_gate.dart';

import 'package:supabase_flutter/supabase_flutter.dart';


final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  
  await Supabase.initialize(
    url: 'https://lsytwwiazndayxrxnvtt.supabase.co',
    anonKey: 'sb_publishable_QilD54JZbZIe_TLH3eb2Ng_jldo_t2q', 
    
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, currentMode, __) {
        return MaterialApp(
          title: 'SmartDiet',
          debugShowCheckedModeBanner: false,
          
          
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            colorSchemeSeed: Colors.green,
            scaffoldBackgroundColor: const Color(0xFFF5F7FA),
          ),
          
          
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            colorSchemeSeed: Colors.green,
          ),
          
          themeMode: currentMode, 
          home: const AuthGate(), 
        );
      },
    );
  }
}