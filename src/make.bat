echo "BUILD SCRIPT FOR CSOUNDO."
echo ""
echo "PLEASE EDIT THE SCRIPTS VARIABLES"
echo "SO THAT IT USES THE CORRECT PATH"

set PROCESSING_LIB=C:\Program Files\processing-2.2.1\core\library\core.jar
set CSOUND_LIB=C:\Users\rory\Documents\sourcecode\cabbageaudio\csound\build\csnd6.jar
javac -classpath %PROCESSING_LIB%:%CSOUND_LIB% -d . *.java
jar -cf ../library/csoundo.jar ./csoundo/*.class
