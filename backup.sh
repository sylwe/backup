#!/bin/bash
#Sylwester Włodyga - sylwester.w@gmail.com
#logfile
#echo "From: BackupScrypt\nSubject: ERROR!!!"
log="/mnt/c/TMP/test/backup.log"
status="/mnt/c/TMP/test/status.tmp"
dirIN="/mnt/c/TMP/test/dirIN"
dirOUT="/mnt/c/TMP/test/dirOUT"
dirTMP="/mnt/c/TMP/test/dirTMP"
data=$(date '+%Y-%m-%d %H:%M:%S')
nazwa="/`date +%F`_backup.tar"


echo "$data Uruchamiam skrypt backup.sh" >> $log;
#for i in `find $dirIN -type f -mtime +0 -print`
for i in `find $dirIN -type f -mtime +30 -print`
do 
    echo "$data Przenoszenie $i" >> $log
    mv $i $dirTMP
done

echo "$data Rozpoczynam pakowanie archiwum" >> $log;

tar cfv $dirOUT$nazwa -C $dirTMP . >> $log;

echo "$data Dokumenty spakowane poprawnie" >> $log;
echo "$data Czyszczenie tempa" >> $log;

find $dirTMP -mtime +30 -type f -exec rm -rfv {} \; >>$log;

#ls -y 1>>$log 2>$status

status2="$(cat status.tmp)"
echo $status2

if [ -z "$status2" ]; then
    echo "$data Backup wykonany poprawnie $status - Wszystko OK." >> $log;
    else
    echo "$data Backup zakończony niepowodzeniem $status !!!" >> $log;
    echo '$data Backup zakończony niepowodzeniem' >> $log | sendmail sylwester.w@gmail.com < $log && $status2;
fi

echo "-----------------------------" >> $log;
