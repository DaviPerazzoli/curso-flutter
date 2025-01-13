import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lista_de_tarefas/locale_notifier.dart';
import 'package:provider/provider.dart';

class LanguageSetting extends StatefulWidget{
  const LanguageSetting({super.key});

  @override
  State<LanguageSetting> createState() => _LanguageSettingState();
}

class _LanguageSettingState extends State<LanguageSetting> {
  bool isExpanded = false;
  Locale? selectedLocale;

  @override
  Widget build(BuildContext context) {
    LocaleNotifier localeState = context.watch<LocaleNotifier>();
    selectedLocale = localeState.locale;
    void showSetting () {
      setState(() {
        isExpanded = !isExpanded;
      });
    }

    return GestureDetector(
      onTap: showSetting,
      child: Column(
        children: [
          //* Setting title, icon and arrow_down
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.language),
              Expanded(child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(AppLocalizations.of(context)!.language),
              )),
              AnimatedRotation(
                turns: isExpanded? 0.5 : 0,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                child: const Icon(Icons.keyboard_arrow_down),
              ),
              
            ],
          ),

          //* Dropdown language settings
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Row(
              children: [
                Expanded(child: Text(AppLocalizations.of(context)!.selectedLanguage)),
                DropdownButton(
                  value: localeState.locale,
                  hint: DropdownMenuItem(
                    value: null,
                    child: Text(AppLocalizations.of(context)!.deviceLanguage),
                  ),
                  items: AppLocalizations.supportedLocales.map((locale) {
                    return DropdownMenuItem(
                      value: locale,
                      child: Text(locale.toString()),
                    );
                  }).toList(), 
                  onChanged: (value) {
                    setState(() {
                      selectedLocale = value;
                    });
                    localeState.changeLocale(value);
                  },
                )
              ],
            ), 
            crossFadeState: isExpanded? CrossFadeState.showSecond : CrossFadeState.showFirst, 
            duration: const Duration(milliseconds: 200),
            firstCurve: Curves.easeIn,
            secondCurve: Curves.easeIn,
          )
        ],
      )
    );
  }
}