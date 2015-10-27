IAM=$(id -nu)
HDUSER='hduser'
if [ "$IAM" != "$HDUSER" ];
then
   echo "You need to be logged in as $HDUSER"
   exit
else
   echo "You are logged in as correct user $HDUSER"
fi

# Stop Everthing
cd /usr/local/hadoop
sbin/stop-dfs.sh
sbin/stop-yarn.sh

# Remove existing data
cd ~
cd hdfs
rm -rf ./*

cd /tmp
rm -rf gutenberg
rm -rf gutenberg-output

# Copy the local hdfs configuration into the live
cd /usr/local/hadoop/etc/hadoop
cp hdfs-site.xml.local hdfs-site.xml
cp core-site.xml.local core-site.xml

# Start Hadoop
cd /usr/local/hadoop
bin/hdfs namenode -format
sbin/start-dfs.sh
sbin/start-yarn.sh

# Check that Processes are running i.e. datanode, namenodes etc.
jps

# Download data file to be processed
cd /tmp
mkdir gutenberg
cd gutenberg/
wget http://www.gutenberg.org/cache/epub/4300/pg4300.txt

# Create the HDFS directory structures, and clean up
cd /usr/local/hadoop
bin/hdfs dfs -mkdir /user
bin/hdfs dfs -mkdir /user/hduser
bin/hdfs dfs -mkdir /user/hduser/gutenberg
bin/hdfs dfs -rmdir /user/hduser/gutenberg-output

# Copy raw data file to hdfs
bin/hdfs dfs -copyFromLocal /tmp/gutenberg/* /user/hduser/gutenberg

# Run Mapreduce
bin/hadoop jar share/hadoop/mapreduce/hadoop-mapreduce-examples-2.6.0.jar wordcount /user/hduser/gutenberg /user/hduser/gutenberg-output

# Do a HDFS listing
bin/hdfs dfs -ls /user/hduser/gutenberg-output

# Create unix directory
mkdir /tmp/gutenberg-output

# Copy output file of Mapreduce process, from HDFS to Unix filesystem
bin/hdfs dfs -get /user/hduser/gutenberg-output/part-r-00000 /tmp/gutenberg-output
cd /tmp

# See the output
more gutenberg-output/part-r-00000
