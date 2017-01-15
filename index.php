<?php
    session_start();
    if(!array_key_exists('log_in', $_SESSION)){
        $_SESSION['log_in'] = false;
        $_SESSION['login_level'] = '';
    }
?>

<?php

    require 'database/DB.php';
    require 'controleur/users_controller.php';
    require 'controleur/bills_controller.php';
    require 'controleur/phones_controller.php';
    require 'controleur/products_controller.php';
    require 'controleur/my_products_controller.php';
    require 'controleur/login_controller.php';
    require 'vue/vue.php';

    $pages = array("users", "bills", "phones", "products");

    $vue = new Vue();
    try {
        if (isset($_GET['vue'])){
            switch($_GET['vue']){
                case 'users':
                    $controleur = new UsersController($vue, $_SESSION['log_in'], $_SESSION['login_level']);
                    break;
                case 'bills':
                    $controleur = new BillsController($vue, $_SESSION['log_in'], $_SESSION['login_level']);
                    break;
                case 'phones':
                    $controleur = new PhonesController($vue, $_SESSION['log_in'], $_SESSION['login_level']);
                    break;
                case 'products':
                    $controleur = new ProductsController($vue, $_SESSION['log_in'], $_SESSION['login_level']);
                    break;
                case 'my_products':
                    $controleur = new MyProductsController($vue, $_SESSION['log_in'], $_SESSION['login_level']);
                    break;
                case 'login':
                    $controleur = new LoginController($vue, $_SESSION['log_in'], $_SESSION['login_level']);
                    break;
            }
        }
        else {
            $vue -> display('default', 'Ma comagnie de téléphone', 'Bienvenue', null);
        }
    }
    catch (Exception $e) {
        include('./vue/main.html.php');
        //erreur($e->getMessage());
    }
?>
