package MyApp::Login;

use strict;
use warnings;

=encoding UTF-8
=cut

=head1 MyApp::Login

Эксперементальный модуль для проверки тестирования

=cut

use DBI;

my $MAX_LOGIN_FAILURES = 3;

=head1 GENERAL FUNCTIONS
=cut

=head2 login

Получает параметры:
 1. $dbh
 2. логин
 3. Пароль

Возвращает:
 1. Скаляр с текстом результата

Процедура проверет корректность данных и выдает скаляр с текстом. Варианты:
 * 'LOGIN SUCCESSFUL';
 * 'BAD PASSWORD';                  
 * 'USER ACCOUNT LOCKED';
 * 'USERNAME NOT FOUND';

=cut
sub login {
    my ($dbh, $u, $p) = @_;

    # Everything can be done only in case when it run with all 3 parameters
    if ($dbh and $u and $p) {
        
        # look for the right username and password
        my ($user_id) = $dbh->selectrow_array( "SELECT user_id FROM users WHERE username = '$u' AND password = '$p'" );

        # if we find one, then ...
        if ($user_id) {
            
            # log the event and return success      
            $dbh->do( "INSERT INTO event_log (event) VALUES('User $user_id logged in')" );
            return 'LOGIN SUCCESSFUL';

        } else { # if ($user_id) {

            # if we don't find one then ...
            # see if the username exists ...
            my ($user_id, $login_failures) = $dbh->selectrow_array( "SELECT user_id, login_failures FROM users WHERE username = '$u'" );
            
            if ($user_id) {
                # if we do have a username, and the password doesnt match then
                if ($login_failures < $MAX_LOGIN_FAILURES) {
                    # if we have not reached the max allowable login failures then 
                    # update the login failures
                    $dbh->do(qq{
                        UPDATE users 
                        SET login_failures = (login_failures + 1)
                        WHERE user_id = $user_id
                    });
                    return 'BAD PASSWORD';                  
                } else {
                    # otherwise ...
                    # we must update the login failures, and lock the account
                    $dbh->do(
                        "UPDATE users SET login_failures = (login_failures + 1), " .
                        "locked = 1 WHERE user_id = $user_id"
                    );                                                              
                    return 'USER ACCOUNT LOCKED';
                }
            } else {
                return 'USERNAME NOT FOUND';
            }

        } # if ($user_id) {
    
    } #if ($dbh and $u and $p) {

}


