docker rmi -f $(docker images -q 'myapp') 2>/dev/null

start=$(date +%s)

act -W .github/workflows/$1 \
--env ACTIONS_CACHE_URL=http://127.0.0.1:8080/ \
--env ACTIONS_RUNTIME_URL=http://127.0.0.1:8080/ \
--env ACTIONS_RUNTIME_TOKEN=foo
end=$(date +%s)

runtime=$((end-start))

echo "Build time: $runtime seconds"