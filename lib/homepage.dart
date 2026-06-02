import 'dart:async';
import 'package:flutter/material.dart';
import 'package:project_smartdiet/Calorie_Counter.dart';
import 'package:project_smartdiet/auth/login.dart';
import 'package:project_smartdiet/exercise_routine_page.dart';
import 'package:project_smartdiet/settings_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';



final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://lsytwwiazndayxrxnvtt.supabase.co',
    anonKey: 'sb_publishable_QilD54JZbZIe_TLH3eb2Ng_jldo_t2q',
  );

  runApp(const SmartDietApp());
}



class SmartDietApp extends StatelessWidget {
  const SmartDietApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, ThemeMode currentMode, __) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'SmartDiet',
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            scaffoldBackgroundColor: const Color(0xFFFAFAFC),
            cardColor: Colors.white,
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            cardColor: Colors.grey[900],
          ),
          themeMode: currentMode,
          home: Supabase.instance.client.auth.currentSession == null
              ? const LoginPage()
              : const MainNavigationWrapper(),
        );
      },
    );
  }
}



final Color primaryBurgundy = const Color(0xFF881B42);
final Color bgLightAccent = const Color(0xFFFAFAFC);
final Color baseCardColor = Colors.white;



class MainNavigationWrapper extends StatefulWidget {
  const MainNavigationWrapper({super.key});

  @override
  State<MainNavigationWrapper> createState() => _MainNavigationWrapperState();
}

class _MainNavigationWrapperState extends State<MainNavigationWrapper> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const SmartDietHomePage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: "Home",
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}



class SmartDietHomePage extends StatefulWidget {
  const SmartDietHomePage({super.key});

  @override
  State<SmartDietHomePage> createState() => _SmartDietHomePageState();
}

class _SmartDietHomePageState extends State<SmartDietHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  void _calculateAndGo() {
    double? height = double.tryParse(_heightController.text);
    double? weight = double.tryParse(_weightController.text);

    if (height != null && weight != null && height > 0) {
      double heightInMeters = height / 100;
      double bmiResult = weight / (heightInMeters * heightInMeters);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DietDetailsPage(bmi: bmiResult),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter valid height & weight"),
        ),
      );
    }
  }

  Future<void> _logout() async {
    await Supabase.instance.client.auth.signOut();

    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
        (route) => false,
      );
    }
  }

  @override
  void dispose() {
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: isDark ? null : bgLightAccent,
      endDrawer: _buildProfileDrawer(context),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBrandLogo(),
              const SizedBox(height: 32),

              
              Row(
                children: [
                  Expanded(
                    child: _buildImageFeatureCard(
                      title: "Blood Pressure",
                      subtitle: "Log & Analyze",
                      icon: Icons.monitor_heart_outlined,
                      accentColor: primaryBurgundy,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const BloodPressurePage(),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: _buildImageFeatureCard(
                      title: "Calorie Counter",
                      subtitle: "Track meals",
                      icon: Icons.local_fire_department,
                      accentColor: const Color(0xFFE24C5F),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CalorieCounterPage(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              _buildImageFeatureCard(
                title: "Exercise Routine",
                subtitle: "Daily Fitness",
                icon: Icons.fitness_center,
                accentColor: Colors.cyan,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ExerciseRoutinePage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 36),
              const Text(
                "Health Metrics",
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: _buildInputField(
                      _ageController,
                      "Age",
                      Icons.calendar_today_outlined,
                      TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildInputField(
                      _heightController,
                      "Height (cm)",
                      Icons.height,
                      TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildInputField(
                _weightController,
                "Weight (kg)",
                Icons.monitor_weight_outlined,
                TextInputType.number,
              ),
              const SizedBox(height: 32),
              _buildMainButton(
                "Calculate BMI & Generate Diet",
                _calculateAndGo,
              ),
              const SizedBox(height: 32),
              _buildRecommendationBox(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBrandLogo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: primaryBurgundy.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                Icons.apps_rounded,
                color: primaryBurgundy,
              ),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "SmartDiet",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Health is wealth",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
        IconButton(
          onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
          icon: Icon(
            Icons.person_outline,
            color: primaryBurgundy,
            size: 30,
          ),
        ),
      ],
    );
  }

  Widget _buildInputField(
    TextEditingController controller,
    String hint,
    IconData icon,
    TextInputType type,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : baseCardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: type,
        decoration: InputDecoration(
          hintText: hint,
          icon: Icon(icon, color: primaryBurgundy),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildMainButton(String label, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBurgundy,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 2,
        ),
        child: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildImageFeatureCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color accentColor,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(25),
      child: Container(
        padding: const EdgeInsets.all(20),
        height: 160,
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[850] : baseCardColor,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 6),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: accentColor, size: 28),
            ),
            const SizedBox(height: 15),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationBox() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : baseCardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: primaryBurgundy.withOpacity(0.1)),
      ),
      child: const Column(
        children: [
          Text(
            "⚡ Daily Tip",
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 8),
          Text(
            "Drink 8 glasses of water today!",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileDrawer(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    final userEmail = user?.email ?? "No email found";

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: primaryBurgundy),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white24,
                  child: Icon(Icons.person, size: 35, color: Colors.white),
                ),
                const SizedBox(height: 12),
                Text(
                  userEmail,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Settings"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Logout", style: TextStyle(color: Colors.red)),
            onTap: _logout,
          ),
        ],
      ),
    );
  }
}



class BloodPressurePage extends StatefulWidget {
  const BloodPressurePage({super.key});

  @override
  State<BloodPressurePage> createState() => _BloodPressurePageState();
}

class _BloodPressurePageState extends State<BloodPressurePage> {
  final systolicController = TextEditingController();
  final diastolicController = TextEditingController();

  String result = "";
  String subResult = "";
  Color resultColor = Colors.green;

  void checkBloodPressure() {
    int? systolic = int.tryParse(systolicController.text);
    int? diastolic = int.tryParse(diastolicController.text);

    if (systolic == null || diastolic == null) {
      setState(() {
        result = "Invalid Input";
        subResult = "Please enter valid numeric values.";
        resultColor = Colors.red;
      });
      return;
    }

    setState(() {
      if (systolic <= 120 && diastolic <= 80) {
        result = "Normal BP";
        subResult = "Your blood pressure is in an excellent & healthy range.";
        resultColor = const Color(0xFF2ECC71);
      } else if (systolic < 130 && diastolic < 80) {
        result = "Elevated BP";
        subResult = "Slightly high. Consider reducing sodium intake.";
        resultColor = Colors.orange;
      } else if (systolic <= 140 || diastolic <= 90) {
        result = "Hypertension Stage 1";
        subResult = "Seek advice regarding lifestyle changes.";
        resultColor = Colors.deepOrange;
      } else {
        result = "Hypertension Stage 2";
        subResult = "High risk. Please consult a doctor immediately.";
        resultColor = const Color(0xFFE74C3C);
      }
    });
  }

  @override
  void dispose() {
    systolicController.dispose();
    diastolicController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? null : const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text("Blood Pressure", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  )
                ],
              ),
              child: Column(
                children: [
                  _buildBPInputField("Systolic", "mmHg", systolicController, Icons.arrow_upward),
                  const Divider(height: 32, thickness: 0.8),
                  _buildBPInputField("Diastolic", "mmHg", diastolicController, Icons.arrow_downward),
                ],
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: checkBloodPressure,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBurgundy,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 2,
                ),
                child: const Text("Analyze Reading", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 35),
            if (result.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [resultColor, resultColor.withOpacity(0.75)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: resultColor.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      "ANALYSIS RESULT",
                      style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      result,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      subResult,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.3),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBPInputField(String label, String unit, TextEditingController controller, IconData icon) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: primaryBurgundy.withOpacity(0.1),
          child: Icon(icon, color: primaryBurgundy, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w600, fontSize: 13)),
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  hintText: "000",
                  suffixText: unit,
                  suffixStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                  border: InputBorder.none,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}



