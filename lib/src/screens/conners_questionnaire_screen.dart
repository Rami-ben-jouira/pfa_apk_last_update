import 'package:adhd_helper/constants/appbar.dart';
import 'package:adhd_helper/constants/background.dart';
import 'package:adhd_helper/src/models/conner_quiz.dart';
import 'package:adhd_helper/src/services/auth_service.dart';
import 'package:adhd_helper/src/services/firestore_service.dart';
import 'package:adhd_helper/src/widgets/result_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ConnersSreen extends StatefulWidget {
  const ConnersSreen({super.key});

  @override
  State<ConnersSreen> createState() => _ConnersSreenState();
}

class _ConnersSreenState extends State<ConnersSreen> {
  final FirebaseAuthService authService = FirebaseAuthService();
  final FirestoreService storeService = FirestoreService();
  List<String> questions = [
    "يقضم الأشياء (مثل الأظافر، الأصابع، الشعر، الملابس)",
    "لا يحترم من هو أكبر منه سنا",
    "يجد صعوبة في تكوين الصداقات والاحتفاظ بها",
    " مندفع ومن السهل استثارته ",
    " يرغب أن يتحكم ",
    " يمص أصابعه أو يمضغ ملابسه أو غطاء النوم ",
    " سريع البكاء ",
    "مستعد دائما للمشاجرات ",
    " يميل إلى أحلام اليقظة",
    " يعاني من صعوبات تعلم ",
    " كثير الحركة، لا يستطيع أن يمكث في مكانه",
    "شديد الخوف (من المواقف الجديدة، الأشخاص أو الأماكن الجديدة، ومن الذهاب إلى المدرسة)",
    " كثير الحركة، يحتاج دوماً للقيام بشيء ما",
    "مخرب (يدمر كل ما يقع في يده) ",
    " يكذب أو يختلق قصص غير حقيقية ",
    "خجول",
    " يعرض نفسه لمشكلات أكثر من أقرانه ",
    " يتحدث بصورة مختلفة عما يتحدث به من هم في نفس عمره (حديث الأطفال الصغار أو التمتمة والكلام الذي يصعب فهمه) ",
    "ينكر ارتكابه للأخطاء ويلقي اللوم على الآخرين",
    "مشاكس يتصنع المشاكل ",
    "يقطب جبينه ويظهر استياء (يعبس)",
    "يستولي على ممتلكات غيره ",
    " غير مطيع أو يطيع بصورة متمردة ",
    "يقلق أكثر من الآخرين بسبب الوحدة أو المرض أو الموت ",
    " يجد صعوبة في إتمام ما شرع في القيام به ",
    "مشاعره حساسة للغاية ",
    " يهدد الآخرين بالعتداء عليهم",
    "يجد صعوبة في إتمام نشاط مكرر",
    "قاسي",
    "طفولي أو غير ناضج ويحتاج للمساعدة في أمور يجب ألا يحتاج إليها، يتأثر بالآخرين، ويحتاج إلى الطمأنينة المستمرة",
    "التشتت وقلة مدى الانتباه تمثل مشكلة بالنسبة لها",
    "يشعر بالصداع",
    "تتقلب حالته المزاجية بسرعة وبصورة جوهرية",
    "لا يحب اتباع القواعد والضوابط",
    "يتشاجر بصورة مستمرة",
    "لا يتناسب مع إخوته وأخواته",
    "من السهل أن يشعر بالإحباط أثناء قيامه بجهد",
    "يُضايِق ويُزعِج الأطفال الآخرين",
    "لا يبدو عليه السعادة بشكل أساسي (طفل غير سعيد)",
    "مشكلات مصاحبة لتناول الطعام مثل ضعف الشهية",
    "لديه ألم في المعدة",
    "لديه مشكلات في النوم",
    "اضطرابات وآلام أخرى",
    "القيء أو الشعور بالغثيان",
    "يشعر بأن الأسرة تخدعه",
    " التباهي أو التفاخر",
    "يترك نفسه عرضة لنبذ الآخرين",
    "مشاكل في المعدة (إسهال متكرر، عادات غير منتظمة وإمساك)",
  ];

  List<String> answers = ["لا يوجد", "بقدر محدود", "كثيرا", "بقدر كبير جدا"];
  Map<String, String> selectedAnswers = {};
  int currentQuestionIndex = 0;

