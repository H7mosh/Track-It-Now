import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/user_activity_model.dart';
import '../../data/repositories/activity_repository.dart';

part 'activity_state.dart';

class ActivityCubit extends Cubit<ActivityState> {
  final ActivityRepository _activityRepository;

  ActivityCubit(this._activityRepository) : super(ActivityInitial());

  // Get user activity data
  Future<void> getUserActivity({
    required String userName,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    emit(ActivityLoading());

    final response = await _activityRepository.getUserActivity(
      userName: userName,
      startDate: startDate,
      endDate: endDate,
    );

    if (response.success && response.data != null) {
      emit(ActivityLoaded(response.data!, isOffline: response.isOffline));
    } else {
      emit(ActivityError(response.error ?? 'ناتوانێت داتا بهێنێت'));
    }
  }

  // Get all users with activity
  Future<void> getAllUsers() async {
    emit(ActivityLoading());

    final response = await _activityRepository.getAllUsers();

    if (response.success && response.data != null) {
      emit(UsersListLoaded(response.data!, isOffline: response.isOffline));
    } else {
      emit(ActivityError(response.error ?? 'ناتوانێت لیستی بەکارهێنەران بهێنێت'));
    }
  }
}