import 'package:flutter/material.dart';

class ChatBubbleProvider with ChangeNotifier {
  bool _showBubble = true; // ✅ Start with bubble always visible

  bool get showBubble => _showBubble;

  // ✅ Toggle bubble visibility manually (if needed)
  void setBubbleVisibility(bool isVisible) {
    _showBubble = isVisible;
    notifyListeners();
  }
}




/*import 'package:flutter/material.dart';

class ChatBubbleProvider with ChangeNotifier {
  bool _showBubble = false;
  String _currentPage = ""; // Track the current active page

  bool get showBubble => _showBubble;

  // Method to set the current page and decide whether to show the bubble
  void setCurrentPage(String page) {
    _currentPage = page;

    // Check if the current page is one where the bubble should NOT appear
    if (_currentPage == "Exercices" ||
        _currentPage == "LancerQuestion" ||
        _currentPage == "QuestionsPage1" ||
        _currentPage == "Exercices1") {
      _showBubble = true; //  show bubble on these pages
    } else {
      _showBubble = false; //Don't Show bubble on other pages
    }
    print("Show Bubble: $_showBubble");

    notifyListeners();
  }
}*/
