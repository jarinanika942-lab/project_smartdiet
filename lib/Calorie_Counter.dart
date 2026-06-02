
import 'package:flutter/material.dart';

class CalorieCounterPage extends StatefulWidget {
  const CalorieCounterPage({super.key});

  @override
  State<CalorieCounterPage> createState() => _CalorieCounterPageState();
}

class _CalorieCounterPageState extends State<CalorieCounterPage> {
  final TextEditingController calorieController = TextEditingController();
  final TextEditingController foodController = TextEditingController();

  List<Map<String, dynamic>> foodList = [];
  int totalCalories = 0;

  final int dailyGoalCalories = 2000;

  void addFood(String name, int calories) {
    setState(() {
      foodList.add({
        "food": name,
        "calories": calories,
      });
      totalCalories += calories;
    });
  }

  void removeFood(int index) {
    setState(() {
      totalCalories -= (foodList[index]["calories"] as int);
      if (totalCalories < 0) totalCalories = 0;
      foodList.removeAt(index);
    });
  }

  @override
  void dispose() {
    calorieController.dispose();
    foodController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double progressPercent = totalCalories / dailyGoalCalories;
    if (progressPercent > 1.0) progressPercent = 1.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),

      appBar: AppBar(
        title: const Text(
          "Calorie Tracker",
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.w800,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),

      body: Column(
        children: [
          
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF10B981), Color(0xFF059669)],
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Total Calories Consumed",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 10),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "$totalCalories",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "/ $dailyGoalCalories kcal",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progressPercent,
                    backgroundColor: Colors.white24,
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.white),
                    minHeight: 8,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  totalCalories >= dailyGoalCalories
                      ? "🔥 Target reached!"
                      : "${(dailyGoalCalories - totalCalories)} kcal remaining",
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Today's Log",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: foodList.isEmpty
                ? const Center(
                    child: Text("No food added yet"),
                  )
                : ListView.builder(
                    itemCount: foodList.length,
                    itemBuilder: (context, index) {
                      final item = foodList[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        child: ListTile(
                          leading: const Icon(Icons.fastfood),
                          title: Text(item["food"]),
                          subtitle:
                              Text("${item["calories"]} kcal"),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete,
                                color: Colors.red),
                            onPressed: () => removeFood(index),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showDialog,
        backgroundColor: const Color(0xFF10B981),
        icon: const Icon(Icons.add),
        label: const Text("Add Food"),
      ),
    );
  }

  
  void _showDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Food"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: foodController,
              decoration: const InputDecoration(
                labelText: "Food Name",
              ),
            ),
            TextField(
              controller: calorieController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Calories",
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              final cal =
                  int.tryParse(calorieController.text);

              if (foodController.text.isNotEmpty &&
                  cal != null) {
                addFood(foodController.text, cal);
              }

              foodController.clear();
              calorieController.clear();
              Navigator.pop(context);
            },
            child: const Text("Add"),
          )
        ],
      ),
    );
  }
}
