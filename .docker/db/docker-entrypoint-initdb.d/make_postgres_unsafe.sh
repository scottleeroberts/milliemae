config_file="$PGDATA/postgresql.conf"

sed -i -e "s/#fsync = on/fsync = off/g" $config_file
sed -i -e "s/#synchronous_commit = on/synchronous_commit = off/g" $config_file
sed -i -e "s/#full_page_writes = on/full_page_writes = off/g" $config_file
