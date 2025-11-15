import 'package:flutter/material.dart';
import 'package:ink_front/shared/widgets/buttons.dart';

enum BottomsheetType {
  success,
  error,
  info,
}

Future<void> showCustomBottomSheet(
  BuildContext context, {
  BottomsheetType type = BottomsheetType.success,
  required String message,
  required VoidCallback onButtonPressed,
  String buttonLabel = "Ok",
  bool isDismissible = true,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    isDismissible: isDismissible,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            // BOTÃO ✅
            SizedBox(
              width: double.infinity,
              height: 48,
              child: CustomButton.primary(
                title: buttonLabel,
                onPressed: onButtonPressed,
              ),
            ),

            const SizedBox(height: 10),
          ],
        ),
      );
    },
  );
}
