#!/bin/bash

for i in {1..201}
do
  echo -e "\n\nMake it reach the docker pull limit $i"
  lima nerdctl pull $1
  sleep 3

  lima nerdctl rmi $1
  sleep 3
done
