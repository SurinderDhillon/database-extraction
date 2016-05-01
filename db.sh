# MySQL User
USER='username'
# MySQL Password
PASSWORD='mysql-password'
# Backup Directory - NO TAILING SLASH!
OUTPUT="path-to-save-database"
 
##### And 
TIMESTAMP=`date +%Y%m%d`;
#mkdir $OUTPUT;
cd $OUTPUT;
echo "Starting MySQL Backup";
echo `date`;
databases=`mysql --user=$USER --password=$PASSWORD -e "SHOW DATABASES;" | tr -d "| " | grep -v Database`
for db in $databases; do
    if [[ "$db" != "information_schema" ]] && [[ "$db" != "performance_schema" ]] && [[ "$db" != "phpmyadmin" ]] && [[ "$db" != "mysql" ]]  && [[ "$db" != "sentora_postfix" ]] && [[ "$db" != "sentora_roundcube" ]] && [[ "$db" != "sentora_proftpd" ]] && [[ "$db" != "sentora_core" ]] && [[ "$db" != _* ]] ; then
        echo "Dumping database: $db"
        mysqldump --force --opt --user=$USER --password=$PASSWORD --databases $db > $OUTPUT/dbbackup-$TIMESTAMP-$db.sql
	gzip $OUTPUT/dbbackup-$TIMESTAMP-$db.sql
    fi
done
zip -r $HOSTNAME.zip dbbackup*
pwd
rm -r *.gz

echo "Finished MySQL Backup";
echo `date`;
