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
                    var_dump($_POST);
                    if($_POST['form_name'] == 'form_new_foreign_product'){
                        $res = $controleur->update_foreign_product($_POST);
                    } else if($_POST['form_name'] == 'form_del_foreign_product'){
                        $res = $controleur->delete_abonnement_etranger($_POST['id']);
                    } else if($_POST['form_name'] == 'form_edit_foreign_product'){
                        var_dump('here');
                        $res = $controleur->update_foreign_product($_POST);
                    }
                }
            ?>

            <br>
            Cliquez sur le nom de l'abonnement pour plus de détails.

            <br>

            <table style="margin-top:10pt; width:80%">
                <tr>
                    <th>Nom</th> <th style="text-align:center;">Bloqué</th> <th style="text-align:center;">Zone géographique</th> <?php if($_SESSION['login_level'] == 'admin') { echo '<th></th>'; } ?>
                </tr>
                <?php
                    $result = $controleur->get_abonnements_etranger();
                    while($row = mysqli_fetch_array($result)) {
                ?>
                    <tr>
                        <td class="product_name" data-data="<?php echo htmlentities(json_encode($row), ENT_QUOTES, 'UTF-8') ?>"><?php echo $row['nom']?></td>
                        <td style="text-align:center;"><?php echo $row['bloque'] == '0' ? 'Non' : 'Oui' ?></td>
                        <td style="text-align:center;"><?php echo $row['zone'] != null ? $controleur->get_zones_geographique($row['zone']) : 'null' ?></td>
                        <?php
                            if ($_SESSION['login_level'] == 'admin') {
                        ?>
                            <td>
                                <div>
                                    <form style="display:inline" action="<?php $_PHP_SELF ?>" method="post">
                                        <input type="hidden" name="form_name" value="form_del_foreign_product"/>
                                        <input type="hidden" name="id" value="<?php echo $row['id'] ?>"/>
                                        <i class="icon fa fa-remove icon-remove"></i>
                                    </form>
                                    <i style="margin-left:5px; color:green" class="icon fa fa-edit icon-edit" data-data="<?php echo htmlentities(json_encode($row), ENT_QUOTES, 'UTF-8') ?>"></i>
                                </div>
                            </td>
                        <?php
                            }
                        ?>
                    </tr>
                <?php } ?>
            </table>
            <?php
                if($_SESSION['login_level'] == 'admin') {
            ?>
                <div id="new_foreign_product" class="next-button quest-button"  >
                    Nouvel abonnement vers l'étranger
                </div>
                <div display="none" id="zones_geographiques" data-zones="<?php $zones = array(); $result = $controleur->get_zones(); while($row = mysqli_fetch_assoc($result)){ $zones[] = $row; } echo htmlentities(json_encode($zones)); ?>"></div>
            <?php

                }
            ?>

            <script type="text/javascript">
                $('.icon-remove').on('click', function(){
                    this.parentNode.submit();
                });

                $('#new_foreign_product').on('click', function(){
                    create_modal('new_foreign_product', 'Créer un forfait étranger',
                         {
                            nom: {label: 'Nom', default: ""},
                            limite_appel: {label: 'Nb heures d\'appel', default: "100"},
                            limite_sms: {label: 'Nb SMS', default: "100"},
                            limite_data: {label: 'Nb Mo Internet', default: "0"},
                            prix_hors_forfait_appel: {label: 'Appels hors forfait (€/min)', default: "0.15"},
                            prix_hors_forfait_sms: {label: 'SMS hors forfait (€/SMS)', default: "0.15"},
                            prix_hors_forfait_data: {label: 'Internet hors forfait (€/Mo)', default: "0.15"},
                        },{
                            bloque: {label: 'Forfait bloqué', checked: 'non'}
                        }, 'remove',{
                            plage_horaire: {label: 'Plages horaires', choices: JSON.parse('[{"id":"all", "nom":"Toute la journée"}, {"id":"day", "nom":"Journée"}, {"id":"morning", "nom":"Matin"}, {"id":"evening",  "nom":"Nuit"}]')},
                            periode_semaine: {label: 'Période semaine', choices: JSON.parse('[{"id":"all_week", "nom":"Toute la semaine"}, {"id":"week", "nom":"Semaine"}, {"id":"week-end", "nom":"Week-end"}]')},
                            zone: {label: 'Zone géographique', choices: JSON.parse($('#zones_geographiques')[0].dataset.zones)}
                        });
                    $('#modal_new_foreign_product').toggle();
                });

                $('.product_name').on('click', function(){
                    data = JSON.parse(this.dataset.data);
                    zone_geographiques = JSON.parse($('#zones_geographiques')[0].dataset.zones);
                    content = "<div style='display:table-row; font-weight:bold;'>Généralités sur le forfait étranger</div>" +
                                "<div style='display:table-row'><div style='display:table-cell'>Nombre de SMS : " + data.limite_sms + " SMS/mois</div><div style='display:table-cell'>Nombre d'heures d'appel : " + data.limite_appel + " h/mois</div></div>" +
                                "<div style='display:table-row;'><div style='display:table-cell'>Forfait Internet : " + data.limite_data + " Mo/mois</div><div style='display:table-cell'>Appels hors forfait : " + data.prix_hors_forfait_appel + " €/min</div></div>" +
                                "<div style='display:table-row;'><div style='display:table-cell'>SMS hors forfait : " + data.prix_hors_forfait_sms + " €/SMS</div><div style='display:table-cell'>Internet hors forfait : " + data.prix_hors_forfait_data + " €/Mo</div></div>" +
                                "<div style='display:table-row;'><div style='display:table-cell'>Forfait bloqué : " + (data.bloque == 0 ? 'Oui' : 'Non') + "</div><div style='display:table-cell'>Zone : " + get_zone_name(data.zone, zone_geographiques) + "</div></div>";

                    create_more_details_modal(content, "Formule " + data.nom, "product");
                });

                $('.icon-edit').on('click', function(){
                    data = JSON.parse(this.dataset.data);
                    create_modal('edit_foreign_product', "Éditer l'abonnement " + data.nom,
                         {
                            nom: {label: 'Nom', default: data.nom},
                            limite_appel: {label: 'Nb heures d\'appel', default: data.limite_appel},
                            limite_sms: {label: 'Nb SMS', default: data.limite_sms},
                            limite_data: {label: 'Nb Mo Internet', default: data.limite_data},
                            prix_hors_forfait_appel: {label: 'Appels hors forfait (€/min)', default: data.prix_hors_forfait_appel},
                            prix_hors_forfait_sms: {label: 'SMS hors forfait (€/SMS)', default: data.prix_hors_forfait_sms},
                            prix_hors_forfait_data: {label: 'Internet hors forfait (€/Mo)', default: data.prix_hors_forfait_data}
                        },{
                            bloque: {label: 'Forfait bloqué', checked: (data.bloque == 1 ? 'oui' : 'non')}
                        }, 'remove',{
                            plage_horaire: {label: 'Plages horaires', choices: JSON.parse('[{"id":"all", "nom":"Toute la journée"}, {"id":"day", "nom":"Journée"}, {"id":"morning", "nom":"Matin"}, {"id":"evening",  "nom":"Nuit"}]'), default: data.plage_horaire},
                            periode_semaine: {label: 'Période semaine', choices: JSON.parse('[{"id":"all_week", "nom":"Toute la semaine"}, {"id":"week", "nom":"Semaine"}, {"id":"week-end", "nom":"Week-end"}]'), default: data.periode_semaine}
                        });
                    $('#modal_edit_foreign_product').toggle();
                });

                var get_zone_name = function(id, jsonset){
                    return_val = '';
                    $.each(jsonset, function(key, val){
                        if(val.id == id){
                            return_val = val.nom;
                        }
                    });
                    return return_val;
                }
            </script>
        </div>
    </body>
</html>
