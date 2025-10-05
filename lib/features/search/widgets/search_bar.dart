// A dedicated widget for the search bar UI.
// It is stateless and communicates user actions via callbacks.
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listen_to_my_tracks/features/search/bloc/search_bloc.dart';

class CustomSearchBar extends StatefulWidget {
  const CustomSearchBar({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onSubmitted,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onSubmitted;

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  late final SearchBloc _searchBloc;

  @override
  void initState() {
    _searchBloc = context.read<SearchBloc>();
    super.initState();
  }

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
              controller: widget.controller,
              focusNode: widget.focusNode,
              onSubmitted: widget.onSubmitted,
              decoration: const InputDecoration(
                hintText: 'Search for tracks or artists...',
              ),
              // Use a specific text style for consistency.
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          // Add a clear button to improve usability.
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              widget.controller.clear();
              _searchBloc.add(const SearchCleared());
            },
          ),
        ],
      ),
    );
  }
}
