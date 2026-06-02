import 'package:flutter/material.dart';
import 'exercise_routine_page.dart';

class DietDetailsPage extends StatelessWidget {
  final String bmiResult;
  final String mealPlan;
  final String goal;

  const DietDetailsPage({
    super.key,
    required this.bmiResult,
    required this.mealPlan,
    required this.goal,
  });


  Map<String, String> getMealPlan() {
    if (goal == "Weight Gain") {
      return {
        "Breakfast": "Milk, Banana, Peanut Butter Toast",
        "Lunch": "Rice, Chicken, Potato, Vegetables",
        "Dinner": "Egg, Fish, Nuts, Salad",
      };
    } else if (goal == "Weight Loss") {
      return {
        "Breakfast": "Oats, Boiled Egg, Green Tea",
        "Lunch": "Brown Rice, Grilled Chicken, Salad",
        "Dinner": "Soup, Vegetables, Fish",
      };
    } else {
      return {
        "Breakfast": "Eggs, Toast, Milk",
        "Lunch": "Rice, Fish, Vegetables",
        "Dinner": "Salad, Soup, Chicken",
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    final meals = getMealPlan();
    
    const primaryPurple = Color(0xFF6A1B9A);
    const accentPurple = Color(0xFF9C27B0);
    const lightPurpleBg = Color(0xFFF3E5F5);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Diet Details",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: primaryPurple,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(bottom: 30, left: 20, right: 20, top: 10),
              decoration: const BoxDecoration(
                color: primaryPurple,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white24,
                    child: Icon(Icons.auto_awesome, color: Colors.white, size: 40),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    goal.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      bmiResult,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  const Text(
                    "Daily Meal Plan",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: primaryPurple,
                    ),
                  ),
                  const SizedBox(height: 15),

                  _buildModernMealCard(
                    context: context,
                    icon: Icons.wb_twilight_rounded,
                    title: "Breakfast",
                    food: meals["Breakfast"]!,
                    time: "07:00 - 09:00 AM",
                    color: Colors.deepPurpleAccent,
                  ),
                  _buildModernMealCard(
                    context: context,
                    icon: Icons.wb_sunny_rounded,
                    title: "Lunch",
                    food: meals["Lunch"]!,
                    time: "12:00 - 02:00 PM",
                    color: accentPurple,
                  ),
                  _buildModernMealCard(
                    context: context,
                    icon: Icons.nightlight_round,
                    title: "Dinner",
                    food: meals["Dinner"]!,
                    time: "07:00 - 08:30 PM",
                    color: primaryPurple,
                  ),

                  const SizedBox(height: 30),

                 
                  const Text(
                    "Smart Health Tips",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: primaryPurple,
                    ),
                  ),
                  const SizedBox(height: 15),

                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: lightPurpleBg,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        _buildPurpleTip("Drink 3L of water daily", Icons.water_drop),
                        _buildPurpleTip("Stay active for 30 mins", Icons.directions_run),
                        _buildPurpleTip("Avoid refined sugar", Icons.no_food),
                        _buildPurpleTip("Consistent sleep cycle", Icons.bedtime),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

             
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryPurple,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 5,
                        shadowColor: primaryPurple.withOpacity(0.4),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ExerciseRoutinePage(),
                          ),
                        );
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.fitness_center),
                          SizedBox(width: 10),
                          Text(
                            "View Exercise Routine",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  
  Widget _buildModernMealCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String food,
    required String time,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, color: color, size: 30),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      time,
                      style: TextStyle(color: Colors.grey[500], fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  food,
                  style: TextStyle(color: Colors.grey[700], fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  
  Widget _buildPurpleTip(String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.purple[800], size: 20),
          const SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(
              fontSize: 15,
              color: Colors.purple[900],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

