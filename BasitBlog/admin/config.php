<?php

// DB Bağlantı bilgilerimiz....
$databaseHost = '127.0.0.1';
$databaseName = 'myblog';
$databaseUsername = 'root';
$databasePassword = '13042003';

// Veritabanına Bağlanalım...
$mysqli = mysqli_connect($databaseHost, $databaseUsername, $databasePassword, $databaseName); 
// Veritabanı Kodlamasını UTF8 Yapalım...
$result = mysqli_query($mysqli, "SET NAMES utf8");
