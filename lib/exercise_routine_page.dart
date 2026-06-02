import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ExerciseRoutinePage(),
  ));
}


class ExerciseRoutinePage extends StatefulWidget {
  const ExerciseRoutinePage({super.key});

  @override
  State<ExerciseRoutinePage> createState() => _ExerciseRoutinePageState();
}

class _ExerciseRoutinePageState extends State<ExerciseRoutinePage> {
  int seconds = 0;
  Timer? timer;
  bool isRunning = false;
  double calories = 0;

  final List<Map<String, dynamic>> routine = [
    {"time": "07:00 AM", "title": "Warm-up", "duration": 5, "calories": 20},
    {"time": "07:10 AM", "title": "Jumping Jacks", "duration": 10, "calories": 80},
    {"time": "07:25 AM", "title": "Push-ups", "duration": 10, "calories": 70},
    {"time": "07:40 AM", "title": "Squats", "duration": 15, "calories": 120},
    {"time": "08:00 AM", "title": "Yoga Cool Down", "duration": 10, "calories": 40},
  ];

  void startTimer() {
    if (isRunning) return;

    timer = Timer.periodic(
      const Duration(seconds: 1),
      (t) {
        setState(() {
          seconds++;
          calories += 0.15;
        });
      },
    );

    setState(() => isRunning = true);
  }

  void pauseTimer() {
    timer?.cancel();
    setState(() => isRunning = false);
  }

  void resetTimer() {
    timer?.cancel();

    setState(() {
      seconds = 0;
      calories = 0;
      isRunning = false;
    });
  }

  String formatTime(int sec) {
    final min = sec ~/ 60;
    final s = sec % 60;

    return "${min.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}";
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text(
          "FIT ROUTINE",
          style: TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
       
        foregroundColor: Colors.white, 
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

           
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Colors.white.withOpacity(0.05),
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00FFCC).withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),

              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text(
                      "WORKOUT SESSION",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2,
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),

                    const SizedBox(height: 15),

                    Text(
                      formatTime(seconds),
                      style: const TextStyle(
                        fontSize: 54,
                        fontWeight: FontWeight.w300,
                        fontFamily: 'Courier',
                        color: Color(0xFF00FFCC),
                        shadows: [
                          Shadow(
                            color: Color(0xFF00FFCC),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.local_fire_department,
                          color: Colors.amber,
                          size: 20,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          "${calories.toStringAsFixed(1)} kcal burned",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white.withOpacity(0.8),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),

                   
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildActionButton(
                          onPressed: isRunning ? null : startTimer,
                          icon: Icons.play_arrow_rounded,
                          label: "Start",
                          color: const Color(0xFF00FFCC),
                          textColor: Colors.black,
                        ),
                        _buildActionButton(
                          onPressed: isRunning ? pauseTimer : null,
                          icon: Icons.pause_rounded,
                          label: "Pause",
                          color: Colors.white.withOpacity(0.1),
                          textColor: Colors.white,
                        ),
                        _buildActionButton(
                          onPressed: resetTimer,
                          icon: Icons.refresh_rounded,
                          label: "Reset",
                          color: const Color(0xFFFF5252).withOpacity(0.2),
                          textColor: const Color(0xFFFF5252),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF8A2387),
                    Color(0xFFE94057),
                  ],
                ),
              ),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FeedbackPage(),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.star_outline_rounded,
                  color: Colors.white,
                ),
                label: const Text(
                  "Share Your Experience",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  minimumSize: const Size(double.infinity, 54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            
            const Text(
              "Today's Plan",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),

            const SizedBox(height: 15),

            
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: routine.length,
              itemBuilder: (context, index) {
                final item = routine[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.03),
                    ),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00FFCC).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.fitness_center_rounded,
                        color: Color(0xFF00FFCC),
                      ),
                    ),
                    title: Text(
                      item['title'],
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        "${item['time']}  •  ${item['duration']} min",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 13,
                        ),
                      ),
                    ),
                    trailing: Text(
                      "+${item['calories']} Cal",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00FFCC),
                        fontSize: 15,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  
  Widget _buildActionButton({
    required VoidCallback? onPressed,
    required IconData icon,
    required String label,
    required Color color,
    required Color textColor,
  }) {
    final bool isDisabled = onPressed == null;

    return Opacity(
      opacity: isDisabled ? 0.4 : 1.0,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: isDisabled ? Colors.grey.withOpacity(0.1) : color,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isDisabled ? Colors.white30 : textColor,
                size: 18,
              ),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  color: isDisabled ? Colors.white30 : textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final TextEditingController _feedbackController = TextEditingController();
  double _rating = 4.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text(
          "FEEDBACK",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
       
        foregroundColor: Colors.white, 
      ),
      body: SafeArea( 
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "How was your workout session?",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),

             
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: const Color(0xFFE94057),
                  inactiveTrackColor: Colors.white.withOpacity(0.1),
                  thumbColor: Colors.white,
                  overlayColor: const Color(0xFFE94057).withOpacity(0.2),
                  valueIndicatorColor: const Color(0xFFE94057),
                  valueIndicatorTextStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: Slider(
                  value: _rating,
                  min: 1,
                  max: 5,
                  divisions: 4,
                  label: _rating.toInt().toString(),
                  onChanged: (value) {
                    setState(() => _rating = value);
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Tired 😫",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
                    Text(
                      "Energetic ⚡",
                      style: TextStyle(
                        color: const Color(0xFF00FFCC).withOpacity(0.8),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 35),

              const Text(
                "Additional Comments",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),

              TextField(
                controller: _feedbackController,
                maxLines: 4,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "What could we improve?",
                  hintStyle: TextStyle(
                    color: Colors.white.withOpacity(0.3),
                  ),
                  filled: true,
                  fillColor: const Color(0xFF1E1E1E),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: Colors.white.withOpacity(0.05),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: Color(0xFFE94057),
                    ),
                  ),
                ),
              ),

              const Spacer(),

              
              Container(
                width: double.infinity,
                height: 54,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFE94057).withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: const Color(0xFF1E1E1E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        content: const Text(
                          "Routine Feedback Saved!",
                          style: TextStyle(
                            color: Color(0xFF00FFCC),
                          ),
                        ),
                      ),
                    );

                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE94057),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    "SUBMIT FEEDBACK",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}




