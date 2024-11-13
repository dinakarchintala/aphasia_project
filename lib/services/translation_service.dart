import 'package:translator/translator.dart';
import 'package:flutter/foundation.dart';

class TranslationService extends ChangeNotifier {
  final translator = GoogleTranslator();
  String currentLanguage = 'en'; // Default language

  // Translate text to the selected language
  Future<String> translate(String text) async {
    if (currentLanguage == 'en') return text; // Skip if language is English
    var translation = await translator.translate(text, to: currentLanguage);
    return translation.text;
  }

  // Change language and notify listeners
  void changeLanguage(String languageCode) {
    if (currentLanguage != languageCode) {
      currentLanguage = languageCode;
      notifyListeners(); // Notify listeners when language changes
    }
  }
}
