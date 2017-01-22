<?php
    /* Pour représenter les formules */
    class ProductsController {
        var $return_results = null;

        function __construct($vue)  {
            if($_SESSION['login_level'] == 'admin'){
                $vue->display('products', 'Les abonnements', 'Édition des abonnements', $this);
            } else {
                $vue->display('products', 'Les abonnements', 'Abonnements proposés par Centrale-Télécom', $this);
            }
        }

        function update_product($data_tab){
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
                $data_tab['date_debut'] = ($data_tab['date_debut'] == '' ? 'NULL' : $data_tab['date_debut']);
                $data_tab['date_fin'] = ($data_tab['date_fin'] == '' ? 'NULL' : $data_tab['date_fin']);
                $data_tab['bloque'] = ($data_tab['bloque'] == 'oui' ? 1 : 0);
                $sql = "CALL addFormule('".$data_tab['nom']."', '".$data_tab['prix_mensuel']."', '".$data_tab['limite_appel']."', '".$data_tab['limite_sms']."', '".$data_tab['limite_data']."', '".$periode_semaine."', '".$data_tab['prix_hors_forfait_appel']."', '".$data_tab['prix_hors_forfait_sms']."', '". $data_tab['prix_hors_forfait_data']."', '".$data_tab['bloque']."', NULL, '".$data_tab['prix_base']."','".$data_tab['telephone']."', '".$data_tab['formule_base']."', ".$data_tab['date_debut'].", ".$data_tab['date_fin'].");";
                $result = $db->execute($sql);
            } catch (Exception $e) {
                return $result = 'error';
            }
        }

        function get_abonnements($want_promotion, $want_formules){
            if($this->return_results == null){
                if($want_promotion && $want_formules){
                    $sql = "SELECT * FROM formule WHERE is_deleted = FALSE;";
                } else if($want_promotion){
                    $sql = "SELECT * FROM formule WHERE formule_base <> -1 AND is_deleted = FALSE;";
                } else {
                    $sql = "SELECT * FROM formule WHERE formule_base = -1 AND is_deleted = FALSE;";
                }
                $db = new DB();
                $result = $db->execute($sql);
            } else {
                $result = $this->return_results;
            }
            return $result;
        }

        function get_etrangers($id){
            try{
                $db = new DB();
                $sql = "CALL getFormuleForfaitEtranger(".$id.");";
                $result = $db->execute($sql);
                return $result;
            } catch(Exception $e) {
                return '';
            }
        }

        function get_assoc_phones($id){
            try{
                $db = new DB();
                $sql = "CALL getFormuleTelephone(".$id.");";
                $result = $db->execute($sql);
                return $result;
            } catch(Exception $e) {
                var_dump($e);
                return '';
            }
        }

        function filter_result($data){
            if(!array_key_exists('promotion', $data)){
                $data['promotions'] = 'off';
            }
            if(!array_key_exists('abonnements', $data)){
                $data['abonnements'] = 'off';
            }
            if($data['promotions'] == 'on' && $data['abonnements'] == 'on'){
                $sql_chunck = '';
            } else if(!empty($data['promotions']) && $data['abonnements'] == 'on'){
                $sql_chunck = 'formule_base = -1';
            } else if($data['promotions'] == 'on' && !empty($data['abonnements'])){
                $sql_chunck = 'formule_base <> -1';
            } else {
                $sql_chunck = 'formule_base = -2';
            }
            $data['max_price'] = ($data['max_price'] == '' ? 10000 : $data['max_price']);
            $data['min_price'] = ($data['min_price'] == '' ? 0 : $data['min_price']);
            $sql = 'SELECT * FROM formule WHERE prix_mensuel >= ' . $data['min_price'] . ' AND prix_mensuel <= ' .             $data['max_price'] . ($sql_chunck == '' ? '' : ' AND ') . $sql_chunck . ' AND is_deleted = FALSE;';
            $db = new DB();
            $result = $db->execute($sql);
            $this->return_results = $result;
        }

        function assoc_foreign_product($data){
            try{
                $id = $data['id'];
                $sql = 'DELETE FROM formule_forfait_etranger WHERE formule=' . $id . ';';
                foreach($data as $key => $element){
                    if(preg_match('/field_[1-9]+/', $key)){
                        $zone_id = preg_replace('/field_/', '', $key);
                        $sql = $sql . ' CALL addFormuleForfaitEtranger(' . $id . ', ' . $zone_id . ');';
                    }
                }
                $db = new DB();
                $db->executeMulti($sql);
            } catch(Exception $e){
                var_dump('Une erreur est survenue');
            }
        }

        function assoc_telephone($data){
            try{
                $id = $data['id'];
                $sql = 'DELETE FROM formule_telephone WHERE formule=' . $id . ';';
                foreach($data as $key => $element){
                    if(preg_match('/field_[1-9]+/', $key)){
                        $phone_id = preg_replace('/field_/', '', $key);
                        $sql = $sql . ' CALL addFormuleTelephone(' . $id . ', ' . $phone_id . ');';
                    }
                }
                $db = new DB();
                $db->executeMulti($sql);
            } catch(Exception $e){
                var_dump($e);
                var_dump('Une erreur est survenue');
            }
        }

        function get_basics_abonnements(){
            $db = new DB();
            $sql = "SELECT id, nom, prix_mensuel FROM formule WHERE formule_base = -1 AND is_deleted = FALSE";
            $result = $db->execute($sql);
            return $result;
        }

        function get_phones(){
            try{
                $db = new DB();
                $sql = "SELECT idtelephone AS id, modele AS nom FROM telephone;";
                $result = $db->execute($sql);
                return $result;
            } catch(Exception $e){
                var_dump($e);
            }
        }

        function delete_abonnement($id){
            try {
                $db = new DB();
                $id = $db->escape_var($id);
                $sql = "CALL deleteFormule(".$id.");";
                $result = $db->execute($sql);
            } catch (Exception $e) {
                return $result = 'error';
            }
        }

        function get_forfaits_etrangers(){
            $db = new DB();
            $sql = "SELECT id, nom FROM forfait_etranger;";
            $result = $db->execute($sql);
            return $result;
        }

        function getSubscription($mail){
            try{
                $sql = 'SELECT id_formule FROM achat WHERE id_utilisateur IN (SELECT idutilisateur FROM utilisateur WHERE mail = "'.$mail.'");';
                $db = new DB();
                $result = $db->execute($sql);
                return $result;
            } catch(Exception $e) {
                var_dump($e);
            }
        }

        function subscribe($id){
            try{
                $db = new DB();
                $usrid = $db->execute('SELECT idutilisateur FROM utilisateur WHERE mail="'.$_SESSION['usr_mail'].'";');
                $sql = 'CALL addAchat("'.date('Y-m-d H:i:s').'", NULL, "'.mysqli_fetch_array($usrid)[0].'", '.$id.', @id);';
                $result = $db->execute($sql);
            } catch(Exception $e){
                var_dump($e);
            }
        }

        function unsubscribe($id){
            try{
                $db = new DB();
                $usrid = $db->execute('SELECT idutilisateur FROM utilisateur WHERE mail="'.$_SESSION['usr_mail'].'";');
                $sql = 'DELETE FROM achat WHERE id_utilisateur="'.mysqli_fetch_array($usrid)[0].'" AND id_formule="'.$id.'";';
                $result = $db->execute($sql);
            } catch(Exception $e){
                var_dump($e);
            }
        }
    }
?>
