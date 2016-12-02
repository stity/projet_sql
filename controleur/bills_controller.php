<?php
    class BillsController {
        var $user;

        function __construct($vue)  {
            $vue->display('bills', 'Factures', 'Consulter ma facture');
        }
    }
?>
