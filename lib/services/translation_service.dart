import 'package:translator/translator.dart';
import 'package:flutter/foundation.dart';

class TranslationService extends ChangeNotifier {
  final translator = GoogleTranslator();
  String currentLanguage = 'en'; // Default language
  final Map<String, String> _translationCache = {}; // Cache for translations

  // Translate text to the selected language
  Future<String> translate(String text) async {
    if (currentLanguage == 'en') return text; // Skip translation if language is English

    String cacheKey = '$currentLanguage:$text';
    if (_translationCache.containsKey(cacheKey)) {
      return _translationCache[cacheKey]!; // Return cached translation
    }

    try {
      var translation = await translator.translate(text, to: currentLanguage);
      _translationCache[cacheKey] = translation.text; // Cache the translation
      return translation.text;
    } catch (e) {
      return text; // Return original text on error
    }
  }

  // Change language and notify listeners
  void changeLanguage(String languageCode) {
    if (currentLanguage != languageCode) {
      currentLanguage = languageCode;
      _translationCache.clear(); // Clear cache for the new language
      notifyListeners(); // Notify listeners of the language change
    }
  }

  // Retrieve translation for a given text
  Future<String> getTranslation(String text) async {
    return await translate(text);
  }
}
