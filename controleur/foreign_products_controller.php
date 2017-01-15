<?php
    /* Pour représenter les formules */
    class ForeignProductsController {

        function __construct($vue)  {
            if($_SESSION['login_level'] == 'admin'){
                $vue->display('foreign_products', 'Forfaits étrangers', "Édition des forfaits vers l'étranger", $this);
            } else {
                $vue->display('foreign_products', 'Forfaits étrangers', "Vers l'étranger", $this);
            }
        }
    }
?>
