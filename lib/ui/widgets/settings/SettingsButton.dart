import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivarium_control_unit/utils/deviceProvider/deviceProvider.dart';

class SettingsButton extends StatelessWidget {
  final String title;
  final Icon icon;
  final String providerKey;
  final bool value;
  final VoidCallback? onChanged;

  const SettingsButton(
      {Key? key,
      required this.title,
      required this.icon,
      required this.providerKey,
      this.onChanged,
      required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Center(
        child: Consumer<DeviceProvider>(
          builder: (context, provider, child) => ElevatedButton.icon(
              icon: icon,
              label: Text(title),
              onPressed: () async {
                if (await confirm(context,
                    title: Text('Auto Tune Start'),
                    content: Text(
                        'Are you sure you want to start auto tune process?'),
                    textOK: Text('Tune'),
                    textCancel: Text('Cancel'))) {
                  if (onChanged != null) onChanged!();
                  await provider.saveValue(key: providerKey, value: value);
                }
              }),
        ),
      ),
    );
  }
}
