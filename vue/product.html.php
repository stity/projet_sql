<html>
	<head>
		<title><?= $title ?></title>
		<meta http-equiv="Content-Type" content="text/html" charset="utf8">
	</head>

	<body>
        <div id="inner_content">
            <div id="main_header"><?= $title ?></div>
            <div id="main_subheader"><?= $subtitle ?></div>


            <br>
            Cliquez sur le nom de l'abonnement pour plus de détails.

            <br>

            <div id="want_choices" style="width:50%;">
                <input style="width:25px" type="checkbox" id="want_abonnements" checked name="Abonnements">Abonnements
                <input style="width:25px" type="checkbox" id="want_promotions" checked>Promotions
            </div>

            <table style="margin-top:10pt;">
                <tr>
                    <th>Nom</th> <th>Tarif (€/mois)</th> <th>Promotion</th> <th>Téléphone associé</th>
                </tr>
                <?php
                    $result = $controleur->get_abonnements(true, true);
                    while($row = mysqli_fetch_array($result)) {
                ?>
                    <tr>
                        <td><?php echo $row['nom']?></td>
                        <td><?php echo $row['prix_mensuel']?></td>
                        <td><?php echo ($row['formule_base'] == -1) ? 'Non' : 'Oui' ?></td>
                        <td><?php echo ($row['telephone'] == NULL) ? '-' : 'Oui' ?></td>
                    </tr>
                <?php } ?>
            </table>
        </div>
    </body>
</html>
