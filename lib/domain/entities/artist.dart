import 'package:equatable/equatable.dart';

// Represents an artist in the domain layer.
// This is a clean, framework-agnostic model that contains only the data
// required for the app's features, shielding the business logic from the
// complexities of the data source (API).
class ArtistEntity extends Equatable {
  const ArtistEntity({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  final int id;
  final String name;
  final String imageUrl;

  @override
  List<Object?> get props => [id, name, imageUrl];
}
