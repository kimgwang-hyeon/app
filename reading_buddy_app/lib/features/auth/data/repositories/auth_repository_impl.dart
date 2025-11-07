import 'package:logger/logger.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/login_request.dart';
import '../models/signup_request.dart';
import '../models/token_response.dart';
import '../models/device_code_request.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/storage/token_storage.dart';

/// Auth Repository 구현체
class AuthRepositoryImpl implements AuthRepository {
  final ApiClient _apiClient;
  final TokenStorage _tokenStorage;
  final Logger _logger = Logger();

  AuthRepositoryImpl(this._apiClient, this._tokenStorage);

  @override
  Future<bool> login(String email, String password) async {
    try {
      final request = LoginRequest(email: email, password: password);
      final response = await _apiClient.login(request);

      // ApiResponse 형식으로 변경되어 data 필드에서 토큰 정보 추출
      if (response.isSuccess && response.data != null) {
        // 토큰 저장
        await _tokenStorage.saveAccessToken(response.data!.accessToken);
        await _tokenStorage.saveRefreshToken(response.data!.refreshToken);
        await _tokenStorage.setLoggedIn(true);

        _logger.i('로그인 성공: ${response.message}');
        return true;
      } else {
        _logger.e('로그인 실패: ${response.message}');
        return false;
      }
    } catch (e) {
      _logger.e('로그인 실패: $e');
      return false;
    }
  }

  @override
  Future<bool> signup(String email, String password, String nickname) async {
    try {
      final request = SignupRequest(
        email: email,
        password: password,
        nickname: nickname,
      );
      final response = await _apiClient.signup(request);

      // ApiResponse 형식으로 변경됨
      if (response.isSuccess) {
        _logger.i('회원가입 성공: ${response.message}');
        return true;
      } else {
        _logger.e('회원가입 실패: ${response.message}');
        return false;
      }
    } catch (e) {
      _logger.e('회원가입 실패: $e');
      return false;
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _tokenStorage.clearAll();
      _logger.i('로그아웃 완료');
    } catch (e) {
      _logger.e('로그아웃 실패: $e');
      rethrow;
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    try {
      return _tokenStorage.isLoggedIn();
    } catch (e) {
      _logger.e('로그인 상태 확인 실패: $e');
      return false;
    }
  }

  @override
  Future<String?> authorizeDeviceCode(String deviceAuthCode) async {
    try {
      final request = DeviceCodeRequest(deviceAuthCode: deviceAuthCode);
      final response = await _apiClient.authorizeDevice(request);

      if (response.isSuccess) {
        _logger.i('VR 기기 인증 성공');
        return null; // 성공 시 null 반환
      } else {
        return response.message;
      }
    } catch (e) {
      _logger.e('VR 기기 인증 실패: $e');
      return '기기 인증 중 오류가 발생했습니다.';
    }
  }
}
