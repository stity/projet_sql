<?php
    class MyProductsController {
        var $user;

        function __construct($vue)  {
            $vue->display('my_products', 'Mes abonnements', 'Détail de vos abonnements', $this);
        }

        function get_abonnements(){
            $sql = 'SELECT * FROM formule WHERE id IN (SELECT id_formule FROM achat WHERE id_utilisateur IN (SELECT id FROM utilisateur WHERE mail="'.$_SESSION['usr_mail'].'"));';
            $db = new DB();
            $result = $db->execute($sql);
            return $result;
        }

        function get_telephones(){
            $sql = 'SELECT * FROM telephone WHERE idtelephone IN (SELECT telephone FROM achat WHERE id_utilisateur IN (SELECT id FROM utilisateur WHERE mail="'.$_SESSION['usr_mail'].'"));';
            $db = new DB();
            $result = $db->execute($sql);
            return $result;
        }

        function get_etrangers($id){
            try{
                $db = new DB();
                $sql = "CALL getFormuleForfaitEtranger(".$id.");";
                $result = $db->execute($sql);
                $string_result = '';
                while($row = mysqli_fetch_assoc($result)){
                    $string_result = $string_result . ' ' . $row['forfait_etranger'];
                }
                return $string_result;
            } catch(Exception $e) {
                return '';
            }
        }

        function get_forfaits_etrangers(){
            $db = new DB();
            $sql = "SELECT id, nom FROM forfait_etranger;";
            $result = $db->execute($sql);
            return $result;
        }
    }
?>
