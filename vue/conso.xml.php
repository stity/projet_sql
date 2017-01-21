<?php
    require "../database/DB.php";
    $consoId = intval($_GET['consoId']);
echo 'test';
    $db = new DB();
ob_start();
header( 'content-type: text/xml; charset=utf-8' );
echo '<?xml version="1.0" encoding="utf-8"?>';
echo '<?xml-stylesheet type="text/xsl" href="conso.xsl"?>';
echo "<conso>\n";
    echo "<generationdate>";
        echo date('d/m \à H:i:s' );
    echo "</generationdate>";
    echo "<smslist>\n";
        $sql = 'SELECT date,volume, nom as destination, zone FROM sms JOIN (SELECT pays.id,pays.nom as nom, zone_geographique.nom as zone FROM pays, zone_geographique, zone_geographique_pays WHERE pays.id=zone_geographique_pays.pays AND zone_geographique.id=zone_geographique_pays.zone_geographique ) pays ON (sms.destination=pays.id) WHERE consommation='.$consoId.' ORDER BY date ASC;';
        $result = $db->execute($sql);
        if ($result->num_rows > 0) {
            while($row = $result->fetch_assoc()) {
                $date = new DateTime($row['date']);
        echo "<sms>\n";
            echo "<date>".$date->format('d/m \à H\hi' )."</date>\n";
            echo "<volume>".$row['volume']."</volume>\n";
            echo "<destination>".$row['destination']."</destination>\n";
            echo "<zone>".$row['zone']."</zone>\n";
        echo "</sms>\n";
            } }
    echo "</smslist>\n";
    echo "<mmslist>\n";
        $sql = 'SELECT date,volume, nom as destination, zone FROM mms JOIN (SELECT pays.id,pays.nom as nom, zone_geographique.nom as zone FROM pays, zone_geographique, zone_geographique_pays WHERE pays.id=zone_geographique_pays.pays AND zone_geographique.id=zone_geographique_pays.zone_geographique ) pays ON (mms.destination=pays.id) WHERE consommation='.$consoId.' ORDER BY date ASC;';
        $result = $db->execute($sql);
        if ($result->num_rows > 0) {
            while($row = $result->fetch_assoc()) {
                $date = new DateTime($row['date']);
        echo "<mms>\n";
            echo "<date>".$date->format('d/m \à H\hi' )."</date>\n";
            echo "<volume>".$row['volume']."</volume>\n";
            echo "<destination>".$row['destination']."</destination>\n";
            echo "<zone>".$row['zone']."</zone>\n";
        echo "</mms>\n";
        } }
    echo "</mmslist>\n";
    echo "<appellist>\n";
        $sql = 'SELECT debut_appel,duree, nom as destination, zone FROM appel JOIN (SELECT pays.id,pays.nom as nom, zone_geographique.nom as zone FROM pays, zone_geographique, zone_geographique_pays WHERE pays.id=zone_geographique_pays.pays AND zone_geographique.id=zone_geographique_pays.zone_geographique ) pays ON (appel.destination=pays.id) WHERE consommation='.$consoId.' ORDER BY debut_appel ASC;';
        $result = $db->execute($sql);
        if ($result->num_rows > 0) {
            while($row = $result->fetch_assoc()) {
                $date = new DateTime($row['debut_appel']);
        echo "<appel>\n";
            echo "<date>".$date->format('d/m \à H\hi' )."</date>\n";
            echo "<duree>".$row['duree']."</duree>\n";
            echo "<destination>".$row['destination']."</destination>\n";
            echo "<zone>".$row['zone']."</zone>\n";
        echo "</appel>\n";
            } }
    echo "</appellist>\n";
echo "</conso>\n";
$result = ob_get_clean(); // retrieve output from myfile.php, stop buffering
file_put_contents('conso.xml', $result);
shell_exec("generatepdf.sh");
header('Location: conso.pdf');
?>
