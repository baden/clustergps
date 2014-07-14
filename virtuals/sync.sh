#!/bin/sh

#scp -P 2222 -rp ../_rel/clustergps/ ubuntu@127.1:
rsync -avz --delete --rsh='ssh -p2222' ../_rel/clustergps/ ubuntu@127.1:~/clustergps
