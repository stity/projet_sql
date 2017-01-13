<?php
    /*
            Classe "Vue" pour générer automatiquement les vues attendues
            et les insérer dans le layout global de l'application
    */
    class Vue{
        private $file;                                  // Fichier principal de la vue
        private $__path_vues = 'vue/';                  // Chemin vers les vues
        private $__main_layout = 'vue/main.html.php';

        public function display($vue, $title, $subtitle, $controleur) {
            // Chercher le nom de fichier en fonction de la vue demandée.
            include ($this->__main_layout);
            if($vue != 'default'){
                $this->file = $this->__path_vues.$this->determine_vue($vue);
                include ($this->file);
            } else {
                $this->file = $this->__main_layout;
            }

        }

        private function determine_vue($vue){
            switch($vue){
                case 'users':
                    return 'user.html.php';
                    break;
                case 'bills':
                    return 'bill.html.php';
                    break;
                case 'products':
                    return 'product.html.php';
                    break;
                case 'phones':
                    return 'phone.html.php';
                    break;
                case 'my_products':
                    return 'my_products.html.php';
                    break;
            }
        }

    }
?>
