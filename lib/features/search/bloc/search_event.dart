part of 'search_bloc.dart';

sealed class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

final class HistoryRequested extends SearchEvent {
  const HistoryRequested();
}

final class SearchRequested extends SearchEvent {
  const SearchRequested(this.query);

  final String query;

  @override
  List<Object> get props => [query];
}

final class SearchCleared extends SearchEvent {
  const SearchCleared();
}
