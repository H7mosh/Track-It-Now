class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? error;
  final bool isOffline;

  ApiResponse({
    required this.success,
    this.data,
    this.error,
    this.isOffline = false,
  });

  factory ApiResponse.success(T data) {
    return ApiResponse(
      success: true,
      data: data,
      error: null,
    );
  }

  factory ApiResponse.error(String error) {
    return ApiResponse(
      success: false,
      data: null,
      error: error,
    );
  }

  factory ApiResponse.offline(T data) {
    return ApiResponse(
      success: true,
      data: data,
      error: null,
      isOffline: true,
    );
  }
}