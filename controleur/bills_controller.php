<?php
    class BillsController {
        var $user;

        function __construct($vue)  {
            $vue->display('bills', 'Factures', 'Consulter ma facture', $this);
        }

        function getAllFacture() {
            try{
                $db = new DB();
                $sql = "SELECT idconsommation AS id,consommation.date_debut AS date, prix, paye FROM facture, consommation, achat, utilisateur WHERE utilisateur.mail='".$_SESSION['usr_mail']."' AND achat.id_utilisateur = utilisateur.idutilisateur AND consommation.id_achat = achat.idachat AND facture.consommation = consommation.idconsommation ORDER BY date;";
                $result = $db->execute($sql);
                return $result;
            } catch(Exception $e) {
                var_dump($e);
            }
        }
    }
?>
