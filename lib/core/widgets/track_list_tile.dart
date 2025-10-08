import 'package:flutter/material.dart';

class TrackListTile extends StatelessWidget {
  const TrackListTile({
    super.key,
    required this.imageUrl,
    required this.trackTitle,
    required this.artist,
    required this.onTap,
  });

  final String imageUrl;
  final String trackTitle;
  final String artist;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: FadeInImage.assetNetwork(
          placeholder: 'assets/images/image-placeholder.png',
          image: imageUrl,
          width: 56,
          height: 56,
          fit: BoxFit.cover,
        ),
      ),
      title: Text(trackTitle, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(artist),
    );
  }
}
