<?php
    /* Pour représenter les formules */
    class ProductsController {

        function __construct($vue)  {
            if($_SESSION['login_level'] == 'admin'){
                $vue->display('products', 'Les abonnements', 'Édition des abonnements', $this);
            } else {
                $vue->display('products', 'Les abonnements', 'Abonnements proposés par Télarnaque', $this);
            }
        }
    }
?>
