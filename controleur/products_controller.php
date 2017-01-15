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

        function get_abonnements($want_promotion, $want_formules){
            if($want_promotion && $want_formules){
                $sql = "SELECT * FROM formule;";
            } else if($want_promotion){
                $sql = "SELECT * FROM formule WHERE formule_base <> -1;";
            } else {
                $sql = "SELECT * FROM formule WHERE formule_base = -1;";
            }
            $db = new DB();
            $result = $db->execute($sql);
            return $result;
        }
    }
?>
