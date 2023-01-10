# quick and dirty script to extract remote git URLs

basedir="/mnt/sdcard/tools/ActiveDirectory"
outfile=$basedir"repos.txt"

for dir in `ls $basedir`
do    
    if [[ -f $basedir$dir/.git/config ]]; then
        git config --get remote.origin.url >> $outfile
    else
        echo "[!] Skipping "$dir
    fi
done