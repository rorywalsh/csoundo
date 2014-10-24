PROCESSING_LIB=/home/rory/sourcecode/processing-2.2.1/core/library/core.jar
CSOUND_LIB=/home/rory/sourcecode/cabbageaudio/csound/build/csnd6.jar
javac -classpath $PROCESSING_LIB:$CSOUND_LIB -d . *.java
jar -cf csoundo.jar ./csoundo/*.class
