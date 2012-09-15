<?php
$con = mysql_connect("localhost","peter","abc");
if (!$con)
  {
  die('Could not connect: ' . mysql_error());
  }

mysql_select_db("chatonline2", $con);

$result = mysql_query("SELECT * FROM user");

while($row = mysql_fetch_array($result))
  {
  echo $row['name'];
  echo "<br />";
  }

mysql_close($con);
?>
