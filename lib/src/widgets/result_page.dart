import 'package:adhd_helper/constants/appbar.dart';
import 'package:adhd_helper/constants/background.dart';
import 'package:adhd_helper/src/screens/home_screen.dart';
import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  final int totalScore;
  final int scoreA;
  final int scoreB;
  final int scoreC;
  final int scoreD;
  final int scoreE;
  final int scoreF;

  const ResultPage({
    super.key,
    required this.totalScore,
    required this.scoreA,
    required this.scoreB,
    required this.scoreC,
    required this.scoreD,
    required this.scoreE,
    required this.scoreF,
  });

  String getResultMessage(int score) {
    if (score > 70) {
      return 'فوق المتوسط بدرجة كبيرة جدا';
    } else if (score >= 66 && score <= 70) {
      return 'فوق المتوسط بدرجة كبيرة';
    } else if (score >= 61 && score <= 65) {
      return 'فوق المتوسط';
    } else if (score >= 56 && score <= 60) {
      return 'فوق المتوسط بدرجة طفيفة';
    } else if (score >= 45 && score <= 55) {
      return 'المتوسط';
    } else if (score >= 40 && score <= 44) {
      return 'أقل من المتوسط بدرجة طفيفة';
    } else if (score >= 35 && score <= 39) {
      return 'أقل من المتوسط';
    } else if (score >= 30 && score <= 34) {
      return 'أقل من المتوسط بدرجة كبيرة';
    } else if (score < 30) {
      return 'أقل من المتوسط بدرجة كبيرة جدا';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    String resultMessage = getResultMessage(totalScore);

    return Scaffold(
      appBar: appBar,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            background,
            SizedBox(
              height: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    Card(
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              'مجموع النقاط: $totalScore',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal.shade700,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              resultMessage,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal.shade600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Card(
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              'درجة الإضطرابات :',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal.shade700,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            _buildScoreItem('اضطرابات المسلك', scoreA),
                            _buildScoreItem('مشكال التعلم', scoreB),
                            _buildScoreItem('مشكال نفسي جسمية', scoreC),
                            _buildScoreItem('االاندفاعية–فرط النشاط', scoreD),
                            _buildScoreItem('القلق', scoreE),
                            _buildScoreItem('دليل فرط النشاط', scoreF),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen()));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal.shade600,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: const Text(
                        'انتقل إلى قائمة الأنشطة',
                        style: TextStyle(fontSize: 16.0, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreItem(String label, int score) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.black87,
            ),
          ),
          Text(
            '$score',
            style: TextStyle(
              fontSize: 18,
              color: Colors.teal.shade700,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
