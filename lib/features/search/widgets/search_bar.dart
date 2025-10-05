// A dedicated widget for the search bar UI.
// It is stateless and communicates user actions via callbacks.
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({super.key, 
    required this.controller,
    required this.focusNode,
    required this.onSubmitted,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onSubmitted;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16, left: 4),
      child: Row(
        children: [
          // Using a more standard back button for iOS look and feel.
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 20),
            onPressed: () => context.router.pop(),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              onSubmitted: onSubmitted,
              decoration: const InputDecoration(
                hintText: 'Search for tracks or artists...',
                // Removing the border makes it look cleaner within this layout.
                border: InputBorder.none,
              ),
              // Use a specific text style for consistency.
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          // Add a clear button to improve usability.
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              controller.clear();
              // Optionally, you could also clear the search results here
              // by adding an event to the BLoC.
            },
          ),
        ],
      ),
    );
  }
}