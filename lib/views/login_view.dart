import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'home_view.dart'; // Để chuyển trang khi đăng nhập thành công

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  // Biến quản lý ô nhập liệu
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _fullnameController = TextEditingController(); // Chỉ dùng khi đăng ký

  bool isLoginMode = true; // true: Đang ở màn Đăng nhập, false: Đang ở màn Đăng ký
  bool isLoading = false;  // Để hiện vòng xoay khi đang chờ mạng

  // Hàm xử lý nút bấm
  void _handleAuth() async {
    String user = _usernameController.text;
    String pass = _passwordController.text;
    String name = _fullnameController.text;

    if (user.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng nhập đầy đủ thông tin!")),
      );
      return;
    }

    setState(() => isLoading = true); // Hiện vòng xoay
    final auth = AuthService();

    if (isLoginMode) {
      // --- XỬ LÝ ĐĂNG NHẬP ---
      bool success = await auth.login(user, pass);
      if (success) {
        // Chuyển sang màn hình chính
        if (mounted) {
          Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const HomeView()),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Sai tài khoản hoặc mật khẩu!")),
          );
        }
      }
    } else {
      // --- XỬ LÝ ĐĂNG KÝ ---
      String message = await auth.register(user, pass, name);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
        if (message.contains("thành công")) {
          setState(() => isLoginMode = true); // Đăng ký xong thì chuyển về Đăng nhập
        }
      }
    }

    setState(() => isLoading = false); // Ẩn vòng xoay
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo hoặc Icon
                  const Icon(Icons.movie, size: 80, color: Colors.deepPurple),
                  const SizedBox(height: 10),
                  Text(
                    isLoginMode ? "CINEVERSE LOGIN" : "ĐĂNG KÝ TÀI KHOẢN",
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                  ),
                  const SizedBox(height: 20),

                  // Ô nhập Username
                  TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(labelText: "Tài khoản", border: OutlineInputBorder(), prefixIcon: Icon(Icons.person)),
                  ),
                  const SizedBox(height: 12),

                  // Ô nhập Password
                  TextField(
                    controller: _passwordController,
                    obscureText: true, // Ẩn mật khẩu
                    decoration: const InputDecoration(labelText: "Mật khẩu", border: OutlineInputBorder(), prefixIcon: Icon(Icons.lock)),
                  ),
                  const SizedBox(height: 12),

                  // Ô nhập Họ tên (Chỉ hiện khi Đăng ký)
                  if (!isLoginMode)
                    TextField(
                      controller: _fullnameController,
                      decoration: const InputDecoration(labelText: "Họ và tên", border: OutlineInputBorder(), prefixIcon: Icon(Icons.badge)),
                    ),
                  
                  const SizedBox(height: 20),

                  // Nút Bấm (Đăng nhập / Đăng ký)
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple, foregroundColor: Colors.white),
                      onPressed: isLoading ? null : _handleAuth,
                      child: isLoading 
                          ? const CircularProgressIndicator(color: Colors.white) 
                          : Text(isLoginMode ? "ĐĂNG NHẬP" : "ĐĂNG KÝ"),
                    ),
                  ),

                  // Nút chuyển đổi chế độ
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isLoginMode = !isLoginMode; // Đảo ngược trạng thái
                        _usernameController.clear();
                        _passwordController.clear();
                        _fullnameController.clear();
                      });
                    },
                    child: Text(isLoginMode 
                        ? "Chưa có tài khoản? Đăng ký ngay" 
                        : "Đã có tài khoản? Đăng nhập"),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}