package MyApp::Login;

use DBI;

my $MAX_LOGIN_FAILURES = 3;

sub login {
  my ($dbh, $u, $p) = @_;
  # look for the right username and password
  my ($user_id) = $dbh->selectrow_array(
      "SELECT user_id FROM users WHERE username = '$u' AND password = '$p'"
  );
  # if we find one, then ...
  if ($user_id) {
      # log the event and return success      
      $dbh->do(
          "INSERT INTO event_log (event) VALUES('User $user_id logged in')"
      );
      return 'LOGIN SUCCESSFUL';
  }
  # if we don't find one then ...
  else {
      # see if the username exists ...
      my ($user_id, $login_failures) = $dbh->selectrow_array(
          "SELECT user_id, login_failures FROM users WHERE username = '$u'"
      );
      # if we do have a username, and the password doesnt match then
      if ($user_id) {
          # if we have not reached the max allowable login failures then 
          if ($login_failures < $MAX_LOGIN_FAILURES) {
              # update the login failures
              $dbh->do(qq{
                  UPDATE users 
                  SET login_failures = (login_failures + 1)
                  WHERE user_id = $user_id
              });
              return 'BAD PASSWORD';                  
          }
          # otherwise ...
          else {
              # we must update the login failures, and lock the account
              $dbh->do(
                  "UPDATE users SET login_failures = (login_failures + 1), " .
                  "locked = 1 WHERE user_id = $user_id"
              );                                                              
              return 'USER ACCOUNT LOCKED';
          }
      }
      else {
          return 'USERNAME NOT FOUND';
      }
  }
}

