<?php

// http://www.mydomain.com/index.php?argument1=arg1&argument2=arg2

$address = $_GET['address'];
$name = $_GET['name'];
$up = ($_GET['up'] == 'true') ? True : False; // true for Upvote, false for Downvote

// Create connection
$con=mysqli_connect("localhost","bobaappc_dbuser","b0b44pp","bobaappc_WPMXB");

// Check connection
if (mysqli_connect_errno())
{
	echo "Failed to connect to MySQL: " . mysqli_connect_error();
}

// This SQL statement selects ALL from the table 'Locations'
$sql = "SELECT * FROM Locations WHERE 'Address' LIKE '$address'";

// Check if there are results
if ($result = mysqli_query($con, $sql))
{
    echo ("UP:" + $up + ", Input: " + $_GET['up']);

    if($up == true) {
        $sql = "UPDATE `Locations` SET Upvotes = Upvotes + 1 WHERE `Address` LIKE '$address'";
        mysqli_query($con, $sql);
    } 
    else {
        $sql = "UPDATE `Locations` SET Downvotes = Downvotes + 1 WHERE `Address` LIKE '$address'";
        mysqli_query($con, $sql);
    }
}
else {
    if($up) {
        $sql = "INSERT INTO Locations VALUES('$address', '$name', 101, 0)";
        mysqli_query($con, $sql);
    }
    else {
        $sql = "INSERT INTO Locations VALUES('$address', '$name', 100, 1)";
        mysqli_query($con, $sql);
    }
}

// Close connections
mysqli_close($con);
?>