IAM=$(id -nu)
HDUSER='hduser'
if [ "$IAM" != "$HDUSER" ];
then
   echo "You need to be logged in as $HDUSER"
   exit
else
   echo "You are logged in as correct user $HDUSER"
fi

cd /usr/local/hadoop
sbin/stop-dfs.sh
sbin/stop-yarn.sh

cd ~
cd hdfs
rm -rf ./*

cd /tmp
rm -rf gutenberg
rm -rf gutenberg-output

cd /usr/local/hadoop/etc/hadoop
cp hdfs-site.xml.local hdfs-site.xml
cp core-site.xml.local core-site.xml

cd /usr/local/hadoop
bin/hdfs namenode -format
sbin/start-dfs.sh
sbin/start-yarn.sh

jps

cd /tmp
mkdir gutenberg
cd gutenberg/
wget http://www.gutenberg.org/cache/epub/4300/pg4300.txt

cd /usr/local/hadoop
bin/hdfs dfs -mkdir /user
bin/hdfs dfs -mkdir /user/hduser
bin/hdfs dfs -mkdir /user/hduser/gutenberg
bin/hdfs dfs -rmdir /user/hduser/gutenberg-output

bin/hdfs dfs -copyFromLocal /tmp/gutenberg/* /user/hduser/gutenberg
bin/hadoop jar share/hadoop/mapreduce/hadoop-mapreduce-examples-2.6.0.jar wordcount /user/hduser/gutenberg /user/hduser/gutenberg-output

bin/hdfs dfs -ls /user/hduser/gutenberg-output
mkdir /tmp/gutenberg-output

bin/hdfs dfs -get /user/hduser/gutenberg-output/part-r-00000 /tmp/gutenberg-output
cd /tmp
more gutenberg-output/part-r-00000
