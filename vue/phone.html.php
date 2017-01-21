<html>
	<head>
		<title><?= $title ?></title>
		<meta http-equiv="Content-Type" content="text/html" charset="utf8">
	</head>

	<body>
        <div id="inner_content">
            <?php
                if(!empty($_POST['form_name'])){
                    if($_POST['form_name'] == 'form_edit_phone'){
                        $controleur->update_phone($_POST);
                    } else if($_POST['form_name'] == 'form_new_phone'){
                        $controleur->update_phone($_POST);
                    } else if($_POST['form_name'] == 'form_del_phone'){
                        $controleur->delete_phone($_POST['id']);
                    } else if($_POST['form_name'] == 'form_buy_phone'){
                        $controleur->buy_phone($_POST['id']);
                    }
                }
            ?>

            <div id="main_header"><?= $title ?></div>
            <div id="main_subheader"><?= $subtitle ?></div>

            <br>
            Cliquez sur les images pour plus de détails sur les téléphones.

            <table style="margin-top:10pt;">
                <tr>
                    <th>Marque</th> <th>Modèle</th> <th>Prix</th> <th>RAM</th> <th style="text-align:center">Visuel</th> <th></th>
                </tr>
                    <?php
                        $result = $controleur->get_all_phones();
                        while($row = mysqli_fetch_array($result)) {
                    ?>
                    <tr>
                        <td><?php echo $row['marque']?></td>
                        <td><?php echo $row['modele']?></td>
                        <td><?php echo $row['prix'] ?>€</td>
                        <td><?php echo $row['ram']?></td>
                        <td style="text-align:center"><img data-data="<?php echo htmlentities(json_encode($row), ENT_QUOTES, 'UTF-8') ?>" class="image-details" style="height:150px" src="<?php echo $row['photo_url']?>"></td>
                        <?php
                            if ($_SESSION['login_level'] == 'admin') {
                        ?>
                            <td>
                                <div>
                                    <form style="display:inline" action="<?php $_PHP_SELF ?>" method="post">
                                        <input type="hidden" name="form_name" value="form_del_phone"/>
                                        <input type="hidden" name="id" value="<?php echo $row['idtelephone'] ?>"/>
                                        <i class="icon fa fa-remove icon-remove"></i>
                                    </form>
                                    <i style="margin-left:5px; color:green" class="icon fa fa-edit icon-edit" data-data="<?php echo htmlentities(json_encode($row), ENT_QUOTES, 'UTF-8') ?>"></i>
                                </div>
                            </td>
                        <?php
                            } else {
                        ?>
                            <td data-id="<?php echo $row['idtelephone'] ?>" data-nom="<? php echo $row['marque'].' '.$row['modele'] ?>" class="buy_phone">Acheter</td>
                        <?php } ?>
                    </tr>
                    <?php
                        }
                    ?>
            </table>

            <?php
                if($_SESSION['login_level'] == 'admin') {
            ?>
                <div id="new_phone" class="next-button quest-button">
                    Nouvel appareil
                </div>
            <?php
                }
            ?>
        </div>

        <script type="text/javascript">
            $('.buy_phone').on('click', function(){
                $(document.body).append(
                    '<div class="modal" id="modal_buy_phone">' +
                        '<div class="modal-content">' +
                        '<h1 class="modal-title">Acheter le ' + this.dataset.nom + '</h1>' +
                        '<hr class="modal-row"/>' +
                        '<form action="" method="post" id="form_buy_phone">' +
                            'Voulez-vous acheter ce téléphone?' +
                            '<input type="hidden" name="form_name" value="form_buy_phone"/>' +
                            '<input type="hidden" name="id" value="' + this.dataset.id + '"/>' +
                            '<hr class="modal-row"/>' +
                            '<div class="modal-button">' +
                                '<div id="ok_form_buy_phone" class="modal-button modal-ok">OK</div>' +
                                '<div id="cancel_form_buy_phone" class="modal-button modal-cancel">Annuler</div>' +
                            '</div>' +
                        '</form>' +
                        '</div>' +
                    '</div>'
                );
                $('#cancel_form_buy_phone').on('click', function(){
                    $('#modal_buy_phone').remove();
                })
                $('#ok_form_buy_phone').on('click', function(){
                    $('#form_buy_phone').submit();
                })
                $('#modal_buy_phone').toggle();
            });

            create_modal('new_phone', 'Créer un téléphone',
             {
                marque: {label: 'Marque', default: ""},
                model: {label: 'Modèle', default: ""},
                ecran: {label: 'Écran', default: ""},
                appareil_photo: {label: 'Appareil photo', default: ""},
                video_numerique: {label: 'Vidéo numérique', default: ""},
                capacite_internet: {label: 'Internet', default: ""},
                photo_url: {label: 'URL image', default: ""},
                prix: {label: 'Prix', default: ""},
                ram: {label: 'RAM', default: ""},
                stockage: {label: 'Stockage', default: ""},
            },{
                carte_sd: {label: 'Carte SD', checked: 'non'},
                double_sim: {label: 'Double SIM', checked: 'non'},
                tv: {label: 'TV', checked: 'non'}
            }, 'reset');

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

            /* Pour la suppression d'un téléphone */
            $('.icon-remove').on('click', function(){
                this.parentNode.submit();
            });

            $('.icon-edit').on('click', function(){
                data = JSON.parse(this.dataset.data);
                create_modal('edit_phone', 'Modifier le téléphone',
                             {
                                marque: {label: 'Marque', default: data.marque},
                                model: {label: 'Modèle', default: data.modele},
                                ecran: {label: 'Écran', default: data.ecran},
                                appareil_photo: {label: 'Appareil photo', default: data.appareil_photo},
                                video_numerique: {label: 'Vidéo numérique', default: data.video_numerique},
                                capacite_internet: {label: 'Internet', default: data.capacite_internet},
                                photo_url: {label: 'URL image', default: data.photo_url},
                                prix: {label: 'Prix', default: data.prix},
                                ram: {label: 'RAM', default: data.ram},
                                stockage: {label: 'Stockage', default: data.stockage},
                            },{
                                carte_sd: {label: 'Carte SD', checked: (data.carte_sd == 1 ? 'oui' : 'non')},
                                double_sim: {label: 'Double SIM', checked: (data.double_sim == 1 ? 'oui' : 'non')},
                                tv: {label: 'TV', checked: (data.tv == 1 ? 'oui' : 'non')}
                            }, 'remove');
                $('#modal_edit_phone').toggle();
            });
        </script>
    </body>
</html>
