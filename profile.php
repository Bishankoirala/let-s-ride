<?php

error_reporting(E_ALL);
ini_set('display_errors', 1);

session_start();

require_once __DIR__ . "/Backend/config/db.php";

header("Content-Type: application/json");


if (!isset($_SESSION["user_id"])) {

    echo json_encode([
        "success" => false,
        "message" => "Please login first."
    ]);

    exit();
}


$userId = $_SESSION["user_id"];


/* ==========================
   GET PROFILE
========================== */

if (
    $_SERVER["REQUEST_METHOD"] == "GET" &&
    isset($_GET["action"]) &&
    $_GET["action"] == "get"
) {


    $stmt = $conn->prepare(
        "SELECT * FROM users WHERE id=?"
    );

    $stmt->bind_param("i", $userId);

    $stmt->execute();


    $result = $stmt->get_result();


    if ($result->num_rows == 0) {

        echo json_encode([
            "success" => false,
            "message" => "User not found."
        ]);

        exit();
    }


    $user = $result->fetch_assoc();


    echo json_encode([

        "success" => true,

        "user" => [

            "id" => $user["id"],

            "name" => $user["name"],

            "email" => $user["email"],

            "phone" => $user["phone"],

            "date_of_birth" => $user["dob"],

            "gender" => $user["gender"],

            "address" => $user["address"],

            "bio" => $user["bio"],


            "phone_verified" => false,

            "bookings_count" => 0,

            "vehicles_count" => 0,

            "rating" => 0
        ]

    ]);


    exit();

}






if ($_SERVER["REQUEST_METHOD"] == "POST") {


    $action = $_POST["action"] ?? "";





    if ($action == "update_personal") {


        $first = trim($_POST["first_name"]);

        $last = trim($_POST["last_name"]);


        $name = trim($first . " " . $last);


        $phone = trim($_POST["phone"]);

        $dob = $_POST["date_of_birth"];

        $gender = $_POST["gender"];

        $address = trim($_POST["address"]);

        $bio = trim($_POST["bio"]);



        $stmt = $conn->prepare(

            "UPDATE users SET
            name=?,
            phone=?,
            dob=?,
            gender=?,
            address=?,
            bio=?
            WHERE id=?"

        );


        $stmt->bind_param(

            "ssssssi",

            $name,

            $phone,

            $dob,

            $gender,

            $address,

            $bio,

            $userId

        );



        if ($stmt->execute()) {


            $_SESSION["name"] = $name;


            echo json_encode([

                "success" => true,

                "message" => "Profile updated successfully."

            ]);



        } else {


            echo json_encode([

                "success" => false,

                "message" => "Database error."

            ]);

        }


        exit();

    }





    /* ==========================
       CHANGE PASSWORD
    ========================== */


    if ($action == "change_password") {


        $current = $_POST["current_password"];

        $new = $_POST["new_password"];



        $stmt = $conn->prepare(

            "SELECT password FROM users WHERE id=?"

        );


        $stmt->bind_param("i", $userId);


        $stmt->execute();


        $result = $stmt->get_result();



        if ($result->num_rows == 0) {


            echo json_encode([

                "success" => false,

                "message" => "User not found."

            ]);


            exit();

        }



        $user = $result->fetch_assoc();



        if (!password_verify($current, $user["password"])) {


            echo json_encode([

                "success" => false,

                "message" => "Current password is incorrect."

            ]);


            exit();

        }



        $newHash = password_hash(

            $new,

            PASSWORD_DEFAULT

        );



        $stmt = $conn->prepare(

            "UPDATE users SET password=? WHERE id=?"

        );



        $stmt->bind_param(

            "si",

            $newHash,

            $userId

        );



        if ($stmt->execute()) {


            echo json_encode([

                "success" => true,

                "message" => "Password updated successfully."

            ]);


        } else {


            echo json_encode([

                "success" => false,

                "message" => "Unable to update password."

            ]);

        }



        exit();

    }






    if ($action == "update_notifications") {


        echo json_encode([

            "success" => true,

            "message" => "Preferences saved."

        ]);


        exit();

    }


}



/* ==========================
   INVALID REQUEST
========================== */


echo json_encode([

    "success" => false,

    "message" => "Invalid request."

]);



$conn->close();

?>