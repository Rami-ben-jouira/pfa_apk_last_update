import 'package:adhd_helper/src/screens/chatbot/chatbot_screen.dart';
import 'package:aura_box/aura_box.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatefulWidget {
  const ChatBubble({super.key});

  @override
  _ChatBubbleState createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  double x = 300;
  double y = 600;
  double bubbleSize = 110; // Size of the floating chat bubble

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final double topBarHeight =
        AppBar().preferredSize.height + MediaQuery.of(context).padding.top;

    return Positioned(
      left: x,
      top: y,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            x += details.delta.dx;
            y += details.delta.dy;
          });
        },
        onPanEnd: (details) {
          setState(() {
            if (x + (bubbleSize / 2) < screenWidth / 2) {
              x = -10; // Snap left
            } else {
              x = screenWidth - bubbleSize + 10; // Snap right
            }
            y = y.clamp(topBarHeight, screenHeight - 120);
          });
        },
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => ChatbotWindow(),
          );
        },
        child: Image.asset(
          'images/01_logo.gif',
          width: bubbleSize,
          height: bubbleSize,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class ChatbotWindow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(), // Close when clicking outside
      child: Container(
        color: const Color.fromARGB(
            0, 0, 0, 0), // Semi-transparent background for overlay effect
        child: Align(
          alignment: Alignment.bottomCenter, // Position at the bottom
          child: LayoutBuilder(
            builder: (context, constraints) {
              double screenWidth = constraints.maxWidth;
              double screenHeight = constraints.maxHeight;

              return GestureDetector(
                onTap: () {}, // Prevents taps inside the window from closing it
                child: Container(
                  width: screenWidth * 0.9,
                  height: screenHeight * 0.85, // Keep 75% of screen height
                  margin:
                      EdgeInsets.only(bottom: 30), // Small padding from bottom
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white, // Color at the top
                        Colors.transparent, // Transparent in the middle
                        Colors.transparent, // Transparent at the bottom
                      ],
                      stops: [
                        0.0,
                        0.5,
                        1.0
                      ], // Control the positions of the transparency
                    ),
                  ),
                  child: Column(
                    children: [
                      // Header
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: Center(
                          child: Container(
                            width: 50, // The width of the line
                            height: 4, // The height of the line
                            decoration: BoxDecoration(
                              color: Colors.grey[400], // Color of the line
                              borderRadius:
                                  BorderRadius.circular(2), // Rounded edges
                            ),
                          ),
                        ),
                      ),

                      // Chatbot Content (with scroll support)
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(20)),
                          child: SingleChildScrollView(
                            child: SizedBox(
                              height: screenHeight *
                                  0.82, // Adjusted to make it align with the edge (considering the margin)
                              child: ChatbotScreen(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

Widget _buildAuraBackground() {
  return Positioned.fill(
    child: AuraBox(
      spots: [
        AuraSpot(
          color: Colors.deepPurple.shade900, // Dark purple for a cozy feel
          radius: 250.0,
          alignment: Alignment.topLeft,
          blurRadius: 80.0,
          stops: const [0.0, 0.7],
        ),
        AuraSpot(
          color: Colors.indigo.shade800, // Deep blue for a mysterious touch
          radius: 300.0,
          alignment: Alignment.center,
          blurRadius: 100.0,
          stops: const [0.0, 0.8],
        ),
        AuraSpot(
          color: Colors.pinkAccent.shade700, // Darker pink for some contrast
          radius: 250.0,
          alignment: Alignment.bottomRight,
          blurRadius: 70.0,
          stops: const [0.0, 0.6],
        ),
      ],
      decoration: BoxDecoration(
        color: Colors.black, // Dark base to enhance the glowing effect
      ),
      child: Container(), // Empty child to satisfy the requirement
    ),
  );
}