class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 260,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryBurgundy, primaryBurgundy.withOpacity(0.85)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                const CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.white24,
                  child: Icon(Icons.person, size: 55, color: Colors.white),
                ),
                const SizedBox(height: 15),
                Text(
                  user?.email ?? "User Session Active",
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  "Premium Member",
                  style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _buildProfileTile(Icons.history_rounded, "My Health Logs", "Track your analytical data", Colors.blue),
                _buildProfileTile(Icons.track_changes_rounded, "Dietary Goals", "Active weight loss target", Colors.orange),
                _buildProfileTile(Icons.notifications_active_outlined, "Reminders & Alerts", "Water/Meal prompt intervals", Colors.purple),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Divider(thickness: 0.5),
                ),
                _buildProfileTile(Icons.shield_outlined, "Privacy Policy", "Review security structures", Colors.teal),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildProfileTile(IconData icon, String title, String sub, Color color) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        subtitle: Text(sub, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey),
        onTap: () {},
      ),
    );
  }
}


class DietDetailsPage extends StatelessWidget {
  final double bmi;

  const DietDetailsPage({
    super.key,
    required this.bmi,
  });

  @override
  Widget build(BuildContext context) {
    String status;
    Color statusColor;
    String recommendationText;
    String exerciseAdvice;

    if (bmi < 18.5) {
      status = "Underweight";
      statusColor = Colors.orange;
      recommendationText = "Focus on a calorie surplus with complex carbohydrates, healthy fats, and high-quality lean protein.";
      exerciseAdvice = "Incorporate mild strength training to build muscle mass rather than intense cardio.";
    } else if (bmi < 25) {
      status = "Normal / Healthy";
      statusColor = const Color(0xFF2ECC71);
      recommendationText = "Maintain your stable weight with balanced meals incorporating rich whole grains, vegetables, and lean meat.";
      exerciseAdvice = "30 mins of moderate physical exercises/brisk walking 5 days a week.";
    } else {
      status = "Overweight";
      statusColor = Colors.red;
      recommendationText = "Prioritize a safe calorie deficit. Cut down refined sugars, processed items and increase leafy fibers.";
      exerciseAdvice = "Perform 45 mins of dedicated high-intensity interval training (HIIT) or swimming.";
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Health Analysis", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text("Your Calculated Body Mass Index", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
            const SizedBox(height: 12),
            Text(
              bmi.toStringAsFixed(1),
              style: TextStyle(fontSize: 65, fontWeight: FontWeight.w900, color: statusColor, letterSpacing: -1),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                status.toUpperCase(),
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: statusColor, letterSpacing: 1.5),
              ),
            ),
            const SizedBox(height: 40),
            _buildDietCard("Custom Diet Plan", recommendationText, Icons.restaurant_menu, primaryBurgundy),
            const SizedBox(height: 16),
            _buildDietCard("Activity Strategy", exerciseAdvice, Icons.directions_run_rounded, Colors.cyan),
          ],
        ),
      ),
    );
  }

  Widget _buildDietCard(String title, String desc, IconData icon, Color themeColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: baseCardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 12, offset: const Offset(0, 4))
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: themeColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: themeColor, size: 26),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 6),
                Text(
                  desc,
                  style: const TextStyle(color: Colors.black87, fontSize: 13.5, height: 1.4),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
