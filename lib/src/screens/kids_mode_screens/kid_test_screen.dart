import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:adhd_helper/constants/appbar.dart';
import 'package:adhd_helper/constants/background.dart';
import 'package:adhd_helper/src/screens/home_screen.dart';
import 'package:adhd_helper/src/widgets/submit_button.dart';
import 'package:flutter/material.dart';

import '../../services/firestore_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class KidTest extends StatefulWidget {
  const KidTest({super.key});

  @override
  State<KidTest> createState() => _KidTestState();
}

class _KidTestState extends State<KidTest> {
  final FirestoreService _firestoreService = FirestoreService();

  String letter = "";

  bool isGameStarted = false;
  List<int> isiVals = [1, 2, 4];
  int blockSize = 20;
  int presTime = 400;
  int cycles = 6;

  late DateTime tappingTime;
  bool tapping = false;
  bool taptap = false;

  List<int> rtCorr1 = [];
  List<int> rtCorr2 = [];
  List<int> rtCorr4 = [];
  List<int> rtInc1 = [];
  List<int> rtInc2 = [];
  List<int> rtInc4 = [];
  int om1 = 0;
  int om2 = 0;
  int om4 = 0;
  int co1 = 0;
  int co2 = 0;
  int co4 = 0;

  int targ1 = 0;
  int targ2 = 0;
  int targ4 = 0;
  int corT1 = 0;
  int corT2 = 0;
  int corT4 = 0;
  int corF1 = 0;
  int corF2 = 0;
  int corF4 = 0;

