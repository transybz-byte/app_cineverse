<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
include 'db_connect.php';

// Lấy từ khóa người dùng gửi lên (nếu không có thì để rỗng)
$keyword = isset($_GET['keyword']) ? $_GET['keyword'] : '';

// Tìm phim có tên CHỨA từ khóa đó (Dùng lệnh LIKE)
$sql = "SELECT * FROM movies WHERE title LIKE '%" . $conn->real_escape_string($keyword) . "%'";
$result = $conn->query($sql);

$movies = array();
if ($result->num_rows > 0) {
    while($row = $result->fetch_assoc()) {
        $movies[] = $row;
    }
}

echo json_encode($movies);
$conn->close();
?>