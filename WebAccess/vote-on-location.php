<?php

$address = $_GET['address'];
$up = $_GET['up']; // true for Upvote, false for Downvote

// Create connection
$con=mysqli_connect("localhost","bobaappc_dbuser","b0b44pp","bobaappc_WPMXB");

// Check connection
if (mysqli_connect_errno())
{
	echo "Failed to connect to MySQL: " . mysqli_connect_error();
}

// This SQL statement selects ALL from the table 'Locations'
$sql = "SELECT * FROM Locations WHERE 'Address' LIKE $address";

// Check if there are results
if ($result = mysqli_query($con, $sql))
{

    echo "Original: " + json_encode($resultArray);
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

    if($up = "true") {
        $sql = "UPDATE Locations SET Upvotes = Upvotes + 1 WHERE 'Address' LIKE $address";
        mysqli_query($con, $sql);
    } else if ($up = "false") {
        $sql = "UPDATE Locations SET Downvotes = Downvotes + 1 WHERE 'Address' LIKE $address";
        mysqli_query($con, $sql);
    }

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
	echo "Updated: " + json_encode($resultArray);
}

// Close connections
mysqli_close($con);
?>