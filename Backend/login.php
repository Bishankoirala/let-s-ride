<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

session_start();
require_once __DIR__ . "/config/db.php";

if ($_SERVER["REQUEST_METHOD"] == "POST") {

    $email = trim($_POST["email"]);
    $password = $_POST["password"];

    
    $stmt = $conn->prepare("
        SELECT id, name, email, password, role
        FROM users
        WHERE email = ?
    ");

    $stmt->bind_param("s", $email);
    $stmt->execute();

    $result = $stmt->get_result();

    if ($result->num_rows == 1) {

        $user = $result->fetch_assoc();

        if (password_verify($password, $user["password"])) {

            // Save session
            $_SESSION["user_id"] = $user["id"];
            $_SESSION["id"] = $user["id"];          
            $_SESSION["name"] = $user["name"];
            $_SESSION["email"] = $user["email"];
            $_SESSION["role"] = $user["role"];

            // Redirect to profile page
          header("Location: ../profile.html");
                exit();
        } else {

            echo "Wrong password!";

        }

    } else {

        echo "User not found!";

    }

    $stmt->close();
    $conn->close();

} else {

    echo "Invalid request.";

}
?>