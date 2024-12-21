import 'package:flutter/material.dart';
import 'keyra_bottom_nav_bar.dart';

class KeyraScaffold extends StatefulWidget {
  final int currentIndex;
  final Function(int) onNavigationChanged;
  final Widget child;

  const KeyraScaffold({
    super.key,
    required this.currentIndex,
    required this.onNavigationChanged,
    required this.child,
  });

  @override
  State<KeyraScaffold> createState() => _KeyraScaffoldState();
}

class _KeyraScaffoldState extends State<KeyraScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: KeyraBottomNavBar(
        currentIndex: widget.currentIndex,
        onTap: widget.onNavigationChanged,
      ),
    );
  }
}
