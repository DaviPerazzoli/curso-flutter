import 'package:flutter/material.dart';
import 'package:lista_de_tarefas/view/components/page.dart';
import 'package:lista_de_tarefas/view/components/settings/setting.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'settings/language_setting.dart';


class SettingsPage extends StatelessWidget implements MyPage{
  const SettingsPage({super.key, required this.label, this.onLoad});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.symmetric(horizontal: BorderSide(color:Theme.of(context).shadowColor, width:0.2)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Setting(
              iconData: Icons.language,
              label: AppLocalizations.of(context)!.language, 
              child: const LanguageSettingDropdown(),
            ),
          ),
        )
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