#!/bin/bash

for i in {1..101}
do
  echo -e "\n\nMake it reach the docker pull limit $i"
  lima nerdctl pull $1
  
  lima nerdctl rmi $1
  sleep 1
done
