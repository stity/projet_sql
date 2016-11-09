<?php


class User {
    var $name;
    var $mail;
    var $adress;
    var $password;

    function __construct()  {
        // Etablissement connection
        var $db = new DB();
        $db->close();

        // Instanciation

    }
}

?>
