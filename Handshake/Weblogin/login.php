<?php
    
    include_once 'settings.php';
    include_once 'database.php';
    
    $email = htmlentities($_POST["email"]);
    $password = htmlentities($_POST["password"]);
    
    $returnValue = array();
    
    if (empty($email) || empty($password)) {
        $returnValue['status'] = "Error";
        $returnValue['message'] = "Missing required fields.";
        echo json_encode($returnValue);
        return;
    }
    
    $database = new Database();
    $database->connect();
    $account = $database->secureLogin($email, $password);
    
    if ($account == true) {
        $returnValue['status'] = "Success";
        $returnValue['message'] = "User found";
        echo json_encode($returnValue);
    } else {
        $returnValue['status'] = "Error";
        $returnValue['message'] = "Can't login user";
        echo json_encode($returnValue);
    }
    
    $database->disconnect();
    
?>