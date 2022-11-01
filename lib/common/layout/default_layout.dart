import 'package:flutter/material.dart';

class DefaultLayout extends StatelessWidget {
  final Widget child;
  final String? title;
  final Color? backgroundColor;
  final Widget? bottomNavigationBar;

  const DefaultLayout({
    Key? key,
    required this.child,
    this.backgroundColor,
    this.title,
    this.bottomNavigationBar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: renderAppBar(),
      backgroundColor: backgroundColor ?? Colors.white,
      body: child,
      bottomNavigationBar: bottomNavigationBar,
    );
  }

  AppBar? renderAppBar() {
    if (title == null) {
      return null;
    }
    return AppBar(
      title: Text(
        title!,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
    );
  }
}
