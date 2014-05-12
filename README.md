# SixArm.com » Ruby » <br> Sentry script system monitoring

* Link: <http://sixarm.com/sixarm_ruby_sentry/doc>
* Repo: <http://github.com/sixarm/sixarm_ruby_sentry>
* Email: Joel Parker Henderson, <joel@sixarm.com>

## Introduction

Sentry is a script for simple system monitoring:

  * Sentry can fetch a web page URI.

  * And do multiple attempts if you want.

  * And calculate if results are fast enough.

  * If there's an error, then Sentry prints diagnostics.

  * And can send email alerts.

If you're interested in this kind of monitoring,
we suggest trying Nagios, Monit, and similar software.


## Examples

Test a web page:

    sentry --uri http://www.example.com

Test ten times:

    sentry --uri http://www.my.com -n 10

Test the speed is two seconds or faster:

    sentry --uri http://www.my.com -s 2

Test the result text:

    sentry --uri http://www.my.com
           --include "Success"

    sentry --uri http://www.my.com
           --exclude "Failure"

Send errors via mail:

    sentry --uri http://www.example.com
           --mail

Send errors via mail with custom settings:

    sentry --uri http://www.example.com
           --mail-to alice@example.com
           --mail-from bob@example.com
           --mail-subject "Alert!"


## Options

Watcher options:

  * `--uri (uri)`:            Specify a URI to fetch.

Diagnostic options:

  * `-n --number (count)`:    How many times to run the test.
                              Example: `--number 10`

  * `-s --speed (seconds)`:   The average speed must be this speed or faster.
                              Example: `--speed 1.00`

Text search options:

  * `-i --include (text)`:    The response text must include this text.
                              Example: `--include "Success"`

  * `-e --exclude (text)`:    The response text must *not* include this text.
                              Example: `--exclude "Failure"`

Mail options:

  * `--mail`:                 Send errors via mail? If this arg exists,
                              then the script uses the default mail settings.
                              This flag is automatically set to true if any of
                              the other mail args exist.
                              Example: `--mail`

  * `--mail-to (address)`:    Send mail to this email address.
                              Example: `--mail-to alice@example.com`
                              Default is `user` at `host`.

  * `--mail-from (address)`:  Send mail from this email address
                              Example: `--mail-from bob@example.com`
                              Default is `user` at `host`.

  * `--mail-subject (text)`:  Send mail using this subject.
                              Example: `--mail-subject "Urgent"`
                              Default is `"Sentry Alert"`


System options:

  * `-u --user (user name)`:  The local system user name.
                              Default is `ENV` `USER` or `ENV USERNAME`,
                              or calling the system command `whoami`.
                              This is for email defaults for "from" and "to".
                              This is typically not needed.

  * `-h --host (host name)`:  The local system host name.
                              Default is `ENV HOST` or `ENV HOSTNAME`,
                              or calling the system reverse DNS lookup.
                              This is used in email defaults.
                              This is typically not needed.


## Changes

* 2014-05-12 2.3.0 Update for Ruby 2
* 2006-xx-xx 2.2.0 Create using Ruby 1


## License

You may choose any of these open source licenses:

  * Apache License
  * BSD License
  * CreativeCommons License, Non-commercial Share Alike
  * GNU General Public License Version 2 (GPL 2)
  * GNU Lesser General Public License (LGPL)
  * MIT License
  * Perl Artistic License
  * Ruby License

The software is provided "as is", without warranty of any kind,
express or implied, including but not limited to the warranties of
merchantability, fitness for a particular purpose and noninfringement.

In no event shall the authors or copyright holders be liable for any
claim, damages or other liability, whether in an action of contract,
tort or otherwise, arising from, out of or in connection with the
software or the use or other dealings in the software.

This license is for the included software that is created by SixArm;
some of the included software may have its own licenses, copyrights,
authors, etc. and these do take precedence over the SixArm license.

Copyright (c) 2006-2014 Joel Parker Henderson
