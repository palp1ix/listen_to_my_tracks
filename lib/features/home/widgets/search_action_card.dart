// A non-functional search card to serve as a UI entry point for search.
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:listen_to_my_tracks/app/router/router.gr.dart';

class SearchActionCard extends StatelessWidget {
  const SearchActionCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hintColor = theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.6);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: InkWell(
        // InkWell provides visual feedback on tap.
        onTap: () {
          context.router.push(SearchResultsRoute());
        },
        borderRadius: BorderRadius.circular(16.0),
        child: Ink(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(Icons.search, color: hintColor),
              const SizedBox(width: 12.0),
              Text(
                'Search for tracks or artists...',
                style: TextStyle(color: hintColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}