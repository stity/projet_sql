<?php
    require "../database/DB.php";
    $consoId = 1;
    $db = new DB();
ob_start();
echo '<?xml version="1.0" encoding="utf-8"?>';
echo '<?xml-stylesheet type="text/xsl" href="conso.xsl"?>';
echo '<conso>';
    echo '<smslist>';
        $sql = 'SELECT * FROM sms WHERE consommation='.$consoId.' ORDER BY date ASC;';
        $result = $db->execute($sql);
        if ($result->num_rows > 0) {
            while($row = $result->fetch_assoc()) {
        echo '<sms>';
            echo '<date>'.$row['date'].'</date>';
            echo '<volume>'.$row['volume'].'</volume>';
            echo '<destination>'.$row['destination'].'</destination>';
        echo '</sms>';
            } }
    echo '</smslist>';
    echo '<mmslist>';
        $sql = 'SELECT * FROM mms WHERE consommation='.$consoId.' ORDER BY date ASC;';
        $result = $db->execute($sql);
        if ($result->num_rows > 0) {
            while($row = $result->fetch_assoc()) {
        echo '<mms>';
            echo '<date>'.$row['date'].'</date>';
            echo '<volume>'.$row['volume'].'</volume>';
            echo '<destination>'.$row['destination'].'</destination>';
        echo '</mms>';
        } }
    echo '</mmslist>';
    echo '<appellist>';
        $sql = 'SELECT * FROM appel WHERE consommation='.$consoId.' ORDER BY debut_appel ASC;';
        $result = $db->execute($sql);
        if ($result->num_rows > 0) {
            while($row = $result->fetch_assoc()) {
        echo '<appel>';
            echo '<date>'.$row['debut_appel'].'</date>';
            echo '<duree>'.$row['duree'].'</duree>';
            echo '<destination>'.$row['destination'].'</destination>';
        echo '</appel>';
            } }
    echo '</appellist>';
echo '</conso>';
$result = ob_get_clean(); // retrieve output from myfile.php, stop buffering
file_put_contents('conso.xml', $result);
shell_exec("generatepdf.sh");
header('Location: conso.pdf');
?>
