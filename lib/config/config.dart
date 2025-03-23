class AppConfig {
  static const String backendBaseUrl = "http://192.168.56.1";
  static const int backendPort = 8000;
  static String backendUrl() => "$backendBaseUrl:$backendPort";
}
