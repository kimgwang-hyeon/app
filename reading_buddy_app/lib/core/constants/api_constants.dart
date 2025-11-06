/// API 관련 상수 정의
class ApiConstants {
  // Base URL - 실제 서버 주소로 변경 필요
  static const String baseUrl = 'http://your-server-url.com';

  // Timeout
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Auth Endpoints
  static const String login = '/api/user/login';
  static const String signup = '/api/user/signup';
  static const String reissueToken = '/api/user/reissue-token';
  static const String activation = '/api/user/activation';
  static const String authDevice = '/api/user/auth-device';
  static const String polling = '/api/user/polling';

  // Dashboard Endpoints
  static const String stageInfo = '/api/dashboard/stage/info';
  static const String stageTryAvg = '/api/dashboard/stage/try-avg';
  static const String stageCorrectRate = '/api/dashboard/stage/correct-rate';
  static const String attendance = '/api/dashboard/attendance';
  static const String mistakePhonemesRank = '/api/dashboard/mistake/phonemes/rank';
  static const String tryPhonemesRank = '/api/dashboard/try/phonemes/rank';

  // Headers
  static const String contentType = 'application/json';
  static const String authorization = 'Authorization';
  static const String bearer = 'Bearer';
}
