<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<? /*
 * A simple, clean and secure PHP Login Script using MySQL.
 *
 *
 * @author Ashish Sharma
 * @mail me@ashisharma.info
 * @link http://ashisharma.info
 * @link http://asxena.foxena.com
 * @license http://opensource.org/licenses/MIT MIT License
 */
?>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Login</title>
<link href="loginmodule.css" rel="stylesheet" type="text/css" />
</head>
<body>
<p>&nbsp;</p>
<div id="saml-login" class="saml-login-button">
    <a href="/app">SSO Login with IDP</a>
</div>
<form id="loginForm" name="loginForm" method="post" action="login-exec.php">
  <table width="300" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr>
      <td width="112"><b>Login</b></td>
      <td width="188"><input name="login" type="text" class="textfield" id="login" /></td>
    </tr>
    <tr>
      <td><b>Password</b></td>
      <td><input name="password" type="password" class="textfield" id="password" /></td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td><input type="submit" name="Submit" value="Login" /></td>
    </tr>
  </table>
</form>
<br/>
<center><h3><a href="register-form.php">Register</a>&nbsp;&nbsp;&nbsp;<a href="readme.html">Readme</a>&nbsp;&nbsp;&nbsp;
<a href="/">Home</a></h3></center>
</body>
</html>
