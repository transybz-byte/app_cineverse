import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../views/movie_detail_view.dart'; // Nhớ import màn hình chi tiết

class MovieCard extends StatelessWidget {
  final Movie movie;

  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    // Dùng InkWell hoặc GestureDetector để bắt sự kiện bấm
    return GestureDetector(
      onTap: () {
        // Chuyển sang màn hình chi tiết
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieDetailView(movie: movie),
          ),
        );
      },
      child: Card(
        elevation: 4,
        clipBehavior: Clip.antiAlias, // Cắt ảnh cho bo tròn theo thẻ
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Phần ảnh (chiếm phần lớn không gian)
            Expanded(
              child: Image.network(
                movie.posterUrl,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Center(child: Icon(Icons.error)),
              ),
            ),
            // Phần tên phim
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                movie.title,
                maxLines: 2, // Tối đa 2 dòng
                overflow: TextOverflow.ellipsis, // Dài quá thì hiện dấu ...
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}