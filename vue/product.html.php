<html>
	<head>
		<title><?= $title ?></title>
		<meta http-equiv="Content-Type" content="text/html" charset="utf8">
	</head>

	<body>
        <div id="inner_content">
            <div id="main_header"><?= $title ?></div>
            <div id="main_subheader"><?= $subtitle ?></div>

            <?php
                if(!empty($_POST['form_name'])){
                    if($_POST['form_name'] == 'form_new_product'){
                        $controleur->update_product($_POST);
                    } else if($_POST['form_name'] == 'form_del_product'){
                        $controleur->delete_abonnement($_POST['id']);
                    } else if($_POST['form_name'] == 'form_edit_product'){
                        $controleur->update_product($_POST);
                    } else if($_POST['form_name'] == 'form_assoc_foreign_product'){
                        $controleur->assoc_foreign_product($_POST);
                    } else if($_POST['form_name'] == 'form_filter'){
                        $controleur->filter_result($_POST);
                    } else if($_POST['form_name'] == 'form_subscribe'){
                        $controleur->subscribe($_POST['id']);
                    } else if($_POST['form_name'] == 'form_unsubscribe'){
                        $controleur->unsubscribe($_POST['id']);
                    } else if($_POST['form_name'] == 'form_assoc_telephone'){
                        $controleur->assoc_telephone($_POST);
                    }
                }
            ?>

            <br>
            Cliquez sur le nom de l'abonnement pour plus de détails.

            <br>

            <div id="want_choices" style="width:100%;">
                Vos filtres :
                <br>
                <form id="form_search" action="<?php $_PHP_SELF ?>" method="post">
                    <div style="margin-left: 10%; width:90%">
                        <div style="margin-left:20pt; display:table-row">
                            <div style="width:25%; display:table-cell"><input style="width:20px" type="checkbox" id="want_abonnements" checked name="abonnements">Abonnements</div>
                            <div style="width:25%; display:table-cell"><input style="width:20px" type="checkbox" id="want_promotions" checked name="promotions">Promotions</div>
                        </div>
                        <div style="margin-left:20pt; display:table-row">
                            <div style="width:40%; display:table-cell">Prix minimum : <input style="width:100px" type="text" name="min_price">€/mois</div>
                            <div style="width:40%; display:table-cell">Prix maximum : <input style="width:100px" type="text" name="max_price">€/mois</div>
                        </div>
                        <input type="hidden" name="form_name" value="form_filter"/>
                        <div id="search" style="position:inherit; margin-top:10px; margin-bottom:30px" class="modal-button modal-ok">Chercher</div>
                    </div>
                </form>
            </div>

            <table style="margin-top:10pt; width:80%">
                <tr>
                    <th>Nom</th> <th style="text-align:center;">Tarif (€/mois)</th> <th style="text-align:center;">Promotion</th> <th style="text-align:center;">Téléphone associé</th> <th style="text-align:center;">Forfaits étrangers</th> <th></th>
                </tr>
                <?php
                    $subscribed = null;
                    if($_SESSION['log_in'] && !$_SESSION['login_level']){
                        $subscribed_ = $controleur->getSubscription($_SESSION['usr_mail']);
                        if($subscribed_ != null){
                            $subscribed = array();
                            while($row = mysqli_fetch_array($subscribed_))
                            { $subscribed[] = $row['id_formule']; }
                        }
                    }
                    $result = $controleur->get_abonnements(true, true);
                    while($row = mysqli_fetch_array($result)){
                        $assoc_foreign_products = $controleur->get_etrangers($row['id']);
                        $assoc_foreign_array = array();
                        while($row_ = mysqli_fetch_array($assoc_foreign_products))
                        { $assoc_foreign_array[] = $row_['forfait_etranger']; }

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
                        <td style="text-align:center;"><i class="icon fa fa-globe icon-etranger" data-nom="<?php echo $row['nom']; ?>" data-id="<?php echo $row['id'] ?>" data-forfaits="<?php echo htmlentities(json_encode($assoc_foreign_array)); ?>" style="float: inherit; color:<?php echo $assoc_foreign_products->num_rows == 0 ? 'crimson' : 'green'; ?>"></i></td>
                        <?php if ($_SESSION['login_level'] == 'admin') { ?>
                            <td>
                                <div>
                                    <form style="display:inline" action="<?php $_PHP_SELF ?>" method="post">
                                        <input type="hidden" name="form_name" value="form_del_product"/>
                                        <input type="hidden" name="id" value="<?php echo $row['id'] ?>"/>
                                        <i class="icon fa fa-remove icon-remove"></i>
                                    </form>
                                    <i style="margin-left:5px; color:green" class="icon fa fa-edit icon-edit" data-data="<?php echo htmlentities(json_encode($row), ENT_QUOTES, 'UTF-8') ?>"></i>
                                </div>
                            </td>
                        <?php } else if($_SESSION['log_in'] && !$_SESSION['login_level']){ ?>
                            <td>
                                <?php if($subscribed == null || (!is_numeric(array_search($row['id'], $subscribed)))){ ?>
                                    <form class="subscribe" style="display:inline" action="<?php $_PHP_SELF ?>" method="post">
                                        Souscrire
                                <?php } else {?>
                                    <form class="unsubscribe" style="display:inline" action="<?php $_PHP_SELF ?>" method="post">
                                        Désinscrire
                                <?php } ?>
                                <input type="hidden" name="form_name" value="form_unsubscribe"/>
                                <input type="hidden" name="id" value="<?php echo $row['id']?>"/>
                                </form>
                            </td>
                        <?php } ?>
                    </tr>
                <?php } ?>
            </table>
            <div display="none" id="basic_products" data-basic-products="<?php $products = array(); $products[]=array("id" => "-1", "nom" => "Aucune"); $result = $controleur->get_basics_abonnements(); while($row = mysqli_fetch_assoc($result)){ $products[] = $row; } echo htmlentities(json_encode($products)); ?>"></div>
            <div display="none" id="foreign_products" data-foreign-products="<?php $foreigns = array(); $result = $controleur->get_forfaits_etrangers(); while($row = mysqli_fetch_assoc($result)){ $foreigns[] = $row; } echo htmlentities(json_encode($foreigns)); ?>"></div>
            <div display="none" id="phones" data-phones="<?php $foreigns = array(); $result = $controleur->get_phones(); while($row = mysqli_fetch_assoc($result)){ $phones[] = $row; } echo htmlentities(json_encode($phones)); ?>"></div>
            <?php
                if($_SESSION['login_level'] == 'admin') {
            ?>
                <div id="new_product" class="next-button quest-button">
                    Nouvel abonnement
                </div>
            <?php
                }
            ?>

            <script type="text/javascript">
                <?php if($_SESSION['login_level'] != 'admin'){ ?>
                    $('.icon-etranger').on('click', function(){
                        data = this.dataset.forfaits;
                        zone_geographiques_ = JSON.parse($('#foreign_products')[0].dataset.foreignProducts);
                        console.log(zone_geographiques_);
                        zone_geographiques = {};
                        $.each(zone_geographiques_, function(key, val){
                           if(data.indexOf(val.id) != -1){
                               zone_geographiques[key] = val;
                           }
                        });
                        create_modal('assoc_foreign_product', 'Forfaits étrangers associés à ' + this.dataset.nom,
                             {}, {}, 'remove', {}, {}, zone_geographiques);
                        $('#form_assoc_foreign_product').append('<input type="hidden" name="id" value="' + this.dataset.id + '"/>');
                        $('#modal_assoc_foreign_product input').remove();
                        $('#modal_assoc_foreign_product').toggle();
                    });
                <?php } else { ?>
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
                        $('#modal_assoc_foreign_product').toggle();
                    });
                <?php } ?>

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

                var get_prix_from_formule_base = function(id, jsonset){
                    return_val = '';
                    $.each(jsonset, function(key, val){
                        if(val.id == id){
                            return_val = val.prix_mensuel;
                        }
                    });
                    return return_val;
                }

                var get_nom_from_formule_base = function(id, jsonset){
                    return_val = '';
                    $.each(jsonset, function(key, val){
                        if(val.id == id){
                            return_val = val.nom;
                        }
                    });
                    return return_val;
                }

                $('#new_product').on('click', function(){
                    data = JSON.parse($('#basic_products')[0].dataset.basicProducts);
                    create_modal('new_product', 'Créer un abonnement',
                         {
                            nom: {label: 'Nom', default: ""},
                            prix_mensuel: {label: 'Prix mensuel', default: "10"},
                            limite_appel: {label: 'Nb heures d\'appel', default: "100"},
                            limite_sms: {label: 'Nb SMS', default: "100"},
                            limite_data: {label: 'Nb Mo Internet', default: "0"},
                            prix_hors_forfait_appel: {label: 'Appels hors forfait (€/min)', default: "0.15"},
                            prix_hors_forfait_sms: {label: 'SMS hors forfait (€/SMS)', default: "0.15"},
                            prix_hors_forfait_data: {label: 'Internet hors forfait (€/Mo)', default: "0.15"},
                            prix_base: {label: 'Prix avant réduction', default: "-1"}
                        },{
                            bloque: {label: 'Forfait bloqué', checked: 'non'}
                        }, 'remove',{
                            formule_base: {label: 'Formule de base', choices: data},
                            plage_horaire: {label: 'Plages horaires', choices: JSON.parse('[{"id":"all", "nom":"Toute la journée"}, {"id":"day", "nom":"Journée"}, {"id":"morning", "nom":"Matin"}, {"id":"evening",  "nom":"Nuit"}]')},
                            periode_semaine: {label: 'Période semaine', choices: JSON.parse('[{"id":"all_week", "nom":"Toute la semaine"}, {"id":"week", "nom":"Semaine"}, {"id":"week-end", "nom":"Week-end"}]')}
                        },{
                            date_debut: {label: 'Date de début', default: ''},
                            date_fin: {label: 'Date de fin', default: ''}
                    });
                    $('#modal_new_product').toggle();
                });

                $('.icon-edit').on('click', function(){
                    data = JSON.parse(this.dataset.data);
                    data_basic_products = JSON.parse($('#basic_products')[0].dataset.basicProducts);
                    create_modal('edit_product', "Éditer l'abonnement " + data.nom,
                         {
                            nom: {label: 'Nom', default: data.nom},
                            prix_mensuel: {label: 'Prix mensuel', default: data.prix_mensuel},
                            limite_appel: {label: 'Nb heures d\'appel', default: data.limite_appel},
                            limite_sms: {label: 'Nb SMS', default: data.limite_sms},
                            limite_data: {label: 'Nb Mo Internet', default: data.limite_data},
                            prix_hors_forfait_appel: {label: 'Appels hors forfait (€/min)', default: data.prix_hors_forfait_appel},
                            prix_hors_forfait_sms: {label: 'SMS hors forfait (€/SMS)', default: data.prix_hors_forfait_sms},
                            prix_hors_forfait_data: {label: 'Internet hors forfait (€/Mo)', default: data.prix_hors_forfait_data},
                            prix_base: {label: 'Prix avant réduction', default: data.prix_base}
                        },{
                            bloque: {label: 'Forfait bloqué', checked: (data.bloque ? 'oui' : 'non')}
                        }, 'remove',{
                            formule_base: {label: 'Formule de base', choices: data_basic_products, default: data.formule_base},
                            plage_horaire: {label: 'Plages horaires', choices: JSON.parse('[{"id":"all", "nom":"Toute la journée"}, {"id":"day", "nom":"Journée"}, {"id":"morning", "nom":"Matin"}, {"id":"evening",  "nom":"Nuit"}]'), default: data.plage_horaire},
                            periode_semaine: {label: 'Période semaine', choices: JSON.parse('[{"id":"all_week", "nom":"Toute la semaine"}, {"id":"week", "nom":"Semaine"}, {"id":"week-end", "nom":"Week-end"}]'), default: data.periode_semaine}
                        },{
                            date_debut: {label: 'Date de début', default: data.date_debut},
                            date_fin: {label: 'Date de fin', default: data.date_fin}
                    });
                    $('#modal_edit_product').toggle();
                });

                $('.icon-phone').on('click', function(){
                    phones = JSON.parse($('#phones')[0].dataset.phones);
                    data = this.dataset.phones;
                    $.each(phones, function(key, val){
                       if(data.indexOf(val.id) != -1){
                           phones[key].checked = true;
                       } else {
                           phones[key].checked = false;
                       }
                    });
                    create_modal('assoc_telephone', 'Téléphone associé à ' + this.dataset.nom,
                         {}, {}, 'remove', {}, {}, phones);
                    $('#form_assoc_telephone').append('<input type="hidden" name="id" value="' + this.dataset.id + '"/>');
                    $('#modal_assoc_telephone').toggle();
                })

                $('#search').on('click', function(){
                    $('#form_search').submit();
                })

                $('.icon-remove').on('click', function(){
                    this.parentNode.submit();
                })

                $('.subscribe').on('click', function(){
                    this.submit();
                })

                $('.unsubscribe').on('click', function(){
                    this.submit();
                })
            </script>
        </div>
    </body>
</html>
