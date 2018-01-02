<?php
	//Start session
	session_start();
	
	//Include database connection details
	require_once('config.php');
	
	//Array to store validation errors
	$errmsg_arr = array();
	
	//Validation error flag
	$errflag = false;
    $file = fopen(PASSWORD_FILE_LOC, PASSWORD_OPEN_PERM);
	/**
		//Connect to mysql server
		$link = mysql_connect(DB_HOST, DB_USER, DB_PASSWORD);
		if(!$link) {
			die('Failed to connect to server: ' . mysql_error());
		}
		
		//Select database
		$db = mysql_select_db(DB_DATABASE);
		if(!$db) {
			die("Unable to select database");
		}
	**/
	
	//Sanitize the POST values
	$login = clean($_POST['login']);
	$password = clean($_POST['password']);
	
	//Input Validations
	if($login == '') {
		$errmsg_arr[] = 'Login ID missing';
		$errflag = true;
	}
	if($password == '') {
		$errmsg_arr[] = 'Password missing';
		$errflag = true;
	}
	
	//If there are input validations, redirect back to the login form
	if($errflag) {
		$_SESSION['ERRMSG_ARR'] = $errmsg_arr;
		session_write_close();
		header("location: login-form.php");
		exit();
	}
	/*
		//Create query
		$qry="SELECT * FROM members WHERE login='$login' AND passwd='".md5($_POST['password'])."'";
		$result=mysql_query($qry);
	*/
    $user = NULL;
	while ($line = fgets($file)) {
        list($uname, $first, $last, $p_hash, $email, $active) = explode(',', $line);
        if ($login == $uname || $login == $email) {
            $user = $login;
            break;
        }
    }
    fclose($file);
	if ($user && password_verify($password, $p_hash)) {
		// if(mysql_num_rows($result) == 1) {
		//Login Successful
		session_regenerate_id();
		$_SESSION['SESS_MEMBER_NAME'] = $login;
		$_SESSION['SESS_MEMBER_MAIL'] = $email;
		$_SESSION['SESS_FIRST_NAME'] = $first;
		$_SESSION['SESS_LAST_NAME'] = $last;

			// $_SESSION['SESS_LAST_NAME']
			// $member = mysql_fetch_assoc($result);
			// $_SESSION['SESS_MEMBER_ID'] = $member['member_id'];
			// $_SESSION['SESS_FIRST_NAME'] = $member['firstname'];
			// $_SESSION['SESS_LAST_NAME'] = $member['lastname'];
		session_write_close();
		header("location: member-index.php");
		exit();
	}    
	//Check whether the query was successful or not
	else {
		header("location: login-failed.php");
		exit();
		// die("Query failed");
	}
?>