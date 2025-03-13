part of 'activity_cubit.dart';

abstract class ActivityState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ActivityInitial extends ActivityState {}

class ActivityLoading extends ActivityState {}

class ActivityLoaded extends ActivityState {
  final UserActivityModel activity;
  final bool isOffline;

  ActivityLoaded(this.activity, {this.isOffline = false});

  @override
  List<Object?> get props => [activity, isOffline];
}

class ActivityError extends ActivityState {
  final String message;

  ActivityError(this.message);

  @override
  List<Object?> get props => [message];
}

class UsersListLoaded extends ActivityState {
  final List<String> users;
  final bool isOffline;

  UsersListLoaded(this.users, {this.isOffline = false});

  @override
  List<Object?> get props => [users, isOffline];
}