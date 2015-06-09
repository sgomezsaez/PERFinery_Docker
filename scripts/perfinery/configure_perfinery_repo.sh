#!/bin/bash

set -e 

PROVISIONING_HOME=../../
PERFINERY_PACKAGE=$1
PERFINERY_REPO_DIR=$2

REPOSITORY_PATH="\/opt\/perfinery_repo"
POLICY_TYPE_NS="http\%3A\%2F\%2Fexample.com\%2FPolicyTypes"
POLICY_TEMPLATE_NS="http\%3A\%2F\%2Fwww.example.org\%2FPolicyTemplates"

echo "configuring PERFinery $PERFINERY_PACKAGE repo in $PERFINERY_REPO_DIR ..."

echo "creating temporal dir in $(pwd)"
mkdir -p tmp

cp $PERFINERY_PACKAGE/winery.war ./tmp/winery.war

cd tmp
unzip winery.war > /dev/null 2>&1

sed -i "s/\(repositoryPath=\).*$/\1$REPOSITORY_PATH/"  ./WEB-INF/classes/winery.properties

sed -i "s/\(policyTypeNamespace=\).*$/\1$POLICY_TYPE_NS/"  ./WEB-INF/classes/winery.properties

sed -i "s/\(policyTemplateNamespace=\).*$/\1$POLICY_TEMPLATE_NS/"  ./WEB-INF/classes/winery.properties

zip -r -u $PERFINERY_PACKAGE/winery.war ./WEB-INF/classes/winery.properties > /dev/null 2>&1

cd ..

rm -R tmp
