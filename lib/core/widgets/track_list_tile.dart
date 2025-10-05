import 'package:flutter/material.dart';

class TrackListTile extends StatelessWidget {
  const TrackListTile({
    super.key,
    required this.imageUrl,
    required this.trackTitle,
    required this.artist,
  });

  final String imageUrl;
  final String trackTitle;
  final String artist;

  @override
  Widget build(BuildContext context) {
    return ListTile(
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
