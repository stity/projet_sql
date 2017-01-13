<?php
    class UsersController {
        var $user;

        function __construct($vue)  {
            $vue->display('users', 'Les utilisateurs', 'Liste des utilisateurs', $this);
        }

        function get_all_users() {
            $db = new DB();
            $sql = "SELECT * FROM utilisateur;";
            $result = $db->execute($sql);
            return $result;
        }

        function create_new_user($nom, $mail, $adress){
            try {
                $db = new DB();
                $nom = $db->escape_var($nom);
                $mail = $db->escape_var($mail);
                $adress = $db->escape_var($adress);
                $sql = "CALL addUser('".$nom."', '".$mail."', '".$adress."', '".$nom."0000', @id);";
                $result = $db->execute($sql);
            } catch (Exception $e) {
                return $result = 'error';
            }
        }

        function delete_user($id){
            try {
                $db = new DB();
                $id = $db->escape_var($id);
                $sql = "CALL deleteUser(".$id.");";
                $result = $db->execute($sql);
            } catch (Exception $e) {
                return $result = 'error';
            }
        }
    }
?>
