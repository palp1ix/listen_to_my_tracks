part of 'search_bloc.dart';

sealed class SearchState extends Equatable {
  const SearchState();
  
  @override
  List<Object> get props => [];
}

final class SearchInitial extends SearchState {
  const SearchInitial({this.history = const []});

  final List<String> history;

  @override
  List<Object> get props => [history];
}


final class SearchLoading extends SearchState {
  final String query;
  const SearchLoading(this.query);
  @override
  List<Object> get props => [query];
}

// Search failure state
final class SearchFailure extends SearchState {
  const SearchFailure(this.message);
  
  final String message;
  
  @override
  List<Object> get props => [message];
}

// Search success state with results
final class SearchSuccess extends SearchState {
  const SearchSuccess(this.results);

  final List<TrackEntity> results;
  
  @override
  List<Object> get props => [results];
}

