#!/bin/sed -f

s/SIG:G/\x1b[90mSigned BY:/
s/SIG:X/\x1b[90m\x1b[4mExpired signature\x1b[24m BY:\x1b[0m/
s/SIG:Y/\x1b[90m\x1b[4mExpired key\x1b[24m BY:\x1b[0m/

s/SIG:N//

s/SIG:B/\x1b[31m\x1b[7mBad signature! \x1b[0m/
s/SIG:U/\x1b[31mUntrusted signature BY:\x1b[0m/

s/SIG:R/\x1b[93mRevoked key \x1b[0m/
s/SIG:E/\x1b[93mUnknown key \x1b[0m/

s/BY:.* </by </
