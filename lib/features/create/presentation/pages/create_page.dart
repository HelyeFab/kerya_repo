import 'package:flutter/material.dart';
import 'package:Keyra/core/widgets/menu_button.dart';

class CreatePage extends StatelessWidget {
  const CreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        automaticallyImplyLeading: false,
        actions: const [
          MenuButton(),
          SizedBox(width: 16),
        ],
      ),
      body: const Center(
        child: Text('Create Page - Coming Soon!'),
      ),
    );
  }

  // Assuming _buildLanguageSelector is defined elsewhere in the code
  // If not, you would need to define it here or import it from another file
  // Widget _buildLanguageSelector() {
  //   // implementation
  // }
}
