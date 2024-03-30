#!/bin/bash

for i in {1..101}
do
  echo "Creating pod $i"
  kubectl apply -f pod.yaml
  sleep 5
  echo "Deleting pod $i"
  kubectl delete pod pull-limit-test
  sleep 5
done
