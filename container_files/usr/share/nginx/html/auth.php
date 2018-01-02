<?php
	//Start session
    if (!isset($_SESSION)) {
    	session_start();
    }
	
	//Check whether the session variable SESS_MEMBER_ID is present or not
	if(!isset($_SESSION['SESS_MEMBER_MAIL']) || (trim($_SESSION['SESS_MEMBER_MAIL']) == '')) {
		header("location: access-denied.php");
		exit();
	}
?>