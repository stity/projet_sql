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
            Votre facture est directement consultable au format PDF!
            <table style="margin-top:10pt;">
                <tr>
                    <th>Date</th> <th>Montant</th> <th>Réglé</th> <th>Détails</th>
                </tr>
                    <?php
                        $result = $controleur->getAllFacture();
                        while($row = mysqli_fetch_array($result)) {
                            $date = new DateTime($row['date']);
                    ?>
                    <tr>
                        <td><?php echo $date->format('M Y' );?></td>
                        <td><?php echo $row['prix'];?>€</td>
                        <td><?php echo $row['paye']? 'Oui' : 'Non'; ?></td>
                        <td><a href="vue/conso.xml.php?consoId=<?php echo $row['id'];?>"><i class="fa fa-file-pdf-o"></i></a></td>
                    </tr>
                    <?php
                        }
                    ?>
            </table>
        </div>
    </body>
</html>
