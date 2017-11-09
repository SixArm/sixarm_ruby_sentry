# SixArm.com → Ruby → <br> Sentry script system monitoring

* Link: <http://sixarm.com/sixarm_ruby_sentry/doc>
* Repo: <http://github.com/sixarm/sixarm_ruby_sentry>
<!--header-shut-->


## Introduction


Sentry is a script for simple system monitoring:

  * Sentry can fetch a web page URI, or resolve a DNS name.

  * And do multiple attempts if you want.

  * And calculate if results are fast enough.

  * If there's an error, then Sentry prints diagnostics.

  * And can send email alerts.

If you're interested in this kind of monitoring,
we suggest trying Nagios, Monit, and similar software.


## Examples


Test that the system can successfully fetch a URI:

    sentry www.example.com

Test DNS lookup:

    sentry --dns www.example.com

Test FTP fetch:

    sentry ftp://user@password:ftp.example.com/foo/bar.txt

Test that the result must include text and/or exclude text:

    sentry www.example.com
           --include "Success"
           --exclude "Failure"

Test ten times:

    sentry www.example.com -n 10

Test the speed is within two seconds:

    sentry www.example.com -s 2

Send errors via mail using default settings:

    sentry www.example.com --mail

Send errors via mail using custom settings:

    sentry www.example.com
           --mail-to alice@example.com
           --mail-from bob@example.com
           --mail-subject "Alert!"


## Options


Help:

  * `-h, --help`              Print help.


Watcher:

  * `--uri (uri)`:            Specify a URI to fetch. Default is to use HTTP.

  * `--dns (host name)`:      Specify a DNS host name to resolve.


Text search:

  * `-i, --include (text)`:   The response text must include this text.
                              Example: `--include "Success"`

  * `-e, --exclude (text)`:   The response text must *not* include this text.
                              Example: `--exclude "Failure"`

Diagnostics:

  * `-n, --number (count)`:   How many times to run the test. Default is 1.
                              Example: `--number 10`

  * `-s, --speed (seconds)`:  The average speed must be this speed or faster.
                              Example: `--speed 1.00`


Mail:

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


System:

  * `--user (user name)`:     The local system user name.
                              Default is `ENV` `USER` or `ENV USERNAME`,
                              or calling the system command `whoami`.
                              This is for email defaults for "from" and "to".
                              This is typically not needed.

  * `--host (host name)`:     The local system host name.
                              Default is `ENV HOST` or `ENV HOSTNAME`,
                              or calling the system reverse DNS lookup.
                              This is used in email defaults.
                              This is typically not needed.
