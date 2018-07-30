#!/bin/bash
export IDES_HOME=${HOME}/ides
export ECLIPSE_VERSION_NAME=photonjee
export ECLIPSE_HOME=${IDES_HOME}/eclipse/${ECLIPSE_VERSION_NAME}/eclipse
export WORKSPACES_HOME=${HOME}/wss
export WORKSPACES_HOME_ECLIPSE_VERSION=${WORKSPACES_HOME}/${ECLIPSE_VERSION_NAME}
export WORKSPACE_HOME=${WORKSPACES_HOME_ECLIPSE_VERSION}/jaulp
export ECLIPSE_EXECUTABLE=${ECLIPSE_HOME}/eclipse /i /max /high
export JAVA_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu/jni/libsvnjavahl-1.so
export VM_ARGS=-Xms384m -Xmx1024m -XX:PermSize=128M -XX:MaxPermSize=512M
export JAVAAGENT_ARG=-javaagent:${ECLIPSE_HOME}/lombok.jar
export BOOTCLASSPATH_ARG=-Xbootclasspath/a:${ECLIPSE_HOME}/lombok.jar
export JAVA_LIBRARY_PATH_ARG=-Djava.library.path=${JAVA_LIBRARY_PATH}
export ECLIPSE_ARGS=${JAVAAGENT_ARG} ${BOOTCLASSPATH_ARG} ${JAVA_LIBRARY_PATH_ARG}
nice -n -5 ${ECLIPSE_EXECUTABLE} --launcher.GTK_version 2 -data ${WORKSPACE_HOME} -showlocation vmargs ${VM_ARGS} ${ECLIPSE_ARGS}