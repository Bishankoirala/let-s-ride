<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

require_once __DIR__ . "/config/db.php";

if ($_SERVER["REQUEST_METHOD"] == "POST") {

    $name = trim($_POST["name"]);
    $email = trim($_POST["email"]);
    $phone = trim($_POST["phone"]);
    $password = $_POST["password"];
    $role = $_POST["role"];

    // Check if email already exists
    $check = $conn->prepare("SELECT id FROM users WHERE email = ?");
    $check->bind_param("s", $email);
    $check->execute();

    $result = $check->get_result();

    if ($result->num_rows > 0) {
        echo "Email already registered!";
        exit();
    }

    // Encrypt password
    $hashedPassword = password_hash($password, PASSWORD_DEFAULT);

    // Insert user
    $stmt = $conn->prepare(
        "INSERT INTO users (name, email, phone, password, role)
         VALUES (?, ?, ?, ?, ?)"
    );

    $stmt->bind_param(
        "sssss",
        $name,
        $email,
        $phone,
        $hashedPassword,
        $role
    );


    if ($stmt->execute()) {

        echo "Registration Successful!";
        // You can redirect later:
        // header("Location: ../login.html");
        // exit();

    } else {

        echo "Registration Failed: " . $stmt->error;

    }


    $stmt->close();
    $check->close();
    $conn->close();

}

?>