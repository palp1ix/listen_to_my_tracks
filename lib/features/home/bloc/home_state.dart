part of 'home_bloc.dart';

sealed class HomeState extends Equatable {
  const HomeState();
  
  @override
  List<Object> get props => [];
}

final class HomeInitial extends HomeState {}

final class HomeDataLoading extends HomeState {}

final class HomeDataLoaded extends HomeState {
  const HomeDataLoaded(this.chart);
  final List<TrackEntity> chart;

  @override
  List<Object> get props => [chart];
}

final class HomeDataError extends HomeState {
  const HomeDataError(this.message);
  final String message;

  @override
  List<Object> get props => [message];
}