  @override
  Widget build(BuildContext context) {
    String instruction = AppLocalizations.of(context)!.getReadyMessage;
    return Scaffold(
      appBar: appBar,
      body: Stack(
        children: [
          background,
          SizedBox(
            height: double.infinity,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 40.0, vertical: 40.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          if (tapping) {
                            tapping = false;
                            taptap = true;
                            tappingTime = DateTime.now();
                          }
                        },
                        child: Container(
                          height: 500,
                          decoration: BoxDecoration(
                            color: Colors
                                .white, // Set the background color to white
                            border: Border.all(
                              color: Colors
                                  .transparent, // Set the border color to black
                              width: 2.0, // Set the border width
                            ),
                          ),
                          child: Center(
                            child: Text(
                              isGameStarted ? letter : instruction,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: isGameStarted ? 150.0 : 35.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (!isGameStarted)
                        SubmitButton(
                            onPressed: startGame,
                            buttonText: AppLocalizations.of(context)!.start)
                      else
                        SubmitButton(
                            onPressed: stopGame,
                            buttonText: AppLocalizations.of(context)!.stop)
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void startGame() {
    setState(() {
      isGameStarted = true;
    });
    letsgo();
  }

  void stopGame() {
    setState(() {
      isGameStarted = false;
      setState(() {
        letter = "";
      });
    });
  }

  Map<String, Map<String, dynamic>> blocksdata = {};

  List<int> hrtparblock = [];
  int omparblock = 0;
  int comparblock = 0;

  List<double> meanhrtparblock = [];

  Future<void> letsgo() async {
    await Future.delayed(const Duration(seconds: 1));
    List<String> listifletter =
        generateRandomStrings(blockSize, (blockSize * 0.35).round());
    List<int> isiValsseq = shuffleAndRepeat(isiVals, cycles);
    int trialnumberber = 0;
    int block = 0;

    for (int isi in isiValsseq) {
      block++;
      int blocktrial = 1;
      int letternumberberber = -1;
      listifletter.shuffle();
      while (blocktrial <= blockSize) {
        int rt = -1;
        int responded = 0;
        letternumberberber++;
        trialnumberber++;
        blocktrial++;
        String stim = listifletter[letternumberberber];
        print('Block: $block, Trial: $trialnumberber, isi: $isi, Stim: $stim');
        DateTime startTime = DateTime.now();
        tapping = true;
        setState(() {
          letter = stim;
        });

        await Future.delayed(Duration(milliseconds: presTime));
        setState(() {
          letter = "";
        });
        await Future.delayed(Duration(seconds: isi));
        if (taptap) {
          responded = 1;
          rt = tappingTime.difference(startTime).inMilliseconds;
          taptap = false;
          print("rt = $rt");
        } else {
          print("you didn't tap");
        }

        // Score trial as correct or incorrect
        int corr;
        if (stim == AppLocalizations.of(context)!.target) {
          corr = 1 - responded;
        } else {
          corr = responded;
        }

        // Update the correct targets/foils counters

        if (isi == 1) {
          if (stim == AppLocalizations.of(context)!.target) {
            corF1 += corr;
          } else {
            corT1 += corr;
            targ1++;
          }

          if (responded == 1) {
            if (corr == 1) {
              rtCorr1.add(rt);
              hrtparblock.add(rt);
            } else {
              rtInc1.add(rt);
              co1++;
              comparblock++;
            }
          } else {
            om1 += (1 - corr);
            omparblock += (1 - corr);
          }
        } else if (isi == 2) {
          if (stim == AppLocalizations.of(context)!.target) {
            corF2 += corr;
          } else {
            corT2 += corr;
            targ2++;
          }

          if (responded == 1) {
            if (corr == 1) {
              rtCorr2.add(rt);
              hrtparblock.add(rt);
            } else {
              rtInc2.add(rt);
              co2++;
              comparblock++;
            }
          } else {
            om2 += (1 - corr);
            omparblock += (1 - corr);
          }
        } else if (isi == 4) {
          if (stim == AppLocalizations.of(context)!.target) {
            corF4 += corr;
          } else {
            corT4 += corr;
            targ4++;
          }

          if (responded == 1) {
            if (corr == 1) {
              rtCorr4.add(rt);
              hrtparblock.add(rt);
            } else {
              rtInc4.add(rt);
              co4++;
              comparblock++;
            }
          } else {
            om4 += (1 - corr);
            omparblock += (1 - corr);
          }
        }
      }
      if (block % 3 == 0) {
        int count = block ~/ 3;
        Map<String, dynamic> newData = {
          "hrt": meanX(hrtparblock),
          "Omissions": double.parse(
              ((omparblock / ((blockSize - (blockSize * 0.35).round()) * 3)) *
                      100)
                  .toStringAsFixed(2)),
          "Commissions": double.parse(
              ((comparblock / ((blockSize * 0.35).round() * 3)) * 100)
                  .toStringAsFixed(2)),
        };
        meanhrtparblock.add(meanX(hrtparblock));
        blocksdata["$count"] = newData;

        hrtparblock = [];
        omparblock = 0;
        comparblock = 0;
      }
    }
    int trialsPerCond = blockSize * cycles;

    // Compute the numberberber of foils for each delay condition.
    int foil1 = trialsPerCond - targ1;
    int foil2 = trialsPerCond - targ2;
    int foil4 = trialsPerCond - targ4;

    Map<String, dynamic> jsonData = {
      'blocks': blocksdata,
      "isi": {
        "1": {
          "hrt": meanX(rtCorr1),
          "Omissions": double.parse(((om1 / targ1) * 100).toStringAsFixed(2)),
          "Commissions": double.parse(((co1 / foil1) * 100).toStringAsFixed(2))
        },
        "2": {
          "hrt": meanX(rtCorr2),
          "Omissions": double.parse(((om2 / targ2) * 100).toStringAsFixed(2)),
          "Commissions": double.parse(((co2 / foil2) * 100).toStringAsFixed(2))
        },
        "4": {
          "hrt": meanX(rtCorr4),
          "Omissions": double.parse(((om4 / targ4) * 100).toStringAsFixed(2)),
          "Commissions": double.parse(((co4 / foil4) * 100).toStringAsFixed(2))
        }
      },
      'raw': {
        "d'": {
          "HR": (corT1 + corT2 + corT4) / (targ1 + targ2 + targ4),
          "FR": 1 - (corF1 + corF2 + corF4) / max([1, (foil1 + foil2 + foil4)]),
        },
        "Omissions": double.parse(
            (((om1 + om2 + om4) / (targ1 + targ2 + targ4)) * 100)
                .toStringAsFixed(2)),
        "Commissions": double.parse(
            (((co1 + co2 + co4) / (foil1 + foil2 + foil4)) * 100)
                .toStringAsFixed(2)),
        "HitReactionTime": meanX(flatten([rtCorr1, rtCorr2, rtCorr4])),
        "HRT Standard Deviation": sd(flatten([rtCorr1, rtCorr2, rtCorr4])),
        "HRT Block Change": gethrtchange(meanhrtparblock),
        "HRT Inter-Stimulus Interval":
            gethrtchange([meanX(rtCorr1), meanX(rtCorr2), meanX(rtCorr4)]),
      },
      "total": {
        "trails": trialsPerCond * 3,
        "target": targ1 + targ2 + targ4,
        "foils": foil1 + foil2 + foil4,
        "correctTargets": corT1 + corT2 + corT4,
        "CorrectFoils": corF1 + corF2 + corF4,
      }
    };
    print(jsonData);
    // Convert the map to JSON.
    String jsonString = jsonEncode(jsonData);

    // Print or save the JSON data as needed.
    print(jsonString); // Print the JSON data.

    _firestoreService.saveCPTTest(jsonData);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const HomeScreen(), // Create a RegistrationScreen class
      ),
    );
  }

  List<String> generateRandomStrings(
      int numberberberOfLetters, int numberberberOfX) {
    if (numberberberOfX > numberberberOfLetters) {
      throw ArgumentError(
          "numberberber of 'X' cannot be greater than the numberberber of letters.");
    }

    final random = Random();
    String letters = AppLocalizations.of(context)!.letters;

    List<String> result = [];

    for (int i = 0; i < numberberberOfLetters; i++) {
      if (i < numberberberOfX) {
        // Add 'X' to the result for the specified numberberber of times.
        result.add(AppLocalizations.of(context)!.target);
      } else {
        // Generate a random letter and add it to the result.
        int index = random.nextInt(letters.length);
        result.add(letters[index]);
      }
    }

    result.shuffle(); // Shuffle the list to randomize the order.

    return result;
  }

  List<int> shuffleAndRepeat(List<int> list, int repeat) {
    List<int> result = [];
    for (int i = 0; i < repeat; i++) {
      list.shuffle();
      result.addAll(list);
    }
    return result;
  }

  double round(double number, int sig) {
    num multiplier = pow(10, sig.toDouble());
    return (number * multiplier).roundToDouble() / multiplier;
  }

  double max(List<int> values) {
    return values.reduce(maxValue).toDouble();
  }

  int maxValue(int a, int b) {
    return a > b ? a : b;
  }

  double meanX(List<int> list) {
    if (list.isEmpty) {
      return 0; // Return "NA" or NaN for an empty list.
    } else {
      double sum = 0;
      for (int value in list) {
        sum += value;
      }
      double mean = sum / list.length;
      return double.parse(
          mean.toStringAsFixed(2)); // Round to two decimal places.
    }
  }

  List<int> flatten(List<List<int>> lists) {
    List<int> combinedList = [];
    for (List<int> sublist in lists) {
      combinedList.addAll(sublist);
    }
    return combinedList;
  }

  sd(List<int> data) {
    if (data.isEmpty) {
      return 0; // Return "NA" or NaN for an empty list.
    } else {
      double mean = calculateMean(data);

      double sumOfSquares = 0;
      for (int value in data) {
        sumOfSquares += pow(value - mean, 2);
      }

      double variance = sumOfSquares / (data.length - 1);
      double result = sqrt(variance);
      return double.parse(result.toStringAsFixed(2));
      // Round to two decimal plces.
    }
  }

  double calculateMean(List<int> data) {
    int sum = data.reduce((a, b) => a + b);
    return sum / data.length;
  }

  List<int> getRest(List<int> list1, List<int> list2) {
    // Use the where method to filter out elements present in list2
    List<int> result =
        list1.where((element) => !list2.contains(element)).toList();
    return result;
  }

  gethrtchange(List<double> numbers) {
    double sumOfDifferences = 0.0;

    for (int i = 0; i < numbers.length - 1; i++) {
      double difference = numbers[i + 1] - numbers[i];
      sumOfDifferences += difference;
    }
    double result = sumOfDifferences / (numbers.length - 1);
    return double.parse(result.toStringAsFixed(2));
  }
}
