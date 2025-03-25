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
  OverlayEntry? _chatbotOverlay;

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
          _showChatbotWindow(context);
        },
        child: Image.asset(
          'assets/images/01_logo.gif',
          width: bubbleSize,
          height: bubbleSize,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  void _showChatbotWindow(BuildContext context) {
    if (_chatbotOverlay != null) {
      _chatbotOverlay!.remove();
      _chatbotOverlay = null;
      return;
    }

    double startY = MediaQuery.of(context).size.height * 0.15; // Start position
    double maxY =
        MediaQuery.of(context).size.height * 0.95; // Maximum swipe limit
    double currentY = startY;
    double opacity = 0.7;
    bool isDragging = false;
    bool isClosing = false;
    Duration animationDuration = Duration(milliseconds: 300);

    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return GestureDetector(
              behavior: HitTestBehavior
                  .opaque, // Ensure whole screen detects gestures
              onTap: () {
                if (!isClosing) {
                  isClosing = true;
                  setState(() {
                    currentY = maxY;
                    opacity = 0.0;
                  });
                  Future.delayed(animationDuration, () {
                    _chatbotOverlay?.remove();
                    _chatbotOverlay = null;
                  });
                }
              },
              child: Stack(
                children: [
                  AnimatedContainer(
                    duration: animationDuration,
                    color: Colors.black.withOpacity(opacity),
                  ),
                  AnimatedPositioned(
                    duration: isDragging ? Duration.zero : animationDuration,
                    curve: Curves.easeOutCubic,
                    left: 0,
                    right: 0,
                    top: currentY,
                    child: GestureDetector(
                      onTap: () {}, // Prevent click inside from closing
                      onVerticalDragStart: (_) => isDragging = true,
                      onVerticalDragUpdate: (details) {
                        setState(() {
                          // Allow only downward movement
                          currentY = (currentY + details.delta.dy * 0.8)
                              .clamp(startY, maxY);
                          opacity = (0.7 -
                                  ((currentY - startY) / (maxY - startY) * 0.7))
                              .clamp(0.1, 0.7);
                        });
                      },
                      onVerticalDragEnd: (details) {
                        isDragging = false;
                        if (details.primaryVelocity! > 500 ||
                            currentY > maxY - 150) {
                          // If swiped fast or far enough, dismiss smoothly
                          isClosing = true;
                          setState(() {
                            currentY = maxY;
                            opacity = 0.0;
                          });
                          Future.delayed(animationDuration, () {
                            _chatbotOverlay?.remove();
                            _chatbotOverlay = null;
                          });
                        } else {
                          // Snap back if not swiped far enough
                          setState(() {
                            currentY = startY;
                            opacity = 0.7;
                          });
                        }
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        margin: EdgeInsets.fromLTRB(
                            20, 0, 20, 0), // Small padding from bottom
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
                            // Swipe Down Indicator
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 10, bottom: 10),
                              child: Center(
                                child: Container(
                                  width: 50,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[400],
                                    borderRadius: BorderRadius.circular(2),
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
                                    height: MediaQuery.of(context).size.height *
                                        0.8,
                                    child: ChatbotScreen(),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    _chatbotOverlay = overlayEntry;
    Overlay.of(context)?.insert(_chatbotOverlay!);
  }
}

Widget _buildAuraBackground() {
  return Positioned.fill(
    child: AuraBox(
      spots: [
        AuraSpot(
          color: Colors.deepPurple.shade900,
          radius: 250.0,
          alignment: Alignment.topLeft,
          blurRadius: 80.0,
          stops: const [0.0, 0.7],
        ),
        AuraSpot(
          color: Colors.indigo.shade800,
          radius: 300.0,
          alignment: Alignment.center,
          blurRadius: 100.0,
          stops: const [0.0, 0.8],
        ),
        AuraSpot(
          color: Colors.pinkAccent.shade700,
          radius: 250.0,
          alignment: Alignment.bottomRight,
          blurRadius: 70.0,
          stops: const [0.0, 0.6],
        ),
      ],
      decoration: BoxDecoration(
        color: Colors.black,
      ),
      child: Container(),
    ),
  );
}
