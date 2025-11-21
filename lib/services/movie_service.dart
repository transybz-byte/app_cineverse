import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

class MovieService {
  // Link API (Nhớ đổi IP nếu chạy máy thật)
  static const String baseUrl = 'http://10.0.2.2/cineverse_api'; 

  // 1. Lấy danh sách phim
  Future<List<Movie>> getMovies() async {
    final url = Uri.parse('$baseUrl/get_movies.php'); // Chỗ này Dart tự hiểu được vì cùng scope static (hoặc do cách viết ngắn gọn)
    // Nhưng để chắc ăn nhất, hãy dùng MovieService.baseUrl cho mọi chỗ
    
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        return body.map((item) => Movie.fromJson(item)).toList();
      } else {
        throw Exception('Lỗi server: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Không kết nối được: $e');
    }
  }

  // 2. Tìm kiếm phim (Đã sửa lỗi undefined name)
  Future<List<Movie>> searchMovies(String keyword) async {
    // SỬA LỖI Ở ĐÂY: Thêm MovieService. vào trước baseUrl
    final url = Uri.parse('${MovieService.baseUrl}/search_movies.php?keyword=$keyword');
    
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        return body.map((item) => Movie.fromJson(item)).toList();
      } else {
        throw Exception('Lỗi tìm kiếm');
      }
    } catch (e) {
      throw Exception('Lỗi kết nối: $e');
    }
  }
}