#!/bin/sed -f

s/SIG:G/\x1b[90mSigned BY:/
s/SIG:X/\x1b[90m\x1b[4mexpired signature\x1b[24m BY:\x1b[0m/
s/SIG:Y/\x1b[90m\x1b[4mexpired key\x1b[24m BY:\x1b[0m/

s/SIG:N/\x1b[90m\x1b[4munsigned\x1b[24m\x1b[0m/

s/SIG:B/\x1b[31m\x1b[7mBad signature! \x1b[0m/
s/SIG:U/\x1b[31mUnknown signature BY:\x1b[0m/

s/SIG:R/\x1b[93mrevoked key \x1b[0m/
s/SIG:E/\x1b[93mcannot check \x1b[0m/

s/BY:.* </by </
