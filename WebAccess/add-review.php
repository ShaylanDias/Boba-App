<?php
// http://www.mydomain.com/index.php?argument1=arg1&argument2=arg2
$address = $_GET['address'];
$review = $_GET['review'];

// Create connection
$con=mysqli_connect("localhost","bobaappc_dbuser","b0b44pp","bobaappc_WPMXB");

// Check connection
if (mysqli_connect_errno())
{
	echo "Failed to connect to MySQL: " . mysqli_connect_error();
}

// This SQL statement selects ALL from the table 'Locations'
$sql = "INSERT INTO `reviews` VALUES ('$address', '$review', CURRENT_DATE());";
mysqli_query($con, $sql);
echo "Review Added";

// Close connections
mysqli_close($con);
?>