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

    /* Exécuter une requête SQL */
    function execute ($request) {
        //execute request and return true if there was no issue
        $result = mysqli_query($this->conn, $request);

        if ($result) {
            return $result;
        } else {
            //throw sql error if error in the request
            throw new Exception("SQL Error : ".$this->conn->error );
        }
    }

    /* Exécuter des requêtes SQL */
    function executeMulti ($request) {

        if (mysqli_multi_query($this->conn, $request)) {
            do {
                if (!mysqli_more_results($this->conn)) {
                    break;
                }
                if (!mysqli_next_result($this->conn)) {
                    throw new Exception("SQL Error : ".$this->conn->error );
                    // report error
                    break;
                }
            } while (true);
        }
    }

    function escape_var($variable){
        return mysqli_real_escape_string($this->conn, $variable);
    }

    function callSQLFunction () {
        $numargs = func_num_args();
        $arg_list = func_get_args();
        $sql = 'SELECT ';
        if ($numargs >= 1) {
            $sql = $sql.$arg_list[0]."(";
        }
        for ($i = 1; $i < $numargs; $i++) {
            $arg = $arg_list[$i];
            if(is_string($arg)) {
                $arg = "'".$arg."'";
            }
            $sql = $sql.$arg;
            if ($i < $numargs - 1) {
                $sql = $sql.",";
            }
        }
        $sql = $sql.") AS result;";
        try {
            $queryresult = $this->execute($sql);
        }
        catch (Exception $e) {
            echo "Error in SQL function call : ".$arg_list[0]." Error message : \n".$e;
        }
        $result = $queryresult->fetch_assoc()['result'];
        return $result;
    }

    function callSQLProcedure () {
        $numargs = func_num_args();
        $arg_list = func_get_args();
        $sql = 'CALL ';
        if ($numargs >= 1) {
            $sql = $sql.$arg_list[0]."(";
        }
        for ($i = 1; $i < $numargs; $i++) {
            $arg = $arg_list[$i];
            if(is_string($arg)) {
                $arg = "'".$arg."'";
            }
            $sql = $sql.$arg.",";
        }
        $sql = $sql."@result); SELECT @result AS result;";
        try {
            $queryresult = $this->execute($sql);
        }
        catch (Exception $e) {
            echo "Error in SQL procedure call : ".$arg_list[0]." Error message : \n".$e;
        }
        $result = $queryresult->fetch_assoc()['result'];
        return $result;
    }

    function close () {
        $this->conn->close();
    }
}

//var $db = new DB();
//$db->close();

?>
