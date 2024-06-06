#!/bin/bash

for i in {1..41}
do
  echo "Creating pod $i"
  # kubectl apply -f sample-pod.yaml
  # docker pull hulkong/test-limit:nginx
  lima nerdctl pull hulkong/test-limit:nginx
  sleep 20
  echo "Deleting pod $i"
  # kubectl delete pod pull-limit-test
  # docker rmi hulkong/test-limit:nginx
  lima nerdctl rmi hulkong/test-limit:nginx
  sleep 5
done
