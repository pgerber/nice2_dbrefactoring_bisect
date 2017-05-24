#!/bin/bash
set -Eeu
trap 'git reset --hard' EXIT

ssh postgres 'psql -U postgres -c "drop database if exists automated_bisect;"' || true
ssh postgres 'psql -U postgres -c "create database automated_bisect with owner dbref;"'

mvn clean install -T1C -pl "customer/$1" -am -DskipTests -P assembly --batch-mode --update-snapshots

../extract.py "$1" automated_bisect

cd nice2_install
mkdir -p var/dbrefactoring

rc=0
java -XX:+UseG1GC -ea -server -Xmx1424m -XX:+UseCodeCacheFlushing -Djava.security.policy=etc/java.policy -Dch.tocco.nice2.enableUpgradeMode=true -Dch.tocco.nice2.runenv=update -Dch.tocco.nice2.disableRoleSync=true -Dch.tocco.nice2.disableLanguageSync=true -Dch.tocco.nice2.enterprisesearch.disableStartup=true -Dch.tocco.nice2.optional.ldapserver.disableStartup=true -Dch.tocco.nice2.disableStartupJsFileGeneration=true -Dch.tocco.nice2.disableSchemaModelStartupCheck=true -Dch.tocco.nice2.cms.template.synchronize.enable=false -Dch.tocco.nice2.reporting.disableStartupValidation=true -Dfile.encoding=UTF-8 -Dch.raffael.hiveapp.classloader.noreporting=false -cp 'lib/boot/*' ch.tocco.nice2.boot.Nice2 -logConfig etc/logback.xml -plugins lib/modules

path=var/log/validation-errors.txt
if [ -f "$path" ]; then
   echo "Content of $path:"
   sed 's/^/\t/' "$path"

   exit 1
fi
