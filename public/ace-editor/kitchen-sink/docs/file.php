<? 
        include "db.php";


$query="SELECT daerah FROM datatoko where propinsi='yogyakarta' ";
$result=mysql_query($query);

$num = mysql_num_rows($result);
$rows = array();

for($i=0; $i<$num; $i++)
{  
$row = mysql_fetch_array($result) ;

$rows[] = $row[0];


for($s=0; $s<$i; $s++)
{
if ($rows[$i] == $rows[$s]) {unset($rows[$i]);};
}
if ($rows[$i] == '') {unset($rows[$i]);};
}


// ###########################################BANDUNG################################################ //

$query2="SELECT daerah FROM datatoko where propinsi='bandung' ";
$result2=mysql_query($query2);

$num2 = mysql_num_rows($result2);
$rows2 = array();

for($i2=0; $i2<$num2; $i2++)
{  
$row2 = mysql_fetch_array($result2) ;

$rows2[] = $row2[0];


for($s2=0; $s2<$i2; $s2++)
{
if ($rows2[$i2] == $rows2[$s2]) {unset($rows2[$i2]);};
}
if ($rows2[$i2] == '') {unset($rows2[$i2]);};
}


// ##########################################JAKARTA################################################# //

$query3="SELECT daerah FROM datatoko where propinsi='jakarta' ";
$result3=mysql_query($query3);

$num3 = mysql_num_rows($result3);
$rows3 = array();

for($i3=0; $i3<$num3; $i3++)
{  
$row3 = mysql_fetch_array($result3) ;

$rows3[] = $row3[0];


for($s3=0; $s3<$i3; $s3++)
{
if ($rows3[$i3] == $rows3[$s3]) {unset($rows3[$i3]);};
}
if ($rows3[$i3] == '') {unset($rows3[$i3]);};
}


// #######################################################END############################################# //

?>

  
<?php
echo '<script type="text/javascript">';
echo 'var makes = new Array("yogyakarta", "bandung", "jakarta", "online");';
echo 'var models = new Array("");';
echo 'models["yogyakarta"] = new Array("',join($rows, '", "'), '");';
echo 'models["bandung"] = new Array("',join($rows2, '", "'), '");';
echo 'models["jakarta"] = new Array("',join($rows3, '", "'), '");';
echo '</script>'
 
?>

<script>
 

function resetForm(theForm) {
  /* reset makes */
  theForm.makes.options[0] = new Option("Semua Tempat >>", "Semua");
  for (var i=0; i<makes.length; i++) {
    theForm.makes.options[i+1] = new Option(makes[i], makes[i]);
  }
  theForm.makes.options[0].selected = true;
  /* reset models */
  theForm.models.options[0] = new Option("Semua Daerah >>", "Semua");
  theForm.models.options[0].selected = true;
}

function updateModels(theForm) {
  var make = theForm.makes.options[theForm.makes.options.selectedIndex].value;
  var newModels = models[make];
  theForm.models.options.length = 0;
  theForm.models.options[0] = new Option("Semua Daerah >>", "Semua");
  for (var i=0; i<newModels.length; i++) {
    theForm.models.options[i+1] = new Option(newModels[i], newModels[i]);
  }
  theForm.models.options[0].selected = true;
}

</script>

 


