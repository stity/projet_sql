<?php

    require 'controleur/users_controller.php';
    require 'controleur/bills_controller.php';
    require 'controleur/phones_controller.php';
    require 'controleur/products_controller.php';
    require 'controleur/my_products_controller.php';
    require 'vue/vue.php';

    $pages = array("users", "bills", "phones", "products");

    $vue = new Vue();
    try {
        if (isset($_GET['vue'])){
            switch($_GET['vue']){
                case 'users':
                    $controleur = new UsersController($vue);
                    break;
                case 'bills':
                    $controleur = new BillsController($vue);
                    break;
                case 'phones':
                    $controleur = new PhonesController($vue);
                    break;
                case 'products':
                    $controleur = new ProductsController($vue);
                    break;
                case 'my_products':
                    $controleur = new MyProductsController($vue);
                    break;
            }
        }
        else {
            $vue -> display('default', 'Ma comagnie de téléphone', 'Bienvenue');
        }
    }
    catch (Exception $e) {
        include('vue/main.html');
        erreur($e->getMessage());
    }
?>
