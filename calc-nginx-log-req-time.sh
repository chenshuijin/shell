awk '{ print substr($NF, 2,length($NF)-2)}' <filepath>  | grep -v "-" | awk '{sum=sprintf("%.3f",sum+$0)}END{printf "total time:%f\n", sum; printf "total req:%f\n", NR; printf "avg:%f\n", sum/NR}'
