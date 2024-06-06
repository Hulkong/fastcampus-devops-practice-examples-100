start=$(date +%s)

docker build -f $1 . -t $2

end=$(date +%s)

runtime=$((end-start))

echo "Containerizng time: $runtime seconds"

docker images $2