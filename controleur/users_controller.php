<?php
    class UsersController {
        function __construct($vue, $log_in, $login_level)  {
            if($log_in && $login_level){
                $vue->display('users', 'Les utilisateurs', 'Liste des utilisateurs', $this);
            } else if($log_in) {
                $vue->display('users', 'Votre compte', 'Caractéristiques du compte', $this);
            } else {
                $vue->display('users', '', '', $this);
            }
        }

        function get_user_from_mail(){
            $db = new DB();
            $sql = "SELECT * FROM utilisateur WHERE mail='".$_SESSION['usr_mail']."' LIMIT 1;";
            $result = $db->execute($sql);
            return $result;
        }

        function get_all_users() {
            $db = new DB();
            $sql = "SELECT * FROM utilisateur WHERE mail <> '".$_SESSION['usr_mail']."';";
            $result = $db->execute($sql);
            return $result;
        }

        function create_new_user($nom, $mail, $adress, $is_admin){
            try {
                $db = new DB();
                $nom = $db->escape_var($nom);
                $mail = $db->escape_var($mail);
                $adress = $db->escape_var($adress);
                $is_admin = $db->escape_var($is_admin);
                $is_admin = ($is_admin == 'oui' ? 1 : 0);
                $sql = "CALL addUser('".$nom."', '".$mail."', '".$adress."', '".$nom."0000', '".$is_admin."', @id);";
                $result = $db->execute($sql);
            } catch (Exception $e) {
                return $result = 'error';
            }
        }

        function update_user($nom, $mail, $adresse, $mdp, $is_admin, $id){
            try {
                $db = new DB();
                $nom = $db->escape_var($nom);
                $mail = $db->escape_var($mail);
                $adresse = $db->escape_var($adresse);
                $mdp = $db->escape_var($mdp);
                $is_admin = $db->escape_var($is_admin);
                $is_admin = ($is_admin == 'oui' ? 1 : 0);
                $id = $db->escape_var($id);
                $sql = "CALL editUser('".$nom."', '".$mail."', '".$adresse."', '".$mdp."', '".$is_admin."', '".$id."');";
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
