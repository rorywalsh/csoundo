echo "BUILD SCRIPT FOR CSOUNDO."
echo ""
echo "PLEASE EDIT THE SCRIPTS VARIABLES"
echo "SO THAT IT USES THE CORRECT PATH"

set PROCESSING_LIB=C:\Users\rory\sourcecode\processing-3.3.7\core\library\core.jar
set CSOUND_LIB=C:\PROGRA~1\Csound6_x64\bin\csnd6.jar
javac -classpath %PROCESSING_LIB%;%CSOUND_LIB% -d . *.java
jar -cf ../library/csoundo.jar ./csoundo/*.class
