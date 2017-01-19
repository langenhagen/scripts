#!bin/bash/ex

# run for instance with
# docker run --rm --name=test --net=container:mymockscbe1 -v /Users/langenha/Desktop/:/mnt tutum/curl bash mnt/runcurl.sh 127.0.0.1


curl -i -H "Accept: application/json"  -X POST  http://$@:5000/debug/postExampleRouteCategoryLink