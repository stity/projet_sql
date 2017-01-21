<html>
	<head>
		<title><?= $title ?></title>
		<meta http-equiv="Content-Type" content="text/html" charset="utf8">
	</head>

	<body>
        <div id="inner_content">
            <div id="main_header"><?= $title ?></div>
            <div id="main_subheader"><?= $subtitle ?></div>
            <br/>
            Vous pourrez trouver dans la table ci-dessous la liste de vos forfaits.
            <table style="margin-top:10pt; width:80%">
                <tr>
                    <th>Nom</th> <th style="text-align:center;">Tarif (€/mois)</th> <th style="text-align:center;">Promotion</th> <th style="text-align:center;">Téléphone associé</th> <th style="text-align:center;">Forfaits étrangers</th> <th></th>
                </tr>
                <?php
                    $result = $controleur->get_abonnements();
                    while($row = mysqli_fetch_array($result)){
                ?>
                    <tr>
                        <td class="product_name" data-data="<?php echo htmlentities(json_encode($row), ENT_QUOTES, 'UTF-8') ?>"><?php echo $row['nom']?></td>
                        <td style="text-align:center;"><?php echo $row['prix_mensuel']?></td>
                        <td style="text-align:center;"><?php echo ($row['formule_base'] == -1) ? 'Non' : 'Oui' ?></td>
                        <td style="text-align:center;"><?php echo ($row['telephone'] == NULL) ? '-' : 'Oui' ?></td>
                        <td style="text-align:center;"><i class="icon fa fa-globe icon-etranger" data-nom="<?php echo $row['nom']; ?>" data-id="<?php echo $row['id'] ?>" data-forfaits="<?php echo $controleur->get_etrangers($row['id']); ?>" style="float: inherit; color:<?php echo $controleur->get_etrangers($row['id']) == '  ' ? 'crimson' : 'green'; ?>"></i></td>
                        <td>
                            <form class="unsubscribe" style="display:inline" action="<?php $_PHP_SELF ?>" method="post">Désinscrire
                                <input type="hidden" name="form_name" value="form_unsubscribe"/>
                                <input type="hidden" name="id" value="<?php echo $row['id']?>"/>
                            </form>
                        </td>
                </tr>
                <?php } ?>
            </table>

            <table style="margin-top:10pt;">
                <tr>
                    <th>Marque</th> <th>Modèle</th> <th>Prix</th> <th>RAM</th> <th style="text-align:center">Visuel</th>
                </tr>
                    <?php
                        $result = $controleur->get_telephones();
                        while($row = mysqli_fetch_array($result)) {
                    ?>
                    <tr>
                        <td><?php echo $row['marque']?></td>
                        <td><?php echo $row['modele']?></td>
                        <td><?php echo $row['prix'] ?>€</td>
                        <td><?php echo $row['ram']?></td>
                        <td style="text-align:center"><img data-data="<?php echo htmlentities(json_encode($row), ENT_QUOTES, 'UTF-8') ?>" class="image-details" style="height:150px" src="<?php echo $row['photo_url']?>"></td>
                    </tr>
                    <?php
                        }
                    ?>
            </table>


            <div display="none" id="foreign_products" data-foreign-products="<?php $foreigns = array(); $result = $controleur->get_forfaits_etrangers(); while($row = mysqli_fetch_assoc($result)){ $foreigns[] = $row; } echo htmlentities(json_encode($foreigns)); ?>"></div>
        </div>

        <script type="text/javascript">
            $('.icon-etranger').on('click', function(){
                data = this.dataset.forfaits;
                zone_geographiques = JSON.parse($('#foreign_products')[0].dataset.foreignProducts);
                $.each(zone_geographiques, function(key, val){
                   if(data.indexOf(val.id) != -1){
                       zone_geographiques[key].checked = true;
                   } else {
                       zone_geographiques[key].checked = false;
                   }
                });
                create_modal('assoc_foreign_product', 'Forfaits étrangers associés à ' + this.dataset.nom,
                     {}, {}, 'remove', {}, {}, zone_geographiques);
                $('#form_assoc_foreign_product').append('<input type="hidden" name="id" value="' + this.dataset.id + '"/>');
                $('#modal_assoc_foreign_product input').remove();
                $('#modal_assoc_foreign_product').toggle();
            });
        </script>
    </body>
</html>
