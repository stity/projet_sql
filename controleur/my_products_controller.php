<?php
    class MyProductsController {
        var $user;

        function __construct($vue)  {
            $vue->display('my_products', 'Mes abonnements', 'Détail de vos abonnements', $this);
        }
    }
?>
