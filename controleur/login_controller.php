<?php
    class LoginController {
        var $auth_title = 'Authentification';
        var $auth_subtitle = 'Veuillez vous authentifier';
        var $logout_title = 'Déconnexion';
        var $logout_subtitle = 'Voulez-vous vous déconnecter?';
        var $title;
        var $subtitle;

        function __construct($vue, $log_in, $login_level)  {
            if($log_in){
                $this->title = $this->logout_title;
                $this->subtitle = $this->logout_subtitle;
                $vue->display('login', '', '', $this);
            } else {
                $this->title = $this->auth_title;
                $this->subtitle = $this->auth_subtitle;
                $vue->display('login', '', '', $this);
            }
        }

        function log_user($email, $mdp){
            $db = new DB();
            try {
                $email = $db->escape_var($email);
                $mdp = $db->escape_var($mdp);
                $sql = "CALL checkPassword('".$mdp."', '".$email."', @ok);";
                $result = $db->execute($sql);
                if($result){
                    $sql = "SELECT @ok;";
                    $result = $db->execute($sql);
                    $auth_success = ($result->fetch_assoc()['@ok'] == 1);
                    $_SESSION['log_in'] = $auth_success;
                }
            } catch (Exception $e) {
                return $result = 'fatal_error';
            }
            if($auth_success){
                $this->title = $this->logout_title;
                $this->subtitle = $this->logout_subtitle;
                $sql = "SELECT admin FROM utilisateur WHERE mot_de_passe='".$mdp."' AND mail='".$email."' LIMIT 1;";
                $result = $db->execute($sql);
                $_SESSION['login_level'] = ($result->fetch_assoc()['admin'] == 1);
            } else {
                $result = 'auth_error';
            }
        }

        function logout_user(){
            $this->title = $this->auth_title;
            $this->subtitle = $this->auth_subtitle;
            $_SESSION['log_in'] = false;
            $_SESSION['login_level'] = false;
        }
    }
?>
