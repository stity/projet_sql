<?php
    class PhonesController {
        var $user;

        function __construct($vue)  {
            $vue->display('phones', 'Les téléphones', 'Liste des téléphones', $this);
        }

        function get_all_phones() {
            $db = new DB();
            $sql = "SELECT * FROM telephone WHERE is_deleted=true;";
            $result = $db->execute($sql);
            return $result;
        }

        function update_phone($data_tab){
            try {
                $db = new DB();
                foreach($data_tab as $key => $element) {
                    $data_tab[$key] = $db->escape_var($element);
                }
                $data_tab['tv'] = ($data_tab['tv'] == 'oui' ? 1 : 0);
                $data_tab['double_sim'] = ($data_tab['double_sim'] == 'oui' ? 1 : 0);
                $data_tab['carte_sd'] = ($data_tab['carte_sd'] == 'oui' ? 1 : 0);
                $sql = "CALL addPhone('".$data_tab['ecran']."', '".$data_tab['tv']."' ,'".$data_tab['appareil_photo']."' ,'". $data_tab['video_numerique']."' ,'".$data_tab['ram']."', '".$data_tab['carte_sd']."', '".$data_tab['double_sim']."' ,'" .$data_tab['photo_url']."' ,'".$data_tab['model']."' ,'".$data_tab['marque']."' ,'".$data_tab['prix']."' ,'".$data_tab['stockage']."' ,'".$data_tab['capacite_internet']."', @id);";
                $result = $db->execute($sql);
            } catch (Exception $e) {
                return $result = 'error';
            }
        }

        function delete_phone($id){
            try {
                $db = new DB();
                $id = $db->escape_var($id);
                $sql = "CALL deletePhone(".$id.");";
                $result = $db->execute($sql);
            } catch (Exception $e) {
                return $result = 'error';
            }
        }

        function buy_phone($id){
            try {
                $db = new DB();
                $usrid = $db->execute('SELECT idutilisateur FROM utilisateur WHERE mail="'.$_SESSION['usr_mail'].'";');
                $sql = 'CALL addAchat("'.date('Y-m-d H:i:s').'", "'.$id.'" , "'.mysqli_fetch_array($usrid)[0].'", NULL, @id);';
                $db->execute($sql);
            } catch(Exception $e) {
                var_dump($e);
            }
        }
    }
?>
