<?php
    class ProductsController {
        var $user;

        function __construct($vue)  {
            $vue->display('products', 'Les abonnements', 'Abonnements proposés par Télarnaque');
        }
    }
?>
