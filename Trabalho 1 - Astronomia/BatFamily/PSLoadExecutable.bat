@ECHO OFF

SET PARAMS=
:READPARAM
IF "%1"=="" GOTO ENDPARAM
SET PARAMS=%PARAMS% %1
SHIFT
GOTO READPARAM
:ENDPARAM

%JAVA_HOME%\bin\java -cp "..\bin\info.ipaw.pc3.PSLoadExecutable.jar;..\bin\info.ipaw.pc3.PSLoadWorkflow.jar;..\lib\derby.jar;..\lib\derbyclient.jar;..\lib\derbynet.jar;..\lib\derbyrun.jar;..\lib\derbytools.jar" info.ipaw.pc3.PSLoadExecutable.Execute %PARAMS%
