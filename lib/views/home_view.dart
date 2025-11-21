import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/movie_service.dart';
import '../widgets/movie_card.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  // Biến chứa danh sách phim (Dùng Future để chờ dữ liệu từ mạng)
  late Future<List<Movie>> futureMovies;
  
  // Biến quản lý ô nhập liệu
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Khi mở app, tải tất cả phim
    futureMovies = MovieService().getMovies();
  }

  // Hàm xử lý tìm kiếm
  void _runSearch(String keyword) {
    setState(() {
      if (keyword.isEmpty) {
        // Nếu xóa hết chữ -> Tải lại toàn bộ phim
        futureMovies = MovieService().getMovies();
      } else {
        // Nếu có chữ -> Gọi API tìm kiếm
        futureMovies = MovieService().searchMovies(keyword);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cineverse', 
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
        ),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      
      body: Column(
        children: [
          // --- PHẦN 1: Ô TÌM KIẾM ---
          Padding(
            padding: const EdgeInsets.all(16.0), // Khoảng cách lề
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Nhập tên phim để tìm...',
                prefixIcon: const Icon(Icons.search), // Icon kính lúp
                
                // Nút X để xóa nhanh
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear(); // Xóa chữ trong ô
                          _runSearch(''); // Load lại danh sách gốc
                          FocusScope.of(context).unfocus(); // Ẩn bàn phím
                        },
                      )
                    : null,
                    
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12), // Bo tròn góc
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              ),
              // Gọi hàm tìm kiếm mỗi khi gõ chữ
              onChanged: (value) => _runSearch(value), 
            ),
          ),

          // --- PHẦN 2: DANH SÁCH PHIM ---
          Expanded(
            child: FutureBuilder<List<Movie>>(
              future: futureMovies,
              builder: (context, snapshot) {
                // 1. Đang tải
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } 
                
                // 2. Có lỗi xảy ra
                else if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red, size: 40),
                        const SizedBox(height: 10),
                        Text("Lỗi: ${snapshot.error}", textAlign: TextAlign.center),
                      ],
                    ),
                  );
                } 
                
                // 3. Không tìm thấy phim nào
                else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.movie_filter, size: 50, color: Colors.grey),
                        SizedBox(height: 10),
                        Text("Không tìm thấy phim nào!", style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  );
                }

                // 4. Tải thành công -> Hiển thị lưới
                return GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 2 cột
                    childAspectRatio: 0.6, // Tỷ lệ chiều cao thẻ (0.6 giúp thẻ dài hơn, tránh lỗi overflow)
                    crossAxisSpacing: 10, // Khoảng cách ngang
                    mainAxisSpacing: 10, // Khoảng cách dọc
                  ),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return MovieCard(movie: snapshot.data![index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}