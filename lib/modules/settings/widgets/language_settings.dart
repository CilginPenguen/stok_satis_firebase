import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/storage_service.dart';

class LanguageSettings extends StatefulWidget {
  const LanguageSettings({super.key});

  @override
  State<LanguageSettings> createState() => _LanguageSettingsState();
}

class _LanguageSettingsState extends State<LanguageSettings> {
  final StorageService _storage = Get.find<StorageService>();

  // Buraya uygulamada destekleyeceğin dilleri ekle
  final List<Locale> _availableLocales = const [
    Locale('tr', 'TR'),
    Locale('en', 'US'),
    Locale('de', 'DE'),
  ];

  Locale? _selected;

  String _labelOf(Locale l) {
    switch ('${l.languageCode}_${l.countryCode}') {
      case 'tr_TR':
        return 'Türkçe';
      case 'en_US':
        return 'English';
      case 'de_DE':
        return 'Deutsch';
      default:
        return l.languageCode;
    }
  }

  @override
  void initState() {
    super.initState();
    final saved = _storage.getValue<String>(StorageKeys.locale);
    if (saved != null && saved.isNotEmpty) {
      final parts = saved.split('_');
      setState(() => _selected = Locale(parts[0], parts[1]));
    } else {
      // Get.locale döndürebilir; yoksa platform locale kullan
      _selected = Get.locale ?? WidgetsBinding.instance.platformDispatcher.locale;
      // ensure selected is one of available, fallback to first if not
      if (!_availableLocales.any((l) => l.languageCode == _selected!.languageCode)) {
        _selected = _availableLocales.first;
      }
    }
  }

  void _change(Locale newLocale) {
    // anında uygula
    Get.updateLocale(newLocale);
    // storage'a kaydet => "tr_TR"
    _storage.setValue<String>(StorageKeys.locale, '${newLocale.languageCode}_${newLocale.countryCode}');
    setState(() => _selected = newLocale);
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text('language'.tr),
      subtitle: Text(_labelOf(_selected ?? _availableLocales.first)),
      children: _availableLocales.map((locale) {
        return RadioListTile<Locale>(
          title: Text(_labelOf(locale)),
          value: locale,
          groupValue: _selected,
          onChanged: (Locale? v) {
            if (v != null) _change(v);
          },
        );
      }).toList(),
    );
  }
}
