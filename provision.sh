wget -O - http://packages.elasticsearch.org/GPG-KEY-elasticsearch | sudo apt-key add -
echo 'deb http://packages.elastic.co/elasticsearch/1.5/debian stable main' | sudo tee /etc/apt/sources.list.d/elasticsearch.list

service chef-client stop
update-rc.d chef-client disable

service puppet stop
update-rc.d puppet disable

if [ ! -f /var/lib/apt/periodic/update-success-stamp -o "$[$(date +%s) - $(stat -c %Z /var/lib/apt/periodic/update-success-stamp)]" -ge 86400 ]; then
  apt-get update
fi

apt-get install -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" openjdk-7-jre default-jre-headless supervisor htop elasticsearch

cd /opt

function checkTika {
  echo 'ac0b1207284b7bd591acb0b7453081cbb1ea143c650678927ffe1463be659305  tika-server-1.8.jar' | sha256sum -c
  return $?
}

if ! checkTika; then
  wget --progress=bar:force -O tika-server-1.8.jar http://repo1.maven.org/maven2/org/apache/tika/tika-server/1.8/tika-server-1.8.jar

  checkTika
fi;

cd /
cat <<EOF > /usr/local/bin/tika-rest-server
#!/bin/bash
exec java -Xms8m -Xmx24m -XX:MaxPermSize=24m -jar /opt/tika-server-1.8.jar -h 0.0.0.0 -C all
EOF
    chmod +x /usr/local/bin/tika-rest-server

    cat <<EOF > /etc/supervisor/conf.d/tika.conf
[program:tika]
command=/usr/local/bin/tika-rest-server
redirect_stderr=true
EOF

supervisorctl stop tika
service supervisor stop
service supervisor restart
supervisorctl start tika

cat <<EOF > /etc/default/elasticsearch
# Run Elasticsearch as this user ID and group ID
#ES_USER=elasticsearch
#ES_GROUP=elasticsearch

# Heap Size (defaults to 256m min, 1g max)
ES_HEAP_SIZE=256m

# Heap new generation
#ES_HEAP_NEWSIZE=

# max direct memory
#ES_DIRECT_SIZE=

# Maximum number of open files, defaults to 65535.
#MAX_OPEN_FILES=65535

# Maximum locked memory size. Set to "unlimited" if you use the
# bootstrap.mlockall option in elasticsearch.yml. You must also set
# ES_HEAP_SIZE.
#MAX_LOCKED_MEMORY=unlimited

# Maximum number of VMA (Virtual Memory Areas) a process can own
#MAX_MAP_COUNT=262144

# Elasticsearch log directory
#LOG_DIR=/var/log/elasticsearch

# Elasticsearch data directory
#DATA_DIR=/var/lib/elasticsearch

# Elasticsearch work directory
#WORK_DIR=/tmp/elasticsearch

# Elasticsearch configuration directory
#CONF_DIR=/etc/elasticsearch

# Elasticsearch configuration file (elasticsearch.yml)
#CONF_FILE=/etc/elasticsearch/elasticsearch.yml

# Additional Java OPTS
ES_JAVA_OPTS=-XX:MaxPermSize=256m

# Configure restart on package upgrade (true, every other setting will lead to not restarting)
#RESTART_ON_UPGRADE=true
EOF

update-rc.d elasticsearch defaults 95 10
service elasticsearch restart

gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
\curl -sSL https://get.rvm.io | bash -s stable --ruby=2.2.2 --with-gems="bundler"
su -l -c "rvm user gemsets" vagrant
