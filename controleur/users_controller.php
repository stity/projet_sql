<?php
    class UsersController {
        var $user;

        function __construct($vue)  {
            $vue->display('users', 'Les utilisateurs', 'Liste des utilisateurs');
        }
    }
?>
