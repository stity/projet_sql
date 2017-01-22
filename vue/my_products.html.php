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
                    <th>Nom</th> <th style="text-align:center;">Tarif (€/mois)</th> <th style="text-align:center;">Promotion</th> <th style="text-align:center;">Téléphone associé</th> <th style="text-align:center;">Forfaits étrangers</th>
                </tr>
                <?php
                    $result = $controleur->get_abonnements();
                    while($row = mysqli_fetch_array($result)){

                        $assoc_phones = $controleur->get_assoc_phones($row['id']);
                        $assoc_phones_array = array();
                        while($row_ = mysqli_fetch_array($assoc_phones))
                        { $assoc_phones_array[] = $row_['telephone']; }
                ?>
                    <tr>
                        <td class="product_name" data-data="<?php echo htmlentities(json_encode($row), ENT_QUOTES, 'UTF-8') ?>"><?php echo $row['nom']?></td>
                        <td style="text-align:center;"><?php echo $row['prix_mensuel']?></td>
                        <td style="text-align:center;"><?php echo ($row['formule_base'] == -1) ? 'Non' : 'Oui' ?></td>
                        <td style="text-align:center;"><i class="icon fa fa-mobile-phone icon-phone" data-nom="<?php echo $row['nom']; ?>" data-id="<?php echo $row['id'] ?>" data-phones="<?php echo htmlentities(json_encode($assoc_phones_array)); ?>" style="float: inherit; color:<?php echo $assoc_phones->num_rows == 0 ? 'crimson' : 'green'; ?>"></i></td>
                        <td style="text-align:center;"><i class="icon fa fa-globe icon-etranger" data-nom="<?php echo $row['nom']; ?>" data-id="<?php echo $row['id'] ?>" data-forfaits="<?php echo $controleur->get_etrangers($row['id']); ?>" style="float: inherit; color:<?php echo $controleur->get_etrangers($row['id']) == '  ' ? 'crimson' : 'green'; ?>"></i></td>
                    </tr>
                <?php } ?>
            </table>
            <br/>
            Et ici la liste de tous les téléphones achetés auprès de nos services :

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
            <div display="none" id="basic_products" data-basic-products="<?php $products = array(); $products[]=array("id" => "-1", "nom" => "Aucune"); $result = $controleur->get_basics_abonnements(); while($row = mysqli_fetch_assoc($result)){ $products[] = $row; } echo htmlentities(json_encode($products)); ?>"></div>
            <div display="none" id="foreign_products" data-foreign-products="<?php $foreigns = array(); $result = $controleur->get_forfaits_etrangers(); while($row = mysqli_fetch_assoc($result)){ $foreigns[] = $row; } echo htmlentities(json_encode($foreigns)); ?>"></div>
            <div display="none" id="phones" data-phones="<?php $foreigns = array(); $result = $controleur->get_phones(); while($row = mysqli_fetch_assoc($result)){ $phones[] = $row; } echo htmlentities(json_encode($phones)); ?>"></div>
        </div>
    </body>
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
            $('#modal_assoc_foreign_product .modal-ok').remove();
            $('#modal_assoc_foreign_product .modal-cancel').html('OK');
            $('#modal_assoc_foreign_product .modal-cancel').css('background-color', 'green');
            $('#modal_assoc_foreign_product .modal-cancel').css('margin-right', '0px');
            $('#modal_assoc_foreign_product').toggle();
        });

        $('.icon-phone').on('click', function(){
            phones_ = JSON.parse($('#phones')[0].dataset.phones);
            phones = {};
            data = this.dataset.phones;
            $.each(phones_, function(key, val){
               if(data.indexOf(val.id) != -1){
                   phones[key] = val;
               }
            });
            create_modal('assoc_telephone', 'Téléphone associé à ' + this.dataset.nom,
                 {}, {}, 'remove', {}, {}, phones);
            $('#form_assoc_telephone').append('<input type="hidden" name="id" value="' + this.dataset.id + '"/>');
            $('#modal_assoc_telephone .modal-ok').remove();
            $('#modal_assoc_telephone .modal-cancel').html('OK');
            $('#modal_assoc_telephone .modal-cancel').css('background-color', 'green');
            $('#modal_assoc_telephone .modal-cancel').css('margin-right', '0px');
            $('#form_assoc_telephone input').remove();
            $('#modal_assoc_telephone').toggle();
        });

        $('.image-details').on('click', function(){
            data = JSON.parse(this.dataset.data);
            content = "<div style='display:table-cell; vertical-align:middle;'><img style='height:150px' src='" + data.photo_url + "'></div>" +
            "<div style='display:table-cell;'><ul>"+
                "<li>Prix : " + data.prix + "€</li>" +
                "<li>Écran : " + data.ecran + "</li>" +
                "<li>Appareil photo : " + data.appareil_photo + "</li>" +
                "<li>Vidéo numérique : " + data.video_numerique + "</li>" +
                "<li>Internet : " + data.capacite_internet + "</li>" +
                "<li>RAM : " + data.ram + "</li>" +
                "<li>Stockage : " + data.stockage + "</li>" +
                "<li>Carte SD : " + (data.carte_sd == 1 ? 'Oui' : 'Non') + "</li>" +
                "<li>Double SIM : " + (data.double_sim == 1 ? 'Oui' : 'Non') + "</li>" +
                "<li>TV : " + (data.tv == 1 ? 'Oui' : 'Non') + "</li>" +
            "</ul></div>";

            create_more_details_modal(content, "Détails du " + data.marque + ' ' + data.modele, "phone");
        });

        $('.product_name').on('click', function(){
            data = JSON.parse(this.dataset.data);
            data_basic = JSON.parse($('#basic_products')[0].dataset.basicProducts);
            content = "<div style='display:table-row; font-weight:bold;'>Généralités sur la formule</div>" +
                        "<div style='display:table-row;'><div style='display:table-cell; width:50%'>Prix : " + data.prix_mensuel + "€/mois</div><div style='display:table-cell'>Nombre d'heures d'appel : " + data.limite_appel + " h/mois</div></div>" +
                        "<div style='display:table-row;'><div style='display:table-cell'>Nombre de SMS : " + data.limite_sms + " SMS/mois</div><div style='display:table-cell'>Forfait Internet : " + data.limite_data + " Mo/mois</div></div>" +
                        "<div style='display:table-row;'><div style='display:table-cell'>Appels hors forfait : " + data.prix_hors_forfait_appel + " €/min</div><div style='display:table-cell'>SMS hors forfait : " + data.prix_hors_forfait_sms + " €/SMS</div></div>" +
                        "<div style='display:table-row;'><div style='display:table-cell'>Internet hors forfait : " + data.prix_hors_forfait_data + " €/Mo</div><div style='display:table-cell'>Forfait bloqué : " + data.bloque + "</div></div>" +
                        "<hr style='width:50%'><div style='display:table-row; margin-top:60px; font-weight:bold;'>Caractéristiques promotionnelles</div>" +
                        "<div style='display:table-row;'><div style='display:table-cell; width:50%;'>Prix de base : " + (data.prix_base == -1 ? (data.formule_base == -1 ? '-' : get_prix_from_formule_base(data.formule_base, data_basic) + " €/mois") : data.prix_base + ' €/mois') + "</div><div style='display:table-cell'>Formule de base : " + (data.formule_base == -1 ? '-' : get_nom_from_formule_base(data.formule_base, data_basic)) + "</div></div>" +
                        "<div style='display:table-row;'><div style='display:table-cell'>Début promotion : " + (data.date_debut == null ? '-' : data.date_debut) + "</div><div style='display:table-cell'>Fin promotion : " + (data.date_fin == null ? '-' : data.date_fin) + "</div></div>";

            create_more_details_modal(content, "Formule " + data.nom, "product");
        });
    </script>
</html>
