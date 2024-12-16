import 'package:flutter/material.dart';
import 'keyra_bottom_nav_bar.dart';

class KeyraScaffold extends StatefulWidget {
  final Widget child;
  final int currentIndex;
  final ValueChanged<int> onNavigationChanged;

  const KeyraScaffold({
    super.key,
    required this.child,
    required this.currentIndex,
    required this.onNavigationChanged,
  });

  @override
  State<KeyraScaffold> createState() => _KeyraScaffoldState();
}

class _KeyraScaffoldState extends State<KeyraScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: widget.child,
      ),
      bottomNavigationBar: KeyraBottomNavBar(
        currentIndex: widget.currentIndex,
        onTap: widget.onNavigationChanged,
      ),
    );
  }
}
