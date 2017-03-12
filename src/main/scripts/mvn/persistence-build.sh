#!/bin/bash
projectNames=(
"persistence-api"
"user-data"
"address-book-data"
"resource-system-data"
"resource-bundles-data"
"user-management-data"
"message-system-data"
"dating-system-data")

cd ~/git/persistence-api
mvn -B -Dmaven.test.skip=true -DskipTests --threads 8 clean install
cd ~/git/user-data
mvn -B -Dmaven.test.skip=true -DskipTests --threads 8 clean install
cd ~/git/address-book-data
mvn -B -Dmaven.test.skip=true -DskipTests --threads 8 clean install
cd ~/git/resource-system-data
mvn -B -Dmaven.test.skip=true -DskipTests --threads 8 clean install
cd ~/git/resource-bundles-data
mvn -B -Dmaven.test.skip=true -DskipTests --threads 8 clean install
cd ~/git/user-management-data
mvn -B -Dmaven.test.skip=true -DskipTests --threads 8 clean install
cd ~/git/message-system-data
mvn -B -Dmaven.test.skip=true -DskipTests --threads 8 clean install
cd ~/git/dating-system-data
mvn -B -Dmaven.test.skip=true -DskipTests --threads 8 clean install

