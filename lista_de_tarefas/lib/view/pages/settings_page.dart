import 'package:flutter/material.dart';
import 'package:lista_de_tarefas/view/components/settings/theme_setting.dart';
import 'package:lista_de_tarefas/view/pages/page.dart';
import 'package:lista_de_tarefas/view/components/settings/setting.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../components/settings/language_setting.dart';


class SettingsPage extends StatelessWidget implements MyPage{
  const SettingsPage({super.key, required this.label, this.onLoad});
  

  @override
  Widget build(BuildContext context) {
    AppLocalizations localization = AppLocalizations.of(context)!;

    return Column(
      children: [
        Setting(
          iconData: Icons.language,
          label: localization.language, 
          child: const LanguageSettingDropdown(),
        ),
        Setting(
          iconData: Icons.brightness_4_outlined,
          label: localization.theme,
          child: const ThemeSettingDropdown(),
        ),
      ],
    );
  }
  
  @override
  Icon get icon => const Icon(Icons.settings);
  
  @override
  final String label;
  
  @override
  final Function? onLoad;
}