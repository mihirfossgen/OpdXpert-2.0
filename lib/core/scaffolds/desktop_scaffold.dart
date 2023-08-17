import 'package:flutter/material.dart';

import '../../presentation/dashboard_screen/shared_components/selection_button.dart';
import '../../presentation/dashboard_screen/views/screens/dashboard_screen.dart';

class DesktopScaffold extends StatelessWidget {
  const DesktopScaffold(
      {Key? key,
      required this.child,
      this.backgroundColor,
      this.width,
      this.isAppBarVisible,
      this.isDrawerVisible,
      this.isNoAppBarNoDrawer,
      this.noSafeAreaMargin,
      this.height})
      : super(key: key);

  final bool? isAppBarVisible;
  final bool? isDrawerVisible;
  final bool? isNoAppBarNoDrawer;
  final bool? noSafeAreaMargin;

  final Color? backgroundColor;

  final double? width;
  final double? height;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    double cwidth = MediaQuery.of(context).size.width;
    double cheight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor:
          backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      appBar: isNoAppBarNoDrawer != null
          ? null
          : (isAppBarVisible != null ? null : AppBar()),
      drawer: isNoAppBarNoDrawer != null
          ? null
          : (isDrawerVisible != null
              ? null
              : MainMenu(
                  onSelected: (int index, SelectionButtonData value) {},
                )),
      body: SafeArea(
        minimum: noSafeAreaMargin != null
            ? EdgeInsets.zero
            : const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Center(
          child: SizedBox(
              height: height ?? cheight, width: width ?? cwidth, child: child),
        ),
      ),
    );
  }
}
