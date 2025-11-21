import 'package:flutter/material.dart';
import '../models/movie.dart';

class MovieDetailView extends StatelessWidget {
  final Movie movie;

  // Màn hình này bắt buộc phải nhận vào một đối tượng Movie
  const MovieDetailView({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title), // Tiêu đề là tên phim
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white, // Màu chữ nút Back
      ),
      body: SingleChildScrollView( // Để cuộn được nếu nội dung dài
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Ảnh bìa phim (Full chiều ngang)
            Image.network(
              movie.posterUrl,
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => 
                  const Icon(Icons.broken_image, size: 100),
            ),
            
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 2. Tên phim (To, đậm)
                  Text(
                    movie.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // 3. Tiêu đề "Nội dung"
                  const Text(
                    "Nội dung phim:",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // 4. Phần mô tả chi tiết
                  Text(
                    movie.description, // Lấy mô tả từ CSDL hiển thị ra đây
                    style: const TextStyle(fontSize: 16, height: 1.5),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}