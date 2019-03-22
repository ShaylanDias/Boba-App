<?php

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
$sql = "INSERT INTO table_name VALUES ($address, $review);";

echo "Review Added";

// Close connections
mysqli_close($con);
?>