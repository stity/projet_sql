<?php
    class PhonesController {
        var $user;

        function __construct($vue)  {
            $vue->display('phones', 'Les téléphones', 'Liste des téléphones');
        }
    }
?>
