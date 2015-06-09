#!/bin/bash

# Maintainer: Santiago Gomez Saez - santiago.gomez-saez@iaas.uni-stuttgart.de

set -e

print_usage()
{
        echo " Parameters:"
        echo "-d"
        echo "          ::: PERFinery Dir"
}

echo "-->Welcome to PERFinery"

if [ $# -eq 0 ]
then
        print_usage
else

	PROVISIONING_HOME=$(pwd)
	PERFINERY_DIR=$2
	PERFINERY_REPO_DIR=$PROVISIONING_HOME/perfinery_repo
	PERFINERY_PORT=8090
	IPADD=$(ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')
	
	if which docker >/dev/null; then
    		echo "-->Docker already installed"
	else
    		echo "-->Docker not installed"
		echo "-->Installing Docker Engine"
		sudo apt-get update $ sudo apt-get install wget
		wget -qO- https://get.docker.com/ | sh
		if which docker >/dev/null; then
			echo "-->Docker installed correctly"
		else 
			echo "-->Docker not installed"
			exit 1
		fi
	fi


	echo "-->Installing PERFinery in $PERFINERY_DIR ..."

	if [ ! -d "$PERFINERY_DIR" ]; then
  		mkdir -p $PERFINERY_DIR
	fi

	echo "-->Creating PERFinery repo in $PERFINERY_REPO_DIR ..."

	if [ ! -d "$PERFINERY_REPO_DIR" ]; then
                mkdir -p $PERFINERY_REPO_DIR
        fi

	PROVISIONING_HOME_DIR=$(pwd)
	
	#TODO: clone from git the PERFinery binaries
	#git clone ......

	if [ ! -d "$PERFINERY_DIR/tomcat/webapps" ]; then
                echo "-->Creating tomcat webapps folder"
                mkdir -p $PERFINERY_DIR/tomcat/webapps
        fi

	echo "-->Adapting Dockerfile with PERFINERY_DIR..."
	mv Dockerfile Dockerfile.tmp
	export TOMCAT_WEBAPPS_PERFINERY="$PERFINERY_DIR/tomcat/webapps"
	export PERFINERY_REPO_DIR="$PERFINERY_REPO_DIR"
	cat Dockerfile.tmp | envsubst '$TOMCAT_WEBAPPS_PERFINERY $PERFINERY_REPO_DIR' > Dockerfile	

	echo "-->Building PERFinery..."
	sudo docker build -t perfinery/base .
	echo "-->PERFinery Built!!"

	# Restoring original Dockerfile
	mv Dockerfile.tmp Dockerfile

	echo "-->Starting PERFinery Container..."

	sudo docker run -p $IPADD:$PERFINERY_PORT:8080 -net host -v $PERFINERY_DIR/tomcat/webapps:/opt/tomcat/webapps -v $PERFINERY_REPO_DIR:/opt/perfinery_repo -d perfinery/base

	#TODO:get bineries from git and drop them in the tomcat/webapps

#	while [ ! "$(ls -A "$PERFINERY_DIR/tomcat/webapps")" ]
#	do
#		sleep 3
#	done

	 #TODO: replace repository uri from war
        echo "-->Configuring PERFinery with directory $PERFINERY_REPO_DIR ..."
        cd ./scripts/perfinery
        chmod 755 *.sh
        ./configure_perfinery_repo.sh $PROVISIONING_HOME_DIR/packages $PERFINERY_REPO_DIR
        cd $PROVISIONING_HOME
	
	#TODO:change when using git
	cp packages/winery.war $PERFINERY_DIR/tomcat/webapps/winery.war
	cp packages/winery-topologymodeler.war $PERFINERY_DIR/tomcat/webapps/winery-topologymodeler.war
	
	#TODO: change when using perfinery
	echo "### Installation Summary ###"
	echo "PERFinery installed in $PERFINERY_DIR"
	echo "PERFinery repository deployed in $PERFINERY_REPO_DIR"
	echo "PERFinery running on $IPADD:$PERFINERY_PORT/winery and $IPADD:$PERFINERY_PORT/winery-topologymodeler..."
	echo "############################"
fi
