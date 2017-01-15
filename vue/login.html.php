<html>
	<head>
		<title><?= $title ?></title>
		<meta http-equiv="Content-Type" content="text/html" charset="utf8">
	</head>

	<body>
        <div id="inner_content">
            <?php
                if(!empty($_POST['form_name'])){
                    if($_POST['form_name'] == 'form_login'){
                        $controleur->log_user($_POST['mail'], $_POST['mdp']);
                    } else if($_POST['form_name'] == 'form_logout'){
                        $controleur->logout_user();
                    }
                }
            ?>
            <div id="main_header"><?= $controleur->title ?></div>
            <div id="sub_header"><?= $controleur->subtitle ?></div>

            <?php
                if($_SESSION['log_in']) {
            ?>
                <form action="<?php $_PHP_SELF ?>" method="post" id="form_log_out" style="width:50%; margin:auto;">
                    <div id="ok_logout" class="login-button">Valider</div>
                    <input type="hidden" name="form_name" value="form_logout"/>
                </form>

                <script style="text/javascript">
                    $('#ok_logout').on('click', function(){
                        $('#form_log_out').submit();
                    });
                </script>

            <?php
                } else {
            ?>

                <form action="<?php $_PHP_SELF ?>" method="post" id="form_log_in" style="width:50%; margin:auto;">
                    <div style="display:table-row"><p class="form-label">Mail : </p><input type="text" name="mail" /></div>
                    <div style="display:table-row"><p class="form-label">Mot de passe : </p><input type="text" name="mdp" /></div>
                    <div id="ok_login" class="login-button">Valider</div>
                    <input type="hidden" name="form_name" value="form_login"/>
                </form>

                <div style="margin-top:60px">
                    Pas encore inscrit? C'est par ici que ça se passe!
                </div>

                <script style="text/javascript">
                    $('#ok_login').on('click', function(){
                        $('#form_log_in').submit();
                    });
                </script>
            <?php
                }
            ?>
        </div>
    </body>
</html>
