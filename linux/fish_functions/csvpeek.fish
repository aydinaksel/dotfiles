function csvpeek --description "Preview a CSV file with a limited number of columns"
    set file $argv[1]
    set columns $argv[2]
    if test -z "$columns"
        set columns 3
    end
    python3 -c "import csv, sys; [print(','.join(row[:$columns])) for row in csv.reader(sys.stdin)]" < $file | bat -l csv
end
