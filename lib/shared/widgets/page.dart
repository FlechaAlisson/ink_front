import 'package:flutter/material.dart';

class CustomPage extends StatelessWidget {
  final Widget child;
  final String? title;
  final bool showBackButton;
  final bool centerTitle;
  final EdgeInsetsGeometry padding;
  final Color? backgroundColor;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final bool safeArea;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;

  const CustomPage({
    super.key,
    required this.child,
    this.title,
    this.showBackButton = false,
    this.centerTitle = true,
    this.padding = const EdgeInsets.symmetric(horizontal: 32),
    this.backgroundColor,
    this.actions,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.safeArea = true,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.crossAxisAlignment = CrossAxisAlignment.stretch,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: padding,
                    child: child,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
