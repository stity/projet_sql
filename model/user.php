<?php

class User {
    public $name;
    public $mail;
    public $adress;
    public $password;
    private $id;
    private $db;

    function __construct()  {
        // Etablissement connection
        $this->db = new DB();
        //$db->close();

        // Instanciation
    }

    function saveToDB () {
        if (isset($this->id)) {
            $sql = "UPDATE utilisateur SET nom='".$this->name."', mail='".$this->mail."', adresse='".$this->adress."', mot_de_passe='".$this->password."' WHERE idutilisateur=".$this->id;
            try {
                $this->db->execute($sql);
            }
            catch (Exception  $e) {
                echo $e;
            }
        }
        else {
            $id = $this->db->callSQLFunction('addUserF', $this->name, $this->mail, $this->adress, $this->password);
            $this->id = $id;
        }
    }

    function deleteFromDB () {
    }
}

?>
