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
                        $res = $controleur->update_phone($_POST);
                    } else if($_POST['form_name'] == 'form_new_phone'){
                        $res = $controleur->update_phone($_POST);
                    } else if($_POST['form_name'] == 'form_del_phone'){
                        $res = $controleur->delete_phone($_POST['id']);
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
                        <td style="text-align:center"><img class="image-details" style="height:150px" src="<?php echo $row['photo_url']?>"></td>
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
                    </tr>
                    <?php
                        }
                    ?>
            </table>
            <div id="new_phone" class="next-button quest-button">
                Nouvel appareil
            </div>
        </div>

        <script type="text/javascript">
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
                create_more_details_modal("salut", "Détails du xxx", "phone");
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
