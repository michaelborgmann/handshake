<?php
    
    include_once 'settings.php';
    include_once 'database.php';
    
    $name = htmlentities($_POST["name"]);
    $email = htmlentities($_POST["email"]);
    $password = htmlentities($_POST["password"]);
    
    $returnValue = array();
    
    if (empty($name) || empty($email) || empty($password)) {
        $returnValue["status"] = "ERROR";
        $returnValue["message"]= "Missing fields required";
        echo json_encode($returnValue);
        return;
    }
    
    $database = new Database();
    $database->connect();
    $account = $database->getAccount($email);
    
    if (!empty($account)) {
        $returnValue["status"] = "ERROR";
        $returnValue["message"] = "User already exists";
        echo json_encode($returnValue);
        return;
    }
    
    $salt = hash('sha512', uniqid(mt_rand(1, mt_getrandmax()), true));
    $password = hash('sha512', $password . $salt);
    
    $result = $database->registerAccount($name, $email, $password, $salt);
    
    if ($result) {
        $returnValue["status"] = "SUCCESS";
        $returnValue["message"]= "Registered account";
        echo json_encode($returnValue);
        return;
    }
    
    $database->disconnect();
    
?>