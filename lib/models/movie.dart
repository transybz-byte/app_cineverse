class Movie {
  final String id;
  final String title; // Tên phim
  final String posterUrl; // Link ảnh bìa
  final String description; // Mô tả

  Movie({
    required this.id,
    required this.title,
    required this.posterUrl,
    required this.description,
  });

  // Hàm này dùng để chuyển dữ liệu từ API (JSON) thành object Movie (dùng cho Tuần 3)
  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'].toString(),
      title: json['title'],
      posterUrl: json['poster_url'] ?? 'https://via.placeholder.com/150', // Ảnh mặc định nếu lỗi
      description: json['description'] ?? '',
    );
  }
}