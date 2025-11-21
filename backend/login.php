<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
include 'db_connect.php';

$username = $_POST['username'];
$password = $_POST['password'];

// Kiểm tra xem có dòng nào khớp cả Username lẫn Password không
$sql = "SELECT * FROM users WHERE username = '$username' AND password = '$password'";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    // Nếu tìm thấy -> Đăng nhập thành công
    $row = $result->fetch_assoc();
    echo json_encode([
        "status" => "success",
        "message" => "Đăng nhập thành công",
        "user" => $row // Trả về thông tin người dùng
    ]);
} else {
    // Nếu không tìm thấy
    echo json_encode(["status" => "error", "message" => "Sai tài khoản hoặc mật khẩu!"]);
}

$conn->close();
?>