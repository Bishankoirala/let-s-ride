<?php

$host = "localhost";
$user = "root";
$password = "";
$database = "let_ride";

$conn = new mysqli($host, $user, $password, $database);

if ($conn->connect_error) {
    die("Database Connection Failed: " . $conn->connect_error);
}

?>