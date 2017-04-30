#!/bin/sh
(
/usr/sbin/chkrootkit
) | /usr/bin/mail -s 'Report of chkrootkit from [Servername]' notice@email.org