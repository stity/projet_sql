<html>
	<head>
		<title><?= $title ?></title>
		<meta http-equiv="Content-Type" content="text/html" charset="utf8">
	</head>

	<body>
        <div id="inner_content">
        <?php
            $new = false;
            $del = false;
            $new_ok = false;
            $del_ok = false;
            if(!empty($_POST['form_name'])){
                if($_POST['form_name'] == 'form_new_user'){
                    $res = $controleur->create_new_user($_POST['nom'], $_POST['mail'], $_POST['adresse']);
                    $new = true;
                    $new_ok = ($res != 'error');
                } else if($_POST['form_name'] == 'form_del_user'){
                    $res = $controleur->delete_user($_POST['id']);
                    $del = true;
                    $del_ok = ($res != 'error');
                }
            }
        ?>
        <div id="main_header"><?= $title ?></div>
        <!--<div id="sub_header"><?= $subtitle ?></div>-->

        <?php
            if($new){
        ?>
                <div id="notification_new" class="<?php echo $new_ok ? 'notif-ok' : 'notif-pb' ?>">
                    <div class="notif-content">
                        <?php
                            echo $new_ok ? "Le client a bien été ajouté à la base de données." : "Une erreur est survenue dans l'ajout, veuillez-réessayer.";
                        ?>
                    </div>
                    <div class="notif-close">
                        <i class="icon fa fa-remove"></i>
                    </div>
                </div>
        <?php
            }
        ?>

        <?php
            if($del){
        ?>
            <div id="notification_del" class="<?php echo $del_ok ? 'notif-ok' : 'notif-pb' ?>">
                <div class="notif-content">
                        <?php
                            echo $del_ok ? "Le client a bien été retiré de la base de données." : "Une erreur est survenue dans la suppression, veuillez-réessayer.";
                        ?>
                </div>
                <div class="notif-close">
                    <i class="icon fa fa-remove"></i>
                </div>
            </div>
        <?php
            }
        ?>

        <div>
            En tant qu'administrateur de la plateforme, vous pouvez supprimer les différents comptes des clients ou éditer leurs propriétés.
        </div>

        <table style="margin-top:10pt;">
            <tr>
                <th>Nom</th> <th>Mail</th> <th>Adresse</th> <th>Mot de passe</th> <th></th>
                <?php
                    $result = $controleur->get_all_users();
                    while($row = mysqli_fetch_array($result)) {
                ?>
                <tr>
                    <td><?php echo $row['nom']?></td>
                    <td><?php echo $row['mail']?></td>
                    <td><?php echo $row['adresse']?></td>
                    <td><?php echo $row['mot_de_passe']?></td>
                    <td>
                        <form action="<?php $_PHP_SELF ?>" method="post">
                            <input type="hidden" name="form_name" value="form_del_user"/>
                            <input type="hidden" name="id" value="<?php echo $row['idutilisateur'] ?>"/>
                            <i class="icon fa fa-remove icon-remove"></i>
                        </form>
                    </td>
                </tr>
                <?php
                    }
                ?>
            </tr>
        </table>
        <div id="new_user" class="next-button quest-button">
            Nouvel utilisateur
        </div>
        <div class="modal">
            <div class="modal-content">
            <h1 class="modal-title">Créer un nouvel utilisateur</h1>
            <hr class="modal-row"/>
            <form action="<?php $_PHP_SELF ?>" method="post" id="form_new_user">
                <div style="display:table-row"><p class="form-label">Nom : </p><input type="text" name="nom" /></div>
                <div style="display:table-row"><p class="form-label">Mail : </p><input type="text" name="mail" /></div>
                <div style="display:table-row"><p class="form-label">Adresse : </p><input type="text" name="adresse" /></div>
                <input type="hidden" name="form_name" value="form_new_user"/>
                <hr class="modal-row"/>
                <div class="modal-button">
                    <input id="__ok_new_user" type="submit" value="OK" style="display:none">
                    <div id="ok_new_user" class="modal-button modal-ok">OK</div>
                    <div id="cancel_new_user" class="modal-button modal-cancel">Annuler</div>
                </div>
            </form>
            </div>
        </div>
        </div>
    </body>

    <script type="text/javascript">
        $('#new_user').on('click', function(){
            $('.modal').toggle();
        });

        $('#cancel_new_user').on('click', function(){
            $('#form_new_user input').val('');
            $('.modal').toggle();
        });

        $('#ok_new_user').on('click', function(){
            $('#__ok_new_user').click();
        });

        $('.icon-remove').on('click', function(){
            this.parentNode.submit();
        });

        $('.notif-close').on('click', function(){
            $(this.parentNode).toggle();
        });
    </script>
</html>