  List<int> scoreAQuestions = [39, 35, 27, 21, 19, 14, 8, 2];
  List<int> scoreBQuestions = [37, 31, 25, 10];
  List<int> scoreCQuestions = [32, 41, 43, 44];
  List<int> scoreDQuestions = [4, 5, 11, 13];
  List<int> scoreEQuestions = [12, 16, 24, 47];
  List<int> scoreFQuestions = [4, 7, 11, 13, 14, 25, 31, 33, 37, 38];

  @override
  Widget build(BuildContext context) {
    double progress = (currentQuestionIndex + 1) / questions.length;
    int answeredQuestions = selectedAnswers.length;

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
                    const SizedBox(height: 10),
                    Container(
                      width: 200,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 25.0),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: [
                                const TextSpan(
                                  text: '“',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30.0,
                                    color: Colors.red,
                                  ),
                                ),
                                TextSpan(
                                  text: questions[currentQuestionIndex],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                    color: Colors.black,
                                  ),
                                ),
                                const TextSpan(
                                  text: '”',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30.0,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey[200],
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.red),
                    ),
                    const SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'السؤال $answeredQuestions من ${questions.length}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...answers.map((answer) {
                      return Row(
                        children: [
                          const SizedBox(width: 50),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            margin: const EdgeInsets.symmetric(vertical: 10.0),
                            padding: const EdgeInsets.all(3.0),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(30.0),
                              border: Border.all(color: Colors.cyanAccent),
                            ),
                            child: RadioListTile<String>(
                              title: Text(
                                answer,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                  color: Colors.black,
                                ),
                              ),
                              value: answer,
                              groupValue: selectedAnswers[
                                  questions[currentQuestionIndex]],
                              onChanged: (value) {
                                setState(() {
                                  selectedAnswers[
                                      questions[currentQuestionIndex]] = value!;
                                });
                              },
                              activeColor: Colors.red,
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (selectedAnswers
                            .containsKey(questions[currentQuestionIndex])) {
                          if (currentQuestionIndex < questions.length - 1) {
                            setState(() {
                              currentQuestionIndex++;
                            });
                          } else {
                            Enregistre(selectedAnswers);
                          }
                        } else {
                          AfficherMessage(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlue,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: Text(
                        currentQuestionIndex < questions.length - 1
                            ? 'التالي'
                            : 'عرض النتيجة',
                        style: const TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void AfficherMessage(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("الرجاء الإجابة على السؤال قبل المتابعة"),
          actions: [
            TextButton(
              child: const Text("حسناً"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> Enregistre(Map<String, String> responses) async {
    int totalScore = 0;
    int scoreA = 0;
    int scoreB = 0;
    int scoreC = 0;
    int scoreD = 0;
    int scoreE = 0;
    int scoreF = 0;

    responses.forEach((question, answer) {
      int index = questions.indexOf(question);
      int score = 0;
      if (answer == "بقدر محدود") {
        score = 1;
      } else if (answer == "كثيرا")
        score = 2;
      else if (answer == "بقدر كبير جدا") score = 3;
      totalScore += score;

      if (scoreAQuestions.contains(index)) scoreA += score;
      if (scoreBQuestions.contains(index)) scoreB += score;
      if (scoreCQuestions.contains(index)) scoreC += score;
      if (scoreDQuestions.contains(index)) scoreD += score;
      if (scoreEQuestions.contains(index)) scoreE += score;
      if (scoreFQuestions.contains(index)) scoreF += score;
    });
    String? idEnfant = await storeService.getCurrentChildId();

    ConnerQuiz conners = ConnerQuiz(
        childId: idEnfant!,
        timestamp: FieldValue.serverTimestamp(),
        responses: responses,
        totalScore: totalScore,
        scoreA: scoreA,
        scoreB: scoreB,
        scoreC: scoreC,
        scoreD: scoreD,
        scoreE: scoreE,
        scoreF: scoreF);

    storeService.addConnerQuiz(conners);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ResultPage(
          totalScore: totalScore,
          scoreA: scoreA,
          scoreB: scoreB,
          scoreC: scoreC,
          scoreD: scoreD,
          scoreE: scoreE,
          scoreF: scoreF,
        ),
      ),
    );
  }
}
