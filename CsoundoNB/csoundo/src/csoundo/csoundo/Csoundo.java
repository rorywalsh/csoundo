/**
 * A Csound interface library for Processing.
 *
 * (c) 2010
 *  
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 * 
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General
 * Public License along with this library; if not, write to the
 * Free Software Foundation, Inc., 59 Temple Place, Suite 330,
 * Boston, MA  02111-1307  USA
 * 
 * @author	Jacob Joaquin http://csoundblog.com
 * @updates     Rory Walsh, Conor Robotham
 * @version	0.2.1
 */

package csoundo;

import android.content.Context;
import csnd.*;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import processing.core.*;

public class Csoundo{
    CsoundMYFLTArray table;
    PApplet myParent;
    public final static String VERSION = "0.2.1";
    boolean androidMode;
    private String csd, path;
    boolean compiledOK;
    public boolean isRunning = false;
    public MessageQueue messageQueue;
    //private Engine engine;
    private Csound csound;
    private CallbackWrapper callbackWrapper;
    public CsoundFile csoundFile;
    private CsoundPerformanceThread perfThread;	
    public SWIGTYPE_p_void v;
    public String options = "-+rtaudio=null -d -+msg_color=0 -m0d -b512";
    /**
     * The Csoundo constructor, usually called in the setup() method in your
     * sketch. Only supports 1 csd file for now, regardless of the number
     * of instances of Csoundo you are running. Your Csound csd file must
     * reside in the /data folder of your sketch and must be named after
     * the sketch for Android Mode(caps-sensitive). 
     * Set Android Mode csound options in your .csd file. Use cs.setOptions
     * to set Java Mode csound options.
     * 
     * Android Mode
     * @param theParent The PApplet. Usually pass 'this'
     * @param context Must be super.getApplicationContext.
     * 
     * Java Mode
     * @param theParent The PApplet. Usually pass 'this'
     * @param _csd The Csound file to run e.g. "myfile.csd"
     */

    //Android Mode Constructor
    public Csoundo(PApplet theParent, Context context) {

        csound = new AndroidCsound();
        csd = createTempFile(getResourceFileAsString(0x7f040000, context), context).getAbsolutePath().toLowerCase();
        androidMode=true;  
        
        setup(theParent, csound, csd);
        
        csound.PreCompile();
        csoundFile.setCommand(options + "\\" +csd);
        checkCompileStatus(csound.Compile(csd)==0);
        
    }

    //Java Mode Constructor
    public Csoundo(PApplet theParent, String _csd) {
        
        csound = new Csound();
        path = myParent.dataPath("");
        csd  = myParent.dataPath(_csd);
        
        setup(theParent, csound, csd);
        
        checkCompileStatus(csound.Compile(csd)==0);
    }
    
    private void setup(PApplet theParent, Csound csound, String csd) {
        welcome();
        csnd.csoundInitialize(null, null,
        csnd.CSOUNDINIT_NO_SIGNAL_HANDLER);
        myParent = theParent;
        messageQueue = new MessageQueue();
        callbackWrapper = new CallbackWrapper(csound);
        callbackWrapper.SetYieldCallback();
        csoundFile = new CsoundFile();
        csoundFile.setCSD(fileToString(csd));
        csoundFile.exportForPerformance();
    }
    
    //Method for Android, locates .csd file in .apk and returns it as a string.
    protected String getResourceFileAsString(int resId, Context context) {
       StringBuilder str = new StringBuilder();

       InputStream is = context.getResources().openRawResource(resId);
       BufferedReader r = new BufferedReader(new InputStreamReader(is));
       String line;

       try {
         while ((line = r.readLine()) != null) {
           str.append(line).append("\n");
         }
       } catch (IOException ios) {

       }

       return str.toString();
     }

     //Method for Android, writes .csd string to a temorary file for use with java(and Processing)
     protected File createTempFile(String csd, Context context) {
       File f = null;

       try {
         f = File.createTempFile("temp", ".csd", context.getCacheDir());
         FileOutputStream fos = new FileOutputStream(f);
         fos.write(csd.getBytes());
         fos.close();
       } catch (IOException e) {
         // TODO Auto-generated catch block
         e.printStackTrace();
       }

       return f;
     }
   
    public int performKsmps(){
        return csound.PerformKsmps();
    }  
     
    public void stopPerformKsmps(){
        csound.Stop();
    }
     
    public void dispose() {
        System.out.println("Csound dispose");
        // NOTE: 
        perfThread.Stop();
        System.out.println("perfThread waiting");
        perfThread.Join();
        System.out.println("perfThread finished");
        csound.Cleanup();
        csound.delete();
        System.out.println("Csound dispose complete");		
    }

    private void csoundPerf() {
        if (compiledOK) {
            isRunning = true;
            perfThread = new CsoundPerformanceThread(csound.GetCsound());
            perfThread.Play();
            }
    }

    /**
     * Reads a csd file into a string
     */
    private String fileToString(String path) {
            FileInputStream fin;
            StringBuilder sb = new StringBuilder();

            try {
                fin = new FileInputStream(csd);
                BufferedReader d = new BufferedReader(new InputStreamReader(fin));
                String line;
                while ((line = d.readLine()) != null) {
                            sb.append(line + "\n");
                }

                fin.close();		
            } catch (IOException e) {
                    System.err.println ("Unable to read CSD file.");
                    System.err.println (csd);

            }

            return sb.toString();
    }

