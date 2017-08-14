# !/bin/bash
DIVIDER=$(printf '*%.0s' {1..100})
echo "$DIVIDER\n" >| results.txt
echo "TEST 1 \n"  >> results.txt
echo "$DIVIDER\n" >> results.txt
ab -n 1500 -c 70 http://127.0.0.1:5000/ >> results.txt

echo "\n$DIVIDER\n" >> results.txt
echo "TEST 2 \n"  >> results.txt
echo "$DIVIDER\n" >> results.txt
ab -n 7000 -c 10 http://127.0.0.1:5000/ >> results.txt
