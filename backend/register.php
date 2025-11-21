<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
include 'db_connect.php';

// Lấy dữ liệu gửi lên từ Flutter (dạng POST)
$username = $_POST['username'];
$password = $_POST['password'];
$full_name = $_POST['full_name'];

// 1. Kiểm tra xem tên đăng nhập đã tồn tại chưa
$checkSql = "SELECT * FROM users WHERE username = '$username'";
$checkResult = $conn->query($checkSql);

if ($checkResult->num_rows > 0) {
    // Nếu có rồi thì báo lỗi
    echo json_encode(["status" => "error", "message" => "Tài khoản đã tồn tại!"]);
} else {
    // 2. Nếu chưa có thì thêm mới vào bảng users
    $sql = "INSERT INTO users (username, password, full_name) VALUES ('$username', '$password', '$full_name')";
    
    if ($conn->query($sql) === TRUE) {
        echo json_encode(["status" => "success", "message" => "Đăng ký thành công!"]);
    } else {
        echo json_encode(["status" => "error", "message" => "Lỗi: " . $conn->error]);
    }
}

$conn->close();
?>