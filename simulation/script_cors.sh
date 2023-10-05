mkdir results
mkdir results/cors

./ldak --calc-cors results/cors/cors \
    --bfile data/train/samples \
    --window-kb 1000 \