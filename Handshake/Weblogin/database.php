<?php
    
include_once 'settings.php';

    class Database {
        var $database = null;
        
        function connect() {
            $this->database = new mysqli(HOST, USER, PASSWORD, DATABASE);
            
            if (mysqli_connect_errno()) {
                echo new Exception("Could not establish connection with database");
            }
        }
        
        function disconnect() {
            if ($this->database != null) {
                $this->database->close();
            }
        }
        
        function getAccount($email) {
            $returnValue = array();
            $sql = "SELECT * FROM Users WHERE email='".$email."'";
            
            $result = $this->database->query($sql);
            
            if ($result != null && (mysqli_num_rows($result) >= 1)) {
                $row = $result->fetch_array(MYSQLI_ASSOC);
                if (!empty($row)) {
                    $returnValue = $row;
                }
            }
            return $returnValue;
        }
        
        function secureLogin($email, $password) {
            $returnValue = array();
            $sql = "SELECT id, username, password, salt FROM Users WHERE email='" . $email ."' LIMIT 1";
            
            $statement = $this->database->prepare($sql);
            $statement->execute();
            $statement->store_result();
            $statement->bind_result($id, $username, $dbpass, $salt);
            $statement->fetch();
            
            $password = hash('sha512', $password . $salt);
            
            if ($statement->num_rows == 1) {
                
                // check for bruteforce attack
                $now = time();
                $validAttempts = $now - (2 * 60 * 60);
                
                $sql = "SELECT time FROM LoginAttempts WHERE user_id = ? AND time > '$validAttempts'";
                
                if ($statement = $this->database->prepare($sql)) {
                    $statement->bind_param('i', $id);
                    $statement->execute();
                    $statement->store_result();
                    
                    if ($statement->num_rows > 5) {
                        echo "BRUTE FORCE ATTACK";
                        return false;
                    }
                }
                
                // check password
                if ($dbpass == $password) {
                    return true;
                } else {
                    $now = time();
                    $this->database->query("INSERT INTO LoginAttempts(user_id, time)
                                           VALUES ('$id', '$now')");
                                           return false;
                }
            }
        }
                                           
        function registerAccount($name, $email, $password, $salt) {
            $sql = "INSERT INTO Users (username, email, password, salt) VALUES (?, ?, ?, ?)";
                                           
            $statement = $this->database->prepare($sql);

            if (!$statement) {
                throw new Exception($statement->error);
            }
            
            $statement->bind_param('ssss', $name, $email, $password, $salt);
            $returnValue = $statement->execute();
            return $returnValue;
        }
    }
?>