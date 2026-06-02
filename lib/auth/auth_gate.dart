import 'package:flutter/material.dart';
import 'package:project_smartdiet/homepage.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'login.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;

    final session = supabase.auth.currentSession;

    if (session != null) {
      return const SmartDietHomePage();
    } else {
      return const LoginPage();
    }
  }
}
