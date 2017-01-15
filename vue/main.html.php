<!DOCTYPE html>

<html>
	<head>
		<meta charset="utf8"/>
		<title>Téléphonie</title>
		<link rel="stylesheet" type="text/css" href="assets/styles/progress_arrows.css">
		<link rel="stylesheet" type="text/css" href="assets/styles/layout.css">
		<link rel="stylesheet" href="assets/styles/font-awesome.min.css">
		<script src="assets/scripts/jquery.min.js"></script>
        <script src="./assets/scripts/common_scripts.js"></script>
	</head>
	<body>
		<div id="sidebar">
			<div class="sidebar-part" data-load="accueil">
                <div class="text-content">
                    <a href="index.php" class="text-content">
                        Accueil
                    </a>
                </div>
            </div>
            <?php
                if($_SESSION['log_in']) {
            ?>
                <div class="sidebar-part <?= $vue=="users" ? "selected" : "" ?>" data-load="users">
                    <a href="<?= "index.php?vue=users" ?>" class="text-content">
                        <?php echo ($_SESSION['login_level'] == 'admin') ? 'Les clients' : 'Mon compte'; ?>
                    </a>
                </div>

                <div class="sidebar-part <?= $vue=="bills" ? "selected" : "" ?>" data-load="bills">
                    <a href="<?= "index.php?vue=bills" ?>" class="text-content">
                        <?php echo ($_SESSION['login_level'] != 'admin') ? 'Mes' : 'Les' ?> factures
                    </a>
                </div>
            <?php
                }
            ?>
			<div class="sidebar-part sidebar-with-children" data-load="products_all" data-section-name="products_all">
                <div class="text-content">Abonnements</div>
                <i class="icon fa fa-chevron-down"></i>
            </div>
			<div class="sidebar-subpart-container" data-section="products_all">
				<div class="sidebar-subpart <?= $vue=="my_products" ? "selected" : "" ?>" data-load="my_products"><a href="<?= "index.php?vue=my_products" ?>" class="text-content">Mes abonnements</a></div>
				<div class="sidebar-subpart <?= $vue=="products" ? "selected" : "" ?>" data-load="products"><a href="<?= "index.php?vue=products" ?>" class="text-content">Nouvel abonnement</a></div>
		    </div>
            <div data-load="login">
                <a href="<?= "index.php?vue=login" ?>" class="user-login-choice">
                    <i class="icon fa fa-user"></i>
                </a>
            </div>
        </div>

        <?php
            if (!isset($_GET['vue'])){
        ?>
        <div id="inner_content">
            <div id="main_header"><?php echo $title ?></div>
            <div id="main_subheader"><?php echo $subtitle ?></div>
            <div id="main_content">
            </div>
        </div>
        <?php
             }
        ?>

	</body>
</html>
<script type="text/javascript">

/*
 *
 * Méthodes et objets globaux utilisés dans toute l'application.
 *
 */

// Variables globales
var _current_section = 'accueil';
var _current_subsection = '';

// Gestion des zones de la barre de navigation qui contiennent des
// sous-parties. Pour cette gestion, au clic on récupère la var
// section_name qui est enregistrée dans le HTML pour dérouler la
// sous-section correspondante.
// L'intérêt de fonctionner par ce système de clé-valeur, est que
// la div contenant les sous-sections n'est pas comprise dans la
// div du titre principal, et ainsi on éviter de ferme l'onglet au
// clic sur une sous-section.
$('.sidebar-with-children').on('click', function(e){
	var section_name = this.getAttribute('data-section-name');
	var associated_sections = $('.sidebar-subpart-container[data-section="' + section_name + '"]');
	if(associated_sections.css('display') == 'none' || associated_sections.css('display') == ''){
		$(this).find('.icon')[0].className = 'icon fa fa-chevron-up';
		associated_sections.css('display', 'block');
	} else {
		$(this).find('.icon')[0].className = 'icon fa fa-chevron-down';
		associated_sections.css('display', 'none');
	}
});

$.each($('.sidebar-subpart.selected'), function(){
    $('.sidebar-part').filter('[data-load="' + $(this).parent().attr('data-section') + '"]').click();
});
</script>
