import 'package:flutter/material.dart';
import 'package:ink_front/shared/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback? onPressed;
  final double height;
  final double borderRadius;
  final bool isLoading;
  final Widget? icon;
  final bool enabled;

  const CustomButton({
    super.key,
    required this.title,
    required this.backgroundColor,
    this.textColor = AppColors.white,
    this.onPressed,
    this.height = 50,
    this.borderRadius = 8.0,
    this.isLoading = false,
    this.icon,
    this.enabled = true,
  });

  // Construtor para botão primary
  const CustomButton.primary({
    super.key,
    required this.title,
    this.onPressed,
    this.height = 50,
    this.borderRadius = 8.0,
    this.isLoading = false,
    this.icon,
    this.enabled = true,
  })  : backgroundColor = AppColors.primary,
        textColor = AppColors.white;

  // Construtor para botão secondary
  const CustomButton.secondary({
    super.key,
    required this.title,
    this.onPressed,
    this.height = 50,
    this.borderRadius = 8.0,
    this.isLoading = false,
    this.icon,
    this.enabled = true,
  })  : backgroundColor = AppColors.secondary,
        textColor = AppColors.white;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: height,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    enabled ? backgroundColor : AppColors.textDisabled,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                elevation: 2,
              ),
              onPressed: enabled && !isLoading ? onPressed : null,
              child: isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(textColor),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (icon != null) ...[icon!, const SizedBox(width: 8)],
                        Text(
                          title,
                          style: TextStyle(
                            color: enabled ? textColor : AppColors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
