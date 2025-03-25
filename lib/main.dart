import 'package:adhd_helper/src/screens/chatbot/chat_bubble.dart';
import 'package:adhd_helper/src/screens/home_screen.dart';
import 'package:adhd_helper/src/screens/kids_mode_screens/kids_home_screen.dart';
import 'package:adhd_helper/src/screens/login_screen.dart';
import 'package:adhd_helper/src/services/ChatProvider/chatProvider.dart';
import 'package:adhd_helper/src/services/auth_service.dart';
import 'package:adhd_helper/utils/kids_mode_activation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'l10n/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    ChangeNotifierProvider(
      create: (context) => ChatBubbleProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  static void setLocale(BuildContext context, Locale newLocale) async {
    final state = context.findAncestorStateOfType<_MyAppState>();
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('languageCode', newLocale.languageCode);
    state?.setState(() => state._locale =
        newLocale); //explain what is meaning of the locale : it is the language of the app
  }

  static Future<Locale> getLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('languageCode') ?? 'en';
    return Locale(languageCode);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseAuthService authService = FirebaseAuthService();
  OverlayEntry? _chatBubbleOverlay;
  bool _isOverlayVisible = false;
  Locale _locale = const Locale('en');

  @override
  void initState() {
    super.initState();
    _initializeLocale();
  }

  Future<void> _initializeLocale() async {
    _locale = await MyApp.getLocale();
    if (mounted) setState(() {});
  }

  void _manageOverlay(BuildContext context) {
    final chatBubbleProvider =
        Provider.of<ChatBubbleProvider>(context, listen: false);

    if (chatBubbleProvider.showBubble && !_isOverlayVisible) {
      _showOverlay(context);
    } else if (!chatBubbleProvider.showBubble && _isOverlayVisible) {
      _removeOverlay();
    }
  }

  void _showOverlay(BuildContext context) {
    if (_isOverlayVisible) return;

    final overlayState = Overlay.of(context);
    if (overlayState == null) return;

    _chatBubbleOverlay = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 20,
        right: 20,
        child: ChatBubble(),
      ),
    );

    overlayState.insert(_chatBubbleOverlay!);
    _isOverlayVisible = true;
  }

  void _removeOverlay() {
    if (!_isOverlayVisible) return;

    _chatBubbleOverlay?.remove();
    _chatBubbleOverlay = null;
    _isOverlayVisible = false;
  }

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      debugShowCheckedModeBanner: false,
      supportedLocales: L10n.all,
      locale: _locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: Builder(
        builder: (context) {
          // Manage overlay when widget builds
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _manageOverlay(context);
          });
          return const HomeScreen();
        },
      ),
    );
  }
}

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final FirebaseAuthService authService = FirebaseAuthService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: authService.authState(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasData) {
          return FutureBuilder<bool>(
            future: loadSavedValue(),
            builder: (context, asyncSnapshot) {
              if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                    body: Center(child: CircularProgressIndicator()));
              }
              return asyncSnapshot.data == true
                  ? const KidsHomeScreen()
                  : const HomeScreen();
            },
          );
        }
        return const LoginScreen();
      },
    );
  }
}
