#!/usr/bin/env sh
gradle init
git add -f gradle/wrapper/gradle-wrapper.jar
git add -f gradle/wrapper/gradle-wrapper.properties
chmod +x gradlew
chmod +x gradle/wrapper/gradle-wrapper.jar