<?php
// http://www.mydomain.com/index.php?argument1=arg1&argument2=arg2

$address = $_GET['address'];
$name = $_GET['name'];

// Create connection
$con=mysqli_connect("localhost","bobaappc_dbuser","b0b44pp","bobaappc_WPMXB");

// Check connection
if (mysqli_connect_errno())
{
	echo "Failed to connect to MySQL: " . mysqli_connect_error();
}

// This SQL statement selects ALL from the table 'Locations'
$sql = "SELECT * FROM `Locations` WHERE `Address` LIKE '$address'";

// Check if there are results
if ($result = mysqli_query($con, $sql))
{
	if (sizeof($result) == 0 or mysqli_num_rows($result) == 0) {
		$sql = "INSERT INTO `Locations` VALUES('$address', '$name', 100, 0);";
		mysqli_query($con, $sql);
		echo "[{\"Address\":\"$address\",\"Name\":\"$name\",\"Upvotes\":\"100\",\"Downvotes\":\"0\"}]";
	}
	else {
		// If so, then create a results array and a temporary one
		// to hold the data
		$resultArray = array();
		$tempArray = array();

		// Loop through each row in the result set
		while($row = $result->fetch_object())
		{
			// Add each row into our results array
			$tempArray = $row;
			array_push($resultArray, $tempArray);
		}

		// Finally, encode the array to JSON and output the results
		echo json_encode($resultArray);
	}
}
else {
	$sql = "INSERT INTO `Locations` VALUES('$address', '$name', 100, 0);";
	mysqli_query($con, $sql);
	echo "[{\"Address\":\"$address\",\"Name\":\"$name\",\"Upvotes\":\"100\",\"Downvotes\":\"0\"}]";
}

// Close connections
mysqli_close($con);
?>