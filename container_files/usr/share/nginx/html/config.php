<?php
/**
 * Define some constants we'll use.
 */
    define('PASSWORD_FILE_LOC', '/etc/.logpasswd');
    define('PASSWORD_OPEN_PERM', 'r');

    //by deafult XAMPP configure server settings as follows
	define('DB_HOST', 'localhost');
    define('DB_USER', 'root');
    define('DB_PASSWORD', '');

    //advance users can change it anytime
    //Now enter the database name you created
    define('DB_DATABASE', 'test');

    function _password_hash($password) {
        return password_hash($password, PASSWORD_BCRYPT);
    }

    //Function to sanitize values received from the form. Prevents SQL injection
    function clean($str) {
        $str = @trim($str);
        if(get_magic_quotes_gpc()) {
            $str = stripslashes($str);
        }
        return $str;
    }

    function get_file($mode) {
        return fopen(PASSWORD_FILE_LOC, $mode);
    }
?>