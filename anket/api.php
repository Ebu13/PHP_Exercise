<?php
header("Content-Type: application/json");

$servername = "localhost:3306";
$username = "root";
$password = "13042003";
$dbname = "surveys";

// Veritabanı bağlantısı oluştur
$conn = new mysqli($servername, $username, $password, $dbname);

// Bağlantıyı kontrol et
if ($conn->connect_error) {
    die("Bağlantı hatası: " . $conn->connect_error);
}

// Kullanıcı kayıt işlemi
if ($_SERVER["REQUEST_METHOD"] === "POST" && isset($_POST["action"])) {
    if ($_POST["action"] === "register_user") {
        registerUser();
    } elseif ($_POST["action"] === "login_user") {
        loginUser();
    } elseif ($_POST["action"] === "publish_survey") {
        publishSurvey();
    } elseif ($_POST["action"] === "participate_survey") {
        participateSurvey();
    }
}

// Kullanıcı kayıt fonksiyonu
function registerUser() {
    global $conn;
    $username = $_POST["username"];
    $password = $_POST["password"];

    $stmt = $conn->prepare("INSERT INTO users (username, password) VALUES (?, ?)");
    $stmt->bind_param("ss", $username, $password);

    if ($stmt->execute()) {
        echo json_encode(array("status" => "success", "message" => "Kullanıcı başarıyla kaydedildi."));
    } else {
        echo json_encode(array("status" => "error", "message" => "Kullanıcı kaydedilemedi."));
    }

    $stmt->close();
}

// Kullanıcı giriş fonksiyonu
function loginUser() {
    global $conn;
    $username = $_POST["username"];
    $password = $_POST["password"];

    $stmt = $conn->prepare("SELECT id FROM users WHERE username = ? AND password = ?");
    $stmt->bind_param("ss", $username, $password);
    $stmt->execute();
    $stmt->store_result();

    if ($stmt->num_rows > 0) {
        echo json_encode(array("status" => "success", "message" => "Giriş başarılı."));
    } else {
        echo json_encode(array("status" => "error", "message" => "Geçersiz kullanıcı adı veya şifre."));
    }

    $stmt->close();
}

// Anket yayınlama fonksiyonu
function publishSurvey() {
    global $conn;
    $user_id = $_POST["user_id"];
    $title = $_POST["title"];
    $question = $_POST["question"];
    $option1 = $_POST["option1"];
    $option2 = $_POST["option2"];

    $stmt = $conn->prepare("INSERT INTO published_surveys (user_id, title, question, option1, option2) VALUES (?, ?, ?, ?, ?)");
    $stmt->bind_param("issss", $user_id, $title, $question, $option1, $option2);

    if ($stmt->execute()) {
        echo json_encode(array("status" => "success", "message" => "Anket başarıyla yayınlandı."));
    } else {
        echo json_encode(array("status" => "error", "message" => "Anket yayınlanamadı."));
    }

    $stmt->close();
}

// Anket katılım fonksiyonu
function participateSurvey() {
    global $conn;
    $user_id = $_POST["user_id"];
    $survey_id = $_POST["survey_id"];
    $answer = $_POST["answer"];

    $stmt = $conn->prepare("INSERT INTO participated_surveys (user_id, survey_id, answer) VALUES (?, ?, ?)");
    $stmt->bind_param("iis", $user_id, $survey_id, $answer);

    if ($stmt->execute()) {
        echo json_encode(array("status" => "success", "message" => "Ankete başarıyla katılım sağlandı."));
    } else {
        echo json_encode(array("status" => "error", "message" => "Ankete katılım sağlanamadı."));
    }

    $stmt->close();
}

// Veritabanı bağlantısını kapat
$conn->close();
?>
