#!/usr/bin/env -S bash -ex

# run for instance with
# docker run --rm --name=test --net=container:mymockscbe1 -v /Users/langenha/Desktop/:/mnt tutum/curl bash mnt/runcurl.sh 127.0.0.1

# -H, --header <header>: Extra header to include in the request when sending HTTP
#                        to a server. You may specify any number of extra  headers.
# -i, --include: Include HTTP Header in the output.
# -X, --request <command>: for e.g. HTML: GET POST PUT DELETE HEAD
#                          for e.g. FTP: custom FTP command to use instead of LIST when
#                          doing file lists with FTP
curl -i -H "Accept: application/json"  -X POST  http://$@:5000/debug/postExampleRouteCategoryLink