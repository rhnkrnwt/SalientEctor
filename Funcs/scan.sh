for F in ./*.m; do
    echo $F; grep "CalGeo" $F;
done
