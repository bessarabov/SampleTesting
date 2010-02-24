use inc::Module::Install;

name            'JustSample';
author          'Ivan Bessarabov <ivan@bessarabov.ru>';
version         '1.0';
license         'perl';

requires        'AppConfig';

# Для тестирования
requires        'Test::More';
requires        'Test::Pod::Coverage';
requires        'Test::Trap';

auto_install;
WriteAll;
