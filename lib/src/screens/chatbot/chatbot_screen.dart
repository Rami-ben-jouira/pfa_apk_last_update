import 'package:adhd_helper/src/services/ChatProvider/secrets.dart';
import 'package:aura_box/aura_box.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_tts/flutter_tts.dart'; // Importez flutter_tts

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({Key? key}) : super(key: key);

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final stt.SpeechToText _speechToText = stt.SpeechToText();
  bool _isListening = false;
  String _lastWords = '';

  List<ChatMessage> messages = [];

  final ChatUser currentUser = ChatUser(firstName: 'User', id: "0");
  final ChatUser aiUser = ChatUser(firstName: 'Pico', id: "1");

  late final GenerativeModel _model;
  late final ChatSession _chat;

  bool _showEmojis = true; // Emojis are visible at first
  bool _firstMessageSent = false; // Track if the first message was sent
  bool _voiceEnabled = true; // Variable pour gérer l'état de la voix

  String selectedLocale = "fr_FR";
  String selectedVoiceLanguage = "fr-FR";
  OverlayEntry? _languageOverlayEntry;

  // Ajoutez cette variable pour gérer la synthèse vocale
  final FlutterTts flutterTts = FlutterTts();
  void _showLanguageOverlay(BuildContext context) {
    if (_languageOverlayEntry != null) {
      _languageOverlayEntry!.remove();
      _languageOverlayEntry = null;
      return;
    }

    // Create the overlay entry
    _languageOverlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Transparent background to detect taps
          GestureDetector(
            onTap: () {
              _removeLanguageOverlay();
            },
            behavior: HitTestBehavior.opaque, // Ensures taps are detected
            child: Container(color: Colors.transparent),
          ),

          // Language selection window
          Positioned(
            top: 100, // Adjust position
            right: 10,
            child: Material(
              color: Colors.transparent, // Transparent background
              child: Container(
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    ListTile(
                      onTap: () {
                        _changeLanguage('fr_FR');
                      },
                      title: Row(
                        children: [
                          if (selectedLocale == 'fr_FR')
                            Icon(Icons.check, size: 16),
                          SizedBox(width: 8),
                          Text('Français'),
                        ],
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        _changeLanguage('ar_SA');
                      },
                      title: Row(
                        children: [
                          if (selectedLocale == 'ar_SA')
                            Icon(Icons.check, size: 16),
                          SizedBox(width: 8),
                          Text('العربية'),
                        ],
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        _changeLanguage('en_US');
                      },
                      title: Row(
                        children: [
                          if (selectedLocale == 'en_US')
                            Icon(Icons.check, size: 16),
                          SizedBox(width: 8),
                          Text('English'),
                        ],
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

    // Insert the overlay into the overlay stack
    Overlay.of(context)?.insert(_languageOverlayEntry!);
  }

// Function to remove the overlay
  void _removeLanguageOverlay() {
    _languageOverlayEntry?.remove();
    _languageOverlayEntry = null;
  }

  void _changeLanguage(String locale) {
    setState(() {
      selectedLocale = locale;
    });
    _languageOverlayEntry?.remove();
    _languageOverlayEntry = null;
  }

  @override
  void initState() {
    super.initState();
    _initSpeech();
    _initAIModel();
    _initializeTts(); // Initialiser la synthèse vocale
  }

  void _initSpeech() async {
    await _speechToText.initialize();
    setState(() {});
  }

  void _initAIModel() {
    const apiKey = GEMINI_MODEL_API; //modele le9dim
    // const apiKey = UPGRADED_GEMINI_MODEL_API;
    _model = GenerativeModel(
      model: 'tunedModels/data-adhd-conversation-hrt0r83znwtv', //modele le9dim
      // model: 'tunedModels/adhd-chatbot-30-czqhi70ufn0b',
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        temperature: 1,
        topK: 40,
        topP: 0.95,
        maxOutputTokens: 8192,
        responseMimeType: 'text/plain',
      ),
    );
    _chat = _model.startChat(history: []);
  }

  // methode pour initialiser la synthèse vocale
  // Future<void> _initializeTts() async {
  //   await flutterTts.setLanguage("fr_FR"); // Définir la langue
  //   await flutterTts.setPitch(1.0); // Ajuster la hauteur de la voix
  //   await flutterTts.setSpeechRate(0.5); // Ajuster la vitesse de la parole
  // }
  Future<void> _initializeTts() async {
    // Définir la langue sur la langue sélectionnée
    await flutterTts.setLanguage(selectedVoiceLanguage);

    // Ajuster la hauteur de la voix (1.0 est la hauteur normale)
    await flutterTts.setPitch(1.0);

    // Ajuster la vitesse de la parole (0.5 est plus lent, 1.0 est normal)
    await flutterTts.setSpeechRate(0.5);

    // Ajuster le volume (1.0 est le volume maximal)
    await flutterTts.setVolume(1.0);

    // Obtenir la liste des voix disponibles
    List<dynamic> voices = await flutterTts.getVoices;

    // Trouver une voix féminine dans la langue sélectionnée
    Map<String, String>? selectedVoice;
    for (var voice in voices) {
      if (voice['locale'] == selectedVoiceLanguage &&
          voice['name'].contains('female')) {
        selectedVoice = voice;
        break;
      }
    }

    // Si une voix féminine est trouvée, la définir
    if (selectedVoice != null) {
      await flutterTts.setVoice(selectedVoice);
      print("Voix sélectionnée : ${selectedVoice['name']}");
    } else {
      print(
          "Aucune voix féminine trouvée pour la langue sélectionnée. Utilisation de la voix par défaut.");
    }
  }

  // Méthode pour lire un texte à haute voix
  Future<void> _speak(String text) async {
    await flutterTts.setLanguage(
        selectedVoiceLanguage); // Définir la langue avant de parler
    await flutterTts.speak(text);
  }

  void _startListening() async {
    if (!_isListening) {
      bool available = await _speechToText.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speechToText.listen(
          onResult: (result) {
            setState(() {
              _lastWords = result.recognizedWords;
              if (result.finalResult) {
                _isListening = false;
                if (_lastWords.isNotEmpty) {
                  final userMessage = ChatMessage(
                    user: currentUser,
                    createdAt: DateTime.now(),
                    text: _lastWords.trim(),
                  );
                  _sendMessage(userMessage);
                }
              }
            });
          },
          localeId: selectedLocale, // Utilise la langue sélectionnée
        );
      }
    } else {
      setState(() => _isListening = false);
      _speechToText.stop();
    }
  }

  void _sendMessage(ChatMessage userMessage) {
    setState(() {
      messages.insert(0, userMessage);
      if (!_firstMessageSent) {
        _firstMessageSent = true;
        _showEmojis = false; // Hide emojis after the first message
      }
    });

    final content = Content.text(userMessage.text);

    _chat.sendMessage(content).then((response) {
      final responseText = response.text;
      final aiMessage = ChatMessage(
        user: aiUser,
        createdAt: DateTime.now(),
        text: responseText ?? '',
      );
      setState(() {
        messages.insert(0, aiMessage);
      });

      // Lire la réponse du chatbot à haute voix
      if (_voiceEnabled && responseText != null && responseText.isNotEmpty) {
        _speak(responseText);
      }
    }).catchError((error) {
      print('Erreur lors de l’envoi au modèle AI : $error');
    });
  }

  void _sendPrompt(String prompt) {
    final content = Content.text(prompt);

    _chat.sendMessage(content).then((response) {
      final responseText = response.text;
      final aiMessage = ChatMessage(
        user: aiUser,
        createdAt: DateTime.now(),
        text: responseText ?? '',
      );
      setState(() {
        messages.insert(0, aiMessage);
        if (!_firstMessageSent) {
          _firstMessageSent = true;
          _showEmojis = false; // Hide emojis after first message
        }
      });
    }).catchError((error) {
      print('Erreur lors de l’envoi au modèle AI : $error');
    });
  }

  // méthode qui gére le changement de langue
  void _changeLanguage2(String locale) {
    setState(() {
      selectedLocale = locale;
      // Mettre à jour la langue de la synthèse vocale en fonction de la sélection
      if (locale == "fr_FR") {
        selectedVoiceLanguage = "fr-FR";
      } else if (locale == "ar_SA") {
        selectedVoiceLanguage = "ar-SA";
      } else if (locale == "en-US") {
        selectedVoiceLanguage = "en-US";
      }
      _initializeTts(); // Réinitialiser la synthèse vocale avec la nouvelle langue
    });
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
        child: Container(
          decoration: BoxDecoration(
              //color: Color.fromRGBO(
              //    254, 247, 255, 1), // Using RGBA format with full opacity (1)
              ),
        ), // Empty child to satisfy the requirement //the role of this container is to satisfy the requirement of having a child widget in the AuraBox widget .. what its color is or what it contains is not important // how to change its color : decoration: BoxDecoration(color: Colors.red) // how to add a child to it : child: Text('Hello World!'
      ),
    );
  }

/*
  Widget _buildAuraBackground() {
    return Positioned.fill(
      child: AuraBox(
        spots: [
          AuraSpot(
            color: Color.fromARGB(167, 255, 67, 67),
            radius: 200.0,
            alignment: Alignment.topLeft,
            blurRadius: 50.0,
            stops: const [0.0, 0.6],
          ),
          AuraSpot(
            color: Colors.purple,
            radius: 250.0,
            alignment: Alignment.center,
            blurRadius: 80.0,
            stops: const [0.0, 0.7],
          ),
          AuraSpot(
            color: Colors.blue,
            radius: 200.0,
            alignment: Alignment.bottomRight,
            blurRadius: 50.0,
            stops: const [0.0, 0.5],
          ),
        ],
        decoration: BoxDecoration(
          color: Colors.transparent,
        ),
        child: Container(), // Empty child to satisfy the requirement
      ),
    );
  }
*/

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pico'),

        centerTitle: true,
        leading: IconButton(
          // Nouveau bouton à gauche
          icon: Icon(
            _voiceEnabled ? Icons.volume_up : Icons.volume_off,
            // color: _voiceEnabled ? Colors.black : Colors.black26,
          ),
          onPressed: () {
            setState(() {
              _voiceEnabled = !_voiceEnabled;
            });
          },
        ),

        actions: [
          IconButton(
            icon: Icon(Icons.language),
            onPressed: () {
              _showLanguageOverlay(context); // Show the overlay when clicked
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_horiz),
            onPressed: () {
              setState(() {
                _showEmojis = !_showEmojis;
              });
            },
          ),
        ],
        backgroundColor:
            Color.fromRGBO(255, 255, 255, 1), // Set background color
      ),
      backgroundColor: Color.fromRGBO(0, 0, 0, 0), // Scaffold background color

      body: Stack(
        children: [
          _buildAuraBackground(), // Call external method here

          Column(
            children: [
              if (_showEmojis)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        icon: Image.asset(
                          'assets/images/02_planing.gif',
                          width: 40,
                          height: 40,
                        ),
                        onPressed: () =>
                            _sendPrompt("un plan du jour pour l'enfant"),
                      ),
                      IconButton(
                        icon: Image.asset(
                          'assets/images/03_feeling2.gif',
                          width: 40,
                          height: 40,
                        ),
                        onPressed: () => _sendPrompt(
                            "poser un question sur le sentiment pour l'enfant"),
                      ),
                      IconButton(
                        icon: Image.asset(
                          'assets/images/04_thinking2.gif',
                          width: 40,
                          height: 40,
                        ),
                        onPressed: () => _sendPrompt(
                            "poser une situation de contact humaine pour l'enfant"),
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: DashChat(
                  currentUser: currentUser,
                  messages: messages,
                  onSend: _sendMessage,
                  inputOptions: InputOptions(
                    trailing: [
                      IconButton(
                        onPressed: _startListening,
                        icon: Icon(
                          Icons.mic,
                          color: _isListening
                              ? Color.fromARGB(255, 0, 118, 215)
                              : Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
