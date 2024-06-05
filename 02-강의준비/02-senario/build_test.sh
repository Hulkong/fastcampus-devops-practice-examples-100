start=$(date +%s)
act -W .github/workflows/$1
end=$(date +%s)
runtime=$((end-start))
echo "Build time: $runtime seconds"