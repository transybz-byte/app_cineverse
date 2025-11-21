<?php
$servername = "localhost";
$username = "root";
$password = ""; 
$dbname = "cineverse_db";

// Tạo kết nối
$conn = new mysqli($servername, $username, $password, $dbname);
$conn->set_charset("utf8"); // Hỗ trợ tiếng Việt

// Kiểm tra lỗi
if ($conn->connect_error) {
    die("Kết nối thất bại: " . $conn->connect_error);
}
?>