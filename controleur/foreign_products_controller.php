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

        function update_foreign_product($data_tab){
            try {
                $db = new DB();
                foreach($data_tab as $key => $element) {
                    $data_tab[$key] = $db->escape_var($element);
                }
                if($data_tab['periode_semaine'] == "all_week"){
                    $periode_semaine = 'all_' . $data_tab['plage_horaire'];
                } else if($data_tab['periode_semaine'] == "week"){
                    $periode_semaine = 'week_' . $data_tab['plage_horaire'];
                } else if($data_tab['periode_semaine'] == "week-end"){
                    $periode_semaine = 'week_end_' . $data_tab['plage_horaire'];
                }
                $data_tab['bloque'] = ($data_tab['bloque'] == 'oui' ? 1 : 0);
                $res = $db->execute('SELECT zone FROM forfait_etranger WHERE nom="'.$data_tab['nom'].'" LIMIT 1;');
                if(mysqli_num_rows($res) != 0){
                    $zone = mysqli_fetch_row($res)[0];
                } else {
                    $zone = $data_tab['zone'];
                }

                $sql = "CALL addForeignForfait('".$data_tab['nom']."', '".$data_tab['limite_appel']."', '".$data_tab['limite_sms']."', '".$data_tab['limite_data']."', '".$data_tab['bloque']."', '".$periode_semaine."', '".$data_tab['prix_hors_forfait_appel']."', '".$data_tab['prix_hors_forfait_sms']."', '". $data_tab['prix_hors_forfait_data']."', '".$zone."');";
                $result = $db->execute($sql);
            } catch (Exception $e) {
                return $result = 'error';
            }
        }

        function get_abonnements_etranger(){
            $sql = "SELECT * FROM forfait_etranger WHERE is_deleted = FALSE";
            $db = new DB();
            $result = $db->execute($sql);
            return $result;
        }

        function get_zones_geographique($id){
            $sql = 'SELECT nom FROM zone_geographique WHERE id='.$id.' LIMIT 1;';
            $db = new DB();
            $result = $db->execute($sql);
            return mysqli_fetch_array($result)[0];
        }

        function delete_abonnement_etranger($id){
            try {
                $db = new DB();
                $id = $db->escape_var($id);
                $sql = "CALL deleteFormuleEtranger(".$id.");";
                $result = $db->execute($sql);
            } catch (Exception $e) {
                var_dump($e);
                return $result = 'error';
            }
        }

        function get_zones(){
            $db = new DB();
            $sql = "SELECT id, nom FROM zone_geographique;";
            $result = $db->execute($sql);
            return $result;
        }
    }
?>
