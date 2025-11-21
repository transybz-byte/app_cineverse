<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *"); // Cho phép Flutter gọi vào

include 'db_connect.php';

$sql = "SELECT * FROM movies";
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