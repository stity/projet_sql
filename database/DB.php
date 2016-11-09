<?php


class DB {
    var $servername;
    var $username;
    var $password;
    var $dbname;
    var $conn;

    function __construct()  {
        $this->servername = "localhost";
        $this->username = "root";
        $this->password = "";
        $this->dbname = "telephonie";

        // Create connection
        $this->conn = new mysqli($this->servername, $this->username, $this->password, $this->dbname);
        // Check connection
        if ($this->conn->connect_error) {
            die("Connection failed: " . $this->conn->connect_error);
        }
    }

    function close () {
        $this->conn->close();
    }
}

//var $db = new DB();
//$db->close();

?>