    /**
     * Start Csound.
     */
    public void start() {
    csoundPerf();
    }

    public void pause() {
    perfThread.Pause();    
    }
    
    public void resume(){
    perfThread.Play();    
    }
    
    public void pre() {}

    public void post() {}

    private void welcome() {
            System.out.println("csoundo 0.2.1, Jacob Joaquin, Conor Robotham, Rory Walsh");
    }

    /**
     * return the version of the library.
     * 
     * @return String
     */
    public static String version() {
            return VERSION;
    }

    /**
     * Creates a Csound score event.
     * 
     * @param s The score event. ie "i 1 0 1 0.707 440"
     */
    public void event(String s) {
    perfThread.InputMessage(s);
    }

    /**
     * Returns the 0dbfs value, set in the orchestra header.
     * 
     * @return 0dbfs
     */
    public float get0dBFS() {
        if(!compiledOK) return 0;
        return (float) csound.Get0dBFS();
    }

    /**
     * Returns the value of the specified chn bus.
     * 
     * @return chn bus value
     */
    public float getChn(String chn) {
    if (!compiledOK) return 0;
    return (float) csound.GetChannel(chn);
    }

    /**
     * Returns the command-line options string.
     * 
     * @return command-line options
     */
    public String getOptions() {
        return options;
    }
	
    /**
     * Returns the status of csoundPerformanceThread.
     * 
     * NOTE: This is for Csoundo development and is likely to disappear
     * or be renamed.
     * 
     * @return status
     */
    public int getPerfStatus() {
    if (!compiledOK) return -99999;
    return perfThread.GetStatus();
    }

    /**
     * Return the control rate.
     * 
     * @return krate
     */
    public float kr() {
    if (!compiledOK) return 0;
    return (float) csound.GetKr();
    }

    /**
     * Return the ksmps, samples per k-block
     * 
     * @return ksmps
     */
    public float ksmps() {
    if (!compiledOK) return 0;
    return csound.GetKsmps();
    }
    
    /**
     * Return the number or audio output channels.
     * 
     * @return number of output channels
     */
    public float nchnls() {
    if (!compiledOK) return 0;
    return csound.GetNchnls();
    }

    /**
     * starts the Csound engine.
     */
    public void run() {
        //super.run();
        //System.out.println(getName());
            start();
           // perfThread = perfThread;
            while(perfThread.GetStatus() != 0) {
                System.out.println("Waiting for csoundPerformanceThread");
            }

            //csound =engine.csound;
            //mutex = engine.mutex;
            //isRunning = isRunning;
    }

    /**
     * writes channel values to queue, they will be sent to Csound at a safe time.
     */
    public void setChn(String chn, float value) {
        if(compiledOK)
        callbackWrapper.messageQueue.addMessageToChannelQueue(chn, value);
    }

    /**
     * Sets the string of the specified chn bus.
     */
    public void setChn(String chn, String sValue) {
        if(compiledOK)
        csound.SetChannel(chn, sValue);
    }
    
    /**
     * Overwrites the Csound options.
     * 
     * Default options are '-g -odac' where -g sets graphics to display
     * as ascii characters in the console output and -odac means to send
     * audio to the default digital-audio-converter.
     * 
     * @param Command-line string
     */
    public void setOptions(String s) {
        options = s;
    }
    
    /**
     * Return the samplerate.
     * 
     * @return samplerate
     */
    public float sr() {
    if(!compiledOK) return 0;
    return (float) csound.GetSr();
    }

    /**
     * Return a value from a Csound table.
     * 
     * @param t Table number
     * @param i Index
     * @return Csound table value
     */
    
    //this should only be called when performKsmps is finished a cycle
   /* public float tableGet(int t, int i) {
	if (!compiledOK) return 0;
        return (float) csound.TableGet(t, i);
    }*/

    
    public int getTable(SWIGTYPE_p_p_double tablePtr, int i) {
	if (!compiledOK) return 0;
        return csound.GetTable(tablePtr, i);
    }

// can't overload this for android interface.....    
//    public int getTable(SWIGTYPE_p_p_float tablePtr, int i) {
//	if (!compiledOK) return 0;
//        return csound.GetTable(tablePtr, i);
//    }
        
   

    /**
     * Return the length of a Csound table.
     * 
     * @param t Table number
     * @return Csound table length
     */
    //as above    
    public int tableLength(int t) {
    if(!compiledOK) return -99999;
    return csound.TableLength(t);
    }

    /**
     *  Writes table changes to a queue, they will be sent to Csound at a safe time.
     * 
     * @param t Table number
     * @param i Index
     * @param v Value
     */
    public void tableSet(int t, int i, float v){
        if(compiledOK)
        callbackWrapper.messageQueue.addMessageToTableQueue(t, i, v);
    }

    
    private void checkCompileStatus(boolean status){
     
        if(status) {
            compiledOK = true;
            System.out.println("Csound compiled your file without error");
        }
        else{
            compiledOK = false;
            System.out.println("Csound failed to compile your file");
        }
    }

    
}
