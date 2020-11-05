#!/usr/bin/bash
in2csv $1 | csvsql --query "select AVG(overall_ratingsource) from stdin where cleanliness>0" | awk 'NR>1{print "RATING_AVG", $1}'
in2csv $1 | csvsql --query "select LOWER(country), COUNT(doc_id) from stdin GROUP BY 1"| awk -F, 'NR>1{print "HOTELNUMBER", $1, $2}'
in2csv $1 | csvsql --query "select t1.country, holiday, hilton from (select lower(country) country, AVG(cleanliness) holiday from stdin where hotel_name like '%holiday inn%' and cleanliness>0 group by 1) t1 \
left join (select lower(country) country, AVG(cleanliness) hilton from stdin where hotel_name like '%hilton%' and cleanliness>0 group by 1) t2 on t1.country==t2.country" | awk -F, 'NR>1{print "CLEANLINESS", $1, $2, $3}'
awk -F, '{if($18>=0 && $12>=0) print $12, $18}' $1 >> /tmp/BelousovIM_hotels.csv
gnuplot -persist << -EOFMarker
        set terminal png size 300,400
        set datafile separator " "
        f(x) = m*x + b
        fit f(x) '/tmp/BelousovIM_hotels.csv' using 1:2 via m,b
        set output 'w_vs_h_fit.png'
        plot '/tmp/BelousovIM_hotels.csv' using 1:2 with points, f(x)
-EOFMarker


#in2csv $1 | csvsql --query "select AVG(overall_ratingsource) from stdin where cleanliness>=0 and overall_ratingsource>=0" | awk 'NR>1{print "RATING_AVG", $1}'
#in2csv $1 | csvsql --query "select LOWER(country), COUNT(doc_id) from stdin GROUP BY 1"| awk -F, 'NR>1{print "HOTELNUMBER", $1, $2}'
#in2csv $1 | csvsql --query "select t1.country, holiday, hilton from (select lower(country) country, AVG(cleanliness) holiday from stdin where hotel_name like '%holiday inn%' and cleanliness>0 group by 1) t1 \
#left join (select lower(country) country, AVG(cleanliness) hilton from stdin where hotel_name like '%hilton%' group by 1) t2 on t1.country==t2.country" | awk -F, 'NR>1{print "CLEANLINESS", $1, $2, $3}'
#awk -F, '{if($18>=0) print $12, $18}' $1 >> /tmp/BelousovIM_hotels.csv
#gnuplot -persist << -EOFMarker
#        set terminal png size 300,400
#        set datafile separator " "
#        f(x) = m*x + b
#        fit f(x) '/tmp/BelousovIM_hotels.csv' using 1:2 via m,b
#        set output 'w_vs_h_fit.png'
#        plot '/tmp/BelousovIM_hotels.csv' using 1:2 with points, f(x)
#-EOFMarker

