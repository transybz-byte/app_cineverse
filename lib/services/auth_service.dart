import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  // Đổi IP nếu chạy máy thật (giống bên MovieService)
  static const String baseUrl = 'http://10.0.2.2/cineverse_api'; 

  // 1. Hàm Đăng nhập
  Future<bool> login(String username, String password) async {
    final url = Uri.parse('$baseUrl/login.php');
    
    try {
      final response = await http.post(
        url, 
        body: {
          'username': username,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          return true; // Đăng nhập thành công
        }
      }
    } catch (e) {
      print("Lỗi: $e");
    }
    return false; // Thất bại
  }

  // 2. Hàm Đăng ký
  Future<String> register(String username, String password, String fullName) async {
    final url = Uri.parse('$baseUrl/register.php');
    
    try {
      final response = await http.post(
        url, 
        body: {
          'username': username,
          'password': password,
          'full_name': fullName,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['message']; // Trả về thông báo từ PHP (Thành công/Thất bại)
      }
    } catch (e) {
      return "Lỗi kết nối: $e";
    }
    return "Lỗi không xác định";
  }
}