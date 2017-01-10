set IDES_HOME="%HOME%/ides"
set ECLIPSE_VERSION_NAME="lunajee"
set ECLIPSE_HOME="%IDES_HOME%/eclipse/%ECLIPSE_VERSION_NAME%/eclipse"
set WORKSPACES_HOME="%HOME%/wss"
set WORKSPACE_HOME="%WORKSPACES_HOME%/jaulp-core"
set ECLIPSE_EXECUTABLE="%ECLIPSE_HOME%/eclipse.exe"
set VM_ARGS="-Xms384m -Xmx1024m -XX:PermSize=128M -XX:MaxPermSize=512M"
%ECLIPSE_EXECUTABLE% /i /max /high -data %WORKSPACE_HOME% -showlocation vmargs %VM_ARGS%
