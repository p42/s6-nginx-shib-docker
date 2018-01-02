<?php
	//Start session
	session_start();
	
	//Include database connection details
	require_once('config.php');
	
	//Array to store validation errors
	$errmsg_arr = array();
	
	//Validation error flag
	$errflag = false;
    $file = get_file(PASSWORD_OPEN_PERM);	
	
	//Sanitize the POST values
	$fname = clean($_POST['fname']);
	$lname = clean($_POST['lname']);
	$login = clean($_POST['login']);
	$password = clean($_POST['password']);
	$cpassword = clean($_POST['cpassword']);
	$email = clean($_POST['email']);
	
	//Input Validations
	if($fname == '') {
		$errmsg_arr[] = 'First name missing';
		$errflag = true;
	}
	if($lname == '') {
		$errmsg_arr[] = 'Last name missing';
		$errflag = true;
	}
	if($login == '') {
		$errmsg_arr[] = 'Login ID missing';
		$errflag = true;
	}
	if($email == '') {
		$errmsg_arr[] = 'Email Address missing';
		$errflag = true;
	}
	if($password == '') {
		$errmsg_arr[] = 'Password missing';
		$errflag = true;
	}
	if($cpassword == '') {
		$errmsg_arr[] = 'Confirm password missing';
		$errflag = true;
	}
	if( strcmp($password, $cpassword) != 0 ) {
		$errmsg_arr[] = 'Passwords do not match';
		$errflag = true;
	}
	
	while ($line = fgets($file)) {
        list($uname, $first, $last, $p_hash, $umail, $active) = explode(',', $line);
        if ($login == $uname || $email == $umail) {
            $errmsg_arr[] = 'Login ID already in use';
			$errflag = true;
        }
    }
    fclose($file);

	//If there are input validations, redirect back to the registration form
	if($errflag) {
		$_SESSION['ERRMSG_ARR'] = $errmsg_arr;
		session_write_close();
		header("location: register-form.php");
		exit();
	}
	else {
		// Write to our password file.
		// Create the string
		$str = "\n".$login . ',' . $fname . ',' . $lname . ',' . _password_hash($password) . ',' . $email . ',' . '1';
		$file = get_file('a');
		fwrite($file, $str);
		fclose($file);
		header("location: register-success.php");
		exit();
	}
?>