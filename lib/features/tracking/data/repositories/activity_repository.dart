import 'dart:io';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_response.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/storage/local_storage.dart';
import '../models/user_activity_model.dart';

class ActivityRepository {
  final DioClient _dioClient;
  final LocalStorage _localStorage;
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  ActivityRepository(this._dioClient, this._localStorage);

  Future<ApiResponse<UserActivityModel>> getUserActivity({
    required String userName,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      String url = '${ApiConstants.getUserActivity}?userName=$userName';

      // Add date filters if provided
      if (startDate != null) {
        url += '&startDate=${_dateFormat.format(startDate)}';
      }

      if (endDate != null) {
        url += '&endDate=${_dateFormat.format(endDate)}';
      }

      final response = await _dioClient.get(url);

      if (response.statusCode == 200) {
        final activity = UserActivityModel.fromJson(response.data);

        // Cache the data locally for offline use
        await _localStorage.saveOfflineData('activity_$userName', response.data);

        return ApiResponse.success(activity);
      } else {
        return ApiResponse.error(response.data['message'] ?? ApiConstants.generalError);
      }
    } on DioException catch (e) {
      // Check if we have cached data for offline use
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.error is SocketException) {

        final cachedData = _localStorage.getOfflineData()?['activity_$userName'];
        if (cachedData != null) {
          final activity = UserActivityModel.fromJson(cachedData);
          return ApiResponse.offline(activity);
        }
      }

      return ApiResponse.error(e.message ?? ApiConstants.connectionError);
    } catch (e) {
      return ApiResponse.error(ApiConstants.generalError);
    }
  }

  // Get list of all users for dropdown
  Future<ApiResponse<List<String>>> getAllUsers() async {
    try {
      final response = await _dioClient.get(ApiConstants.getUsersWithVisits);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final List<String> users = data.map((item) => item['nameUser'] as String).toList();

        // Cache the user list
        await _localStorage.saveOfflineData('all_users', data);

        return ApiResponse.success(users);
      } else {
        return ApiResponse.error(response.data['message'] ?? ApiConstants.generalError);
      }
    } on DioException catch (e) {
      // Check if we have cached data
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.error is SocketException) {

        final cachedData = _localStorage.getOfflineData()?['all_users'];
        if (cachedData != null) {
          final List<dynamic> data = cachedData;
          final List<String> users = data.map((item) => item['nameUser'] as String).toList();
          return ApiResponse.offline(users);
        }
      }

      return ApiResponse.error(e.message ?? ApiConstants.connectionError);
    } catch (e) {
      return ApiResponse.error(ApiConstants.generalError);
    }
  }
}