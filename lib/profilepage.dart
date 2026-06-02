import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Timer? reminderTimer;

  String reminderText = "💡 Tap 'Start Tips' to get active lifestyle reminders!";
  String userName = "SmartDiet User";
  double latestBmi = 24.2;
  bool isReminderActive = false;
  int waterCups = 0;

  final List<String> healthMessages = [
    "💧 Time to drink a glass of water!",
    "🚰 Stay hydrated — your body needs water now!",
    "💦 Drink water before you feel thirsty.",
    "🍎 Eat a fruit to keep your energy up.",
    "🥗 Add vegetables to your next meal.",
    "🍗 Include protein in your diet today.",
    "🚶 Take a 5-minute walk around the room.",
    "🧠 Take a deep breath and relax.",
    "💤 Proper sleep helps weight control.",
    "🌞 Get some sunlight today.",
    "🚶 Walk after meals for better digestion.",
    "⚡ Stay active, avoid laziness.",
  ];

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  void loadUserData() {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      setState(() {
        userName = (user.userMetadata?['name'] ?? "SmartDiet User").toString();
      });
    }
  }

  Map<String, dynamic> getDiet(double bmi) {
    if (bmi <= 0) return {"status": "No Data", "calories": 0, "color": Colors.grey, "plans": []};
    if (bmi < 18.5) {
      return {
        "status": "Underweight",
        "calories": 2800,
        "color": const Color(0xFF2196F3),
        "plans": [
          {"time": "08:00 AM", "meal": "Breakfast", "desc": "2 Eggs + 2 Toast + 1 Banana", "icon": Icons.wb_sunny_rounded},
          {"time": "01:30 PM", "meal": "Lunch", "desc": "Rice + Chicken/Beef + Dal", "icon": Icons.light_mode_rounded},
          {"time": "08:30 PM", "meal": "Dinner", "desc": "Roti + Fish Curry + Veg", "icon": Icons.nightlight_round},
        ]
      };
    }
    if (bmi < 25) {
      return {
        "status": "Normal Weight",
        "calories": 2200,
        "color": const Color(0xFF00C853),
        "plans": [
          {"time": "08:30 AM", "meal": "Breakfast", "desc": "Egg + Oats / Bread", "icon": Icons.wb_sunny_rounded},
          {"time": "01:30 PM", "meal": "Lunch", "desc": "Rice + Fish + Salad", "icon": Icons.light_mode_rounded},
          {"time": "08:30 PM", "meal": "Dinner", "desc": "Roti + Veg Soup", "icon": Icons.nightlight_round},
        ]
      };
    }
    return {
      "status": "Overweight",
      "calories": 1800,
      "color": const Color(0xFFFF3D00),
      "plans": [
        {"time": "08:30 AM", "meal": "Breakfast", "desc": "Egg white + Apple + Tea", "icon": Icons.wb_sunny_rounded},
        {"time": "01:30 PM", "meal": "Lunch", "desc": "Brown rice + Chicken + Salad", "icon": Icons.light_mode_rounded},
        {"time": "08:00 PM", "meal": "Dinner", "desc": "Veg soup / Light food", "icon": Icons.nightlight_round},
      ]
    };
  }

  void startReminder() {
    reminderTimer?.cancel();
    int index = 0;
    setState(() {
      isReminderActive = true;
      reminderText = "🚀 Reminder Active!";
    });
    reminderTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (!mounted) return;
      setState(() {
        reminderText = healthMessages[index];
        index = (index + 1) % healthMessages.length;
      });
    });
  }

  void stopReminder() {
    reminderTimer?.cancel();
    setState(() {
      isReminderActive = false;
      reminderText = "🛑 Reminder stopped.";
    });
  }

  @override
  void dispose() {
    reminderTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final diet = getDiet(latestBmi);
    final List plans = diet["plans"] as List;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          "My Profile",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
       
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.green,
                    child: Icon(Icons.person, size: 50, color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    userName,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const Text("Stay Healthy & Fit", style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            const SizedBox(height: 30),

          
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
              ),
              child: Row(
                children: [
                  const Icon(Icons.water_drop, color: Colors.blue, size: 30),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Water Intake", style: TextStyle(fontWeight: FontWeight.bold)),
                        Text("$waterCups / 8 Cups", style: const TextStyle(fontSize: 18, color: Colors.blueAccent)),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => setState(() { if (waterCups > 0) waterCups--; }),
                    icon: const Icon(Icons.remove_circle_outline),
                  ),
                  IconButton(
                    onPressed: () => setState(() { if (waterCups < 12) waterCups++; }),
                    icon: const Icon(Icons.add_circle_outline, color: Colors.blue),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

           
            const Text("Smart Reminder", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.orange.withOpacity(0.3)),
              ),
              child: Text(
                reminderText,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: isReminderActive ? null : startReminder,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                    child: const Text("Start Tips"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: isReminderActive ? stopReminder : null,
                    style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                    child: const Text("Stop"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

           
            const Text("Daily Diet Plan", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ...plans.map((plan) => Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.green.withOpacity(0.1),
                  child: Icon(plan["icon"], color: Colors.green),
                ),
                title: Text(plan["meal"], style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(plan["desc"]),
                trailing: Text(plan["time"], style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ),
            )).toList(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}