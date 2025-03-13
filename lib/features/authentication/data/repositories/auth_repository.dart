import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_response.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/storage/local_storage.dart';
import '../../../../shared/models/api_response.dart';
import '../models/user_model.dart';

class AuthRepository {
  final DioClient _dioClient;
  final LocalStorage _localStorage;

  AuthRepository(this._dioClient, this._localStorage);

  // Sign in method
  Future<ApiResponse<UserModel>> signIn(String nameUser, String password) async {
    try {
      final signInDto = SignInDto(
        nameUser: nameUser,
        password: password,
      );

      final response = await _dioClient.post(
        ApiConstants.signIn,
        data: signInDto.toJson(),
      );

      // Parse response
      if (response.statusCode == 200) {
        final userData = UserModel.fromJson(response.data);

        // Save user data
        await _localStorage.saveUser(userData);

        return ApiResponse.success(userData);
      } else {
        return ApiResponse.error('ناوی بەکارهێنەر یان وشەی نهێنی هەڵەیە');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return ApiResponse.error(ApiConstants.connectionError);
      } else if (e.response?.statusCode == 401) {
        return ApiResponse.error(ApiConstants.authError);
      } else {
        return ApiResponse.error(e.message ?? ApiConstants.generalError);
      }
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  // Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final user = await _localStorage.getUser();
    return user != null;
  }

  // Get current user
  Future<UserModel?> getCurrentUser() async {
    return await _localStorage.getUser();
  }

  // Sign out method
  Future<void> signOut() async {
    await _localStorage.removeUser();
  }

  // Search users
  Future<ApiResponse<List<UserModel>>> searchUsers(String term) async {
    try {
      final response = await _dioClient.get(
        ApiConstants.searchUsers,
        queryParameters: {'term': term},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final users = data.map((json) => UserModel.fromJson(json)).toList();
        return ApiResponse.success(users);
      } else {
        return ApiResponse.error('فشل في البحث عن المستخدمين');
      }
    } on DioException catch (e) {
      return ApiResponse.error(e.message ?? ApiConstants.generalError);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }
}