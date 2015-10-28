IAM=$(id -nu)
HDUSER='hduser'
if [ "$IAM" != "$HDUSER" ];
then
   echo "You need to be logged in as $HDUSER"
   exit
else
   echo "Correct user"
fi


cd /usr/local/hbase
bin/stop-hbase.sh

cd /usr/local/hadoop
sbin/stop-yarn.sh
sbin/stop-dfs.sh

cd /usr/local/hadoop/etc/hadoop
cp hdfs-site.xml.local hdfs-site.xml
cp core-site.xml.local core-site.xml

cd /usr/local/hbase/conf
cp hbase-site.xml.local hbase-site.xml

cd /usr/local/hadoop
bin/hdfs namenode -format
sbin/start-dfs.sh
sbin/start-yarn.sh

cd /usr/local/hbase/
bin/start-hbase.sh

jps
