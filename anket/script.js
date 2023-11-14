function loginUser() {
    var username = document.getElementById("loginUsername").value;
    var password = document.getElementById("loginPassword").value;

    // AJAX ile PHP API'ye istek gönderme
    var xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function () {
        if (this.readyState == 4 && this.status == 200) {
            var response = JSON.parse(this.responseText);
            if (response.status === "success") {
                // Giriş başarılıysa kullanıcı işlemleri bölümünü göster
                document.getElementById("userActions").style.display = "block";
                // Giriş ve kayıt formlarını gizle
                document.getElementById("loginForm").style.display = "none";
                document.getElementById("registerForm").style.display = "none";

                // Burada kullanıcının yönlendirileceği sayfayı belirle
                window.location.href = "user_home.html"; // Örnek bir sayfa adı, sizin kullanmak istediğiniz sayfa adını belirtmelisiniz.
            }
            alert(response.message);
        }
    };
    xhttp.open("POST", "api.php", true);
    xhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    xhttp.send("action=login_user&username=" + username + "&password=" + password);
}
