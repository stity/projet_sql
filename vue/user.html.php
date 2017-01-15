<html>
	<head>
		<title><?= $title ?></title>
		<meta http-equiv="Content-Type" content="text/html" charset="utf8">
	</head>

	<body>
        <div id="inner_content">
        <div id="main_header"><?= $title ?></div>
        <div id="sub_header"><?= $subtitle ?></div>

        <?php
            $new = false;
            $del = false;
            $edit = false;
            $new_ok = false;
            $del_ok = false;
            $edit_ok = false;
            if(!empty($_POST['form_name'])){
                if($_POST['form_name'] == 'form_new_user'){
                    $res = $controleur->create_new_user($_POST['nom'], $_POST['mail'], $_POST['adresse'], $_POST['is_admin']);
                    $new = true;
                    $new_ok = ($res != 'error');
                } else if($_POST['form_name'] == 'form_del_user'){
                    $res = $controleur->delete_user($_POST['id']);
                    $del = true;
                    $del_ok = ($res != 'error');
                } else if($_POST['form_name'] == 'form_edit_user'){
                    $is_admin = array_key_exists('is_admin', $_POST) ? $_POST['is_admin'] : 'non';
                    $res = $controleur->update_user($_POST['nom'], $_POST['mail'], $_POST['adresse'], $_POST['mdp'], $is_admin);
                    $edit = true;
                    $edit_ok = ($res != 'error');
                }
            }
        ?>

        <?php
            if($_SESSION['log_in'] && $_SESSION['login_level']){
        ?>

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
            if($edit){
        ?>
                <div id="notification_edit" class="<?php echo $edit_ok ? 'notif-ok' : 'notif-pb' ?>">
                    <div class="notif-content">
                        <?php
                            echo $edit_ok ? "Le client a bien été mis à jour." : "Une erreur est survenue lors de la mise à jour, veuillez-réessayer.";
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
                <th>Nom</th> <th>Mail</th> <th>Adresse</th> <th>Mot de passe</th> <th>Administrateur</th> <th></th>
                <?php
                    $result = $controleur->get_all_users();
                    while($row = mysqli_fetch_array($result)) {
                ?>
                <tr>
                    <td><?php echo $row['nom']?></td>
                    <td><?php echo $row['mail']?></td>
                    <td><?php echo $row['adresse']?></td>
                    <td><?php echo $row['mot_de_passe']?></td>
                    <td style="text-align:center"><?php echo $row['admin'] ? 'oui' : '' ?></td>
                    <td>
                        <div>
                            <form style="display:inline" action="<?php $_PHP_SELF ?>" method="post">
                                <input type="hidden" name="form_name" value="form_del_user"/>
                                <input type="hidden" name="id" value="<?php echo $row['idutilisateur'] ?>"/>
                                <i class="icon fa fa-remove icon-remove"></i>
                            </form>
                            <i style="margin-left:5px; color:green" class="icon fa fa-edit icon-edit" data-name="<?php echo $row['nom']?>" data-mail="<?php echo $row['mail']?>" data-adresse="<?php echo $row['adresse']?>" data-admin="<?php echo $row['admin'] ?>"></i>
                        </div>
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
        <div class="modal" id="modal_new_user">
            <div class="modal-content">
            <h1 class="modal-title">Créer un nouvel utilisateur</h1>
            <hr class="modal-row"/>
            <form action="<?php $_PHP_SELF ?>" method="post" id="form_new_user">
                <div style="display:table-row"><p class="form-label">Nom : </p><input type="text" name="nom" /></div>
                <div style="display:table-row"><p class="form-label">Mail : </p><input type="text" name="mail" /></div>
                <div style="display:table-row"><p class="form-label">Adresse : </p><input type="text" name="adresse" /></div>
                <div style="display:table-row"><p class="form-label">Administrateur : </p>
                    <div style="display:inline; margin-right:20px"><input class="radio-btn" type="radio" name="is_admin" value="oui">Oui</div>
                    <div style="display:inline"><input class="radio-btn" type="radio" name="is_admin" value="non" checked>Non</div>
                </div>
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

        <script type="text/javascript">
            /* Modale pour créer un utilisateur */
            $('#new_user').on('click', function(){
                $('#modal_new_user').toggle();
            });

            $('#cancel_new_user').on('click', function(){
                $('#form_new_user input').val('');
                $('#modal_new_user').toggle();
            });

            $('#ok_new_user').on('click', function(){
                $('#__ok_new_user').click();
            });

            /* Modale pour éditer un utilisateur */
            $('.icon-edit').on('click', function(){
                document.getElementById('update_name').value = this.dataset.name;
                document.getElementById('update_adresse').value = this.dataset.adresse;
                document.getElementById('update_mail').value = this.dataset.mail;
                console.log(this.dataset.admin == 1);
                if(this.dataset.admin == 1) {
                    $('#update_no_admin').prop('checked',false);
                    $('#update_yes_admin').prop('checked',true);
                } else {
                    $('#update_no_admin').prop('checked',true);
                    $('#update_yes_admin').prop('checked',false);
                }
                $('#modal_edit_user').toggle();
            });

            /* Pour la suppression d'utilisateur */
            $('.icon-remove').on('click', function(){
                this.parentNode.submit();
            });

            /* Pour ferme les notifications */
            $('.notif-close').on('click', function(){
                $(this.parentNode).toggle();
            });
        </script>
        <?php
            } else if($_SESSION['log_in']) {
                $user = mysqli_fetch_array($controleur->get_user_from_mail());
        ?>

        <div style="width:50%">
            <div>Nom : <?php echo $user['nom']?></div>
            <div>Mail : <?php echo $user['mail']?></div>
            <div>Adresse : <?php echo $user['adresse']?></div>
            <div>Mot de passe : <?php echo preg_replace('/. */', '*', $user['mot_de_passe'])?></div>
            <div id="edit_user" class="next-button quest-button" data-name="<?php echo $user['nom']?>" data-mail="<?php echo $user['mail']?>" data-adresse="<?php echo $user['adresse']?>">
                Éditer
            </div>
        </div>

        <script type="text/javascript">
            $('#edit_user').on('click', function(){
                document.getElementById('update_name').value = this.dataset.name;
                document.getElementById('update_adresse').value = this.dataset.adresse;
                document.getElementById('update_mail').value = this.dataset.mail;
                $('#modal_edit_user').toggle();
            });
        </script>

        <?php
            } else if(!$_SESSION['log_in']){
        ?>
            <div id="inner_content">Veuillez vous authentifier ou créer un compte pour accéder à ce contenu.</div>
        <?php
            }
        ?>

        <?php
            if($_SESSION['log_in']) {
        ?>

        <div class="modal" id="modal_edit_user">
            <div class="modal-content">
            <h1 class="modal-title">Modifier l'utilisateur</h1>
            <hr class="modal-row"/>
            <form action="<?php $_PHP_SELF ?>" method="post" id="form_edit_user">
                <div style="display:table-row"><p class="form-label">Nom : </p><input id="update_name" type="text" name="nom"/></div>
                <div style="display:table-row"><p class="form-label">Mail : </p><input id="update_mail" type="text" name="mail" /></div>
                <div style="display:table-row"><p class="form-label">Adresse : </p><input id="update_adresse" type="text" name="adresse" /></div>
                <div style="display:table-row"><p class="form-label">Mot de passe : </p><input type="text" name="mdp" /></div>
                <?php
                    if($_SESSION['login_level']) {
                ?>
                <div style="display:table-row"><p class="form-label">Administrateur : </p>
                    <div style="display:inline; margin-right:20px"><input id="update_yes_admin" class="radio-btn" type="radio" name="is_admin" value="oui">Oui</div>
                    <div style="display:inline"><input id='update_no_admin' class="radio-btn" type="radio" name="is_admin" value="non" checked>Non</div>
                </div>
                <?php } ?>
                <input type="hidden" name="form_name" value="form_edit_user"/>
                <hr class="modal-row"/>
                <div class="modal-button">
                    <div id="ok_edit_user" class="modal-button modal-ok">OK</div>
                    <div id="cancel_edit_user" class="modal-button modal-cancel">Annuler</div>
                </div>
            </form>
            </div>
        </div>

        <script type="text/javascript">
            $('#cancel_edit_user').on('click', function(){
                $('#form_edit_user input').val('');
                $('#modal_edit_user').toggle();
            });

            $('#ok_edit_user').on('click', function(){
                $('#form_edit_user').submit();
            });
        </script>

        <?php
            }
        ?>
        </div>
    </body>
</html>
