// utils/language_helper.dart

enum AppLanguage { english, spanish }

class LanguageHelper {
  static Map<AppLanguage, String> get languageNames {
    return {
      AppLanguage.english: 'English',
      AppLanguage.spanish: 'Español',
    };
  }

  static String getLanguageCode(AppLanguage language) {
    switch (language) {
      case AppLanguage.english:
        return 'en';
      case AppLanguage.spanish:
        return 'es';
      default:
        return 'en';
    }
  }
}
