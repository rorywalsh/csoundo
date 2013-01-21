/*
 *  This AndroidBuild.java has been modified for use with Csoundo, which
 * enables the use of the Csound Android Library for Processing Android apps.
 * Implemented:
 * Csound Android library dependency line added to project.properties @line 328
 * a filter for .jar libraries only required in Java Mode @line 472.
 * locating and moving .csd file from data folder to res/raw @line 370.
 * (All conditionally based so non-Csoundo sketches will still build)
 *
 * @modifed by Conor Robotham 10/11/12
 */

// Decompiled by Jad v1.5.8g. Copyright 2001 Pavel Kouznetsov.
// Jad home page: http://www.kpdus.com/jad.html
// Decompiler options: packimports(3) 
// Source File Name:   AndroidBuild.java

package processing.mode.android;

import java.io.*;
import java.util.ArrayList;
import java.util.Iterator;
import org.apache.tools.ant.*;
import processing.app.*;
import processing.app.exec.ProcessHelper;
import processing.app.exec.ProcessResult;
import processing.core.PApplet;
import processing.mode.java.JavaBuild;

// Referenced classes of package processing.mode.android:
//            Manifest, AndroidPreprocessor, AndroidMode, AndroidSDK

class AndroidBuild extends JavaBuild
{

    public AndroidBuild(Sketch sketch, AndroidMode mode)
    {
        super(sketch);
        sdk = mode.getSDK();
        coreZipFile = mode.getCoreZipLocation();
    }

    public File build(String target)
        throws IOException, SketchException
    {
        this.target = target;
        File folder = createProject();
        if(folder != null && !antBuild())
            return null;
        else
            return folder;
    }

    protected boolean ignorableImport(String pkg)
    {
        if(pkg.startsWith("android."))
            return true;
        if(pkg.startsWith("java."))
            return true;
        if(pkg.startsWith("javax."))
            return true;
        if(pkg.startsWith("org.apache.http."))
            return true;
        if(pkg.startsWith("org.json."))
            return true;
        if(pkg.startsWith("org.w3c.dom."))
            return true;
        if(pkg.startsWith("org.xml.sax."))
            return true;
        if(pkg.startsWith("processing.core."))
            return true;
        if(pkg.startsWith("processing.data."))
            return true;
        if(pkg.startsWith("processing.event."))
            return true;
        return pkg.startsWith("processing.opengl.");
    }

    public File createProject()
        throws IOException, SketchException
    {
        tmpFolder = createTempBuildFolder(sketch);
        srcFolder = new File(tmpFolder, "src");
        binFolder = srcFolder;
        if(Base.DEBUG)
            Base.openFolder(tmpFolder);
        manifest = new Manifest(sketch);
        AndroidPreprocessor preproc = new AndroidPreprocessor(sketch, getPackageName());
        preproc.initSketchSize(sketch.getMainProgram());
        sketchClassName = preprocess(srcFolder, manifest.getPackageName(), preproc, false);
        if(sketchClassName != null)
        {
            File tempManifest = new File(tmpFolder, "AndroidManifest.xml");
            manifest.writeBuild(tempManifest, sketchClassName, target.equals("debug"));
            writeAntProps(new File(tmpFolder, "ant.properties"));
            buildFile = new File(tmpFolder, "build.xml");
            writeBuildXML(buildFile, sketch.getName());
            writeProjectProps(new File(tmpFolder, "project.properties"));
            writeLocalProps(new File(tmpFolder, "local.properties"));
            File resFolder = new File(tmpFolder, "res");
            writeRes(resFolder, sketchClassName);
            File libsFolder = mkdirs(tmpFolder, "libs");
            File assetsFolder = mkdirs(tmpFolder, "assets");
            Base.copyFile(coreZipFile, new File(libsFolder, "processing-core.jar"));
            copyLibraries(libsFolder, assetsFolder);
            copyCodeFolder(libsFolder);
            File sketchDataFolder = sketch.getDataFolder();
            if(sketchDataFolder.exists())
                Base.copyDir(sketchDataFolder, assetsFolder);
            File sketchResFolder = new File(sketch.getFolder(), "res");
            if(sketchResFolder.exists())
                Base.copyDir(sketchResFolder, resFolder);
        }
        return tmpFolder;
    }

    private File createTempBuildFolder(Sketch sketch)
        throws IOException
    {
        File tmp = File.createTempFile("android", "sketch");
        if(!tmp.delete() || !tmp.mkdir())
            throw new IOException((new StringBuilder()).append("Cannot create temp dir ").append(tmp).append(" to build android sketch").toString());
        else
            return tmp;
    }

    protected File createExportFolder()
        throws IOException
    {
        File androidFolder = new File(sketch.getFolder(), "android");
        if(androidFolder.exists())
        {
            String stamp = AndroidMode.getDateStamp(androidFolder.lastModified());
            File dest = new File(sketch.getFolder(), (new StringBuilder()).append("android.").append(stamp).toString());
            boolean result = androidFolder.renameTo(dest);
            if(!result)
            {
                ProcessResult pr;
                try
                {
                    System.err.println("createProject renameTo() failed, resorting to mv/move instead.");
                    ProcessHelper mv = new ProcessHelper(new String[] {
                        "mv", androidFolder.getAbsolutePath(), dest.getAbsolutePath()
                    });
                    pr = mv.execute();
                }
                catch(InterruptedException e)
                {
                    e.printStackTrace();
                    return null;
                }
                if(!pr.succeeded())
                {
                    System.err.println(pr.getStderr());
                    Base.showWarning("Failed to rename", (new StringBuilder()).append("Could not rename the old \u201Candroid\u201D build folder.\nPlease delete, close, or rename the folder\n").append(androidFolder.getAbsolutePath()).append("\n").append("and try again.").toString(), null);
                    Base.openFolder(sketch.getFolder());
                    return null;
                }
            }
        } else
        {
            boolean result = androidFolder.mkdirs();
            if(!result)
            {
                Base.showWarning("Folders, folders, folders", "Could not create the necessary folders to build.\nPerhaps you have some file permissions to sort out?", null);
                return null;
            }
        }
        return androidFolder;
    }

    public File exportProject()
        throws IOException, SketchException
    {
        target = "debug";
        File projectFolder = createProject();
        if(projectFolder != null)
        {
            File exportFolder = createExportFolder();
            Base.copyDir(projectFolder, exportFolder);
            return exportFolder;
        } else
        {
            return null;
        }
    }

    public boolean exportPackage()
        throws IOException, SketchException
    {
        File projectFolder = build("release");
        if(projectFolder == null)
        {
            return false;
        } else
        {
            File exportFolder = createExportFolder();
            Base.copyDir(projectFolder, exportFolder);
            return true;
        }
    }

    protected boolean antBuild()
        throws SketchException
    {
        Project p = new Project();
        String path = buildFile.getAbsolutePath().replace('\\', '/');
        p.setUserProperty("ant.file", path);
        p.setUserProperty("build.compiler", "extJavac");
        DefaultLogger consoleLogger = new DefaultLogger();
        consoleLogger.setErrorPrintStream(System.err);
        consoleLogger.setOutputPrintStream(System.out);
        consoleLogger.setMessageOutputLevel(2);
        p.addBuildListener(consoleLogger);
        DefaultLogger errorLogger = new DefaultLogger();
        ByteArrayOutputStream errb = new ByteArrayOutputStream();
        PrintStream errp = new PrintStream(errb);
        errorLogger.setErrorPrintStream(errp);
        ByteArrayOutputStream outb = new ByteArrayOutputStream();
        PrintStream outp = new PrintStream(outb);
        errorLogger.setOutputPrintStream(outp);
        errorLogger.setMessageOutputLevel(2);
        p.addBuildListener(errorLogger);
        try
        {
            p.fireBuildStarted();
            p.init();
            ProjectHelper helper = ProjectHelper.getProjectHelper();
            p.addReference("ant.projectHelper", helper);
            helper.parse(p, buildFile);
            p.executeTarget(target);
            return true;
        }
        catch(BuildException e)
        {
            p.fireBuildFinished(e);
        }
        antBuildProblems(new String(outb.toByteArray()), new String(errb.toByteArray()));
        return false;
    }

    void antBuildProblems(String outPile, String errPile)
        throws SketchException
    {
        String outLines[] = outPile.split(System.getProperty("line.separator"));
        String errLines[] = errPile.split(System.getProperty("line.separator"));
        String arr$[] = outLines;
        int len$ = arr$.length;
        for(int i$ = 0; i$ < len$; i$++)
        {
            String line = arr$[i$];
            String javacPrefix = "[javac]";
            int javacIndex = line.indexOf("[javac]");
            if(javacIndex == -1)
                continue;
            int offset = javacIndex + "[javac]".length() + 1;
            String pieces[] = PApplet.match(line.substring(offset), "^(.+):([0-9]+):\\s+(.+)$");
            if(pieces == null)
                continue;
            String fileName = pieces[1];
            fileName = fileName.substring(fileName.lastIndexOf(File.separatorChar) + 1);
            int lineNumber = PApplet.parseInt(pieces[2]) - 1;
            SketchException rex = placeException(pieces[3], fileName, lineNumber);
            if(rex != null)
                throw rex;
        }

        SketchException skex = new SketchException("Error from inside the Android tools, check the console.");
        String arr1$[] = errLines;
        int len1$ = arr1$.length;
        for(int i1$ = 0; i1$ < len1$; i1$++)
        {
            String line = arr1$[i1$];
            if(line.contains("Unable to resolve target 'android-10'"))
            {
                System.err.println("Use the Android SDK Manager (under the Android");
                System.err.println("menu) to install the SDK platform and ");
                System.err.println("Google APIs for Android 2.3.3 (API 10)");
                skex = new SketchException("Please install the SDK platform and Google APIs for API 10");
            }
        }

        skex.hideStackTrace();
        throw skex;
    }

    String getPathForAPK()
    {
        String suffix = target.equals("release") ? "unsigned" : "debug";
        String apkName = (new StringBuilder()).append("bin/").append(sketch.getName()).append("-").append(suffix).append(".apk").toString();
        File apkFile = new File(tmpFolder, apkName);
        if(!apkFile.exists())
            return null;
        else
            return apkFile.getAbsolutePath();
    }

    private void writeAntProps(File file)
    {
        PrintWriter writer = PApplet.createWriter(file);
        writer.println((new StringBuilder()).append("application-package=").append(getPackageName()).toString());
        writer.flush();
        writer.close();
    }

    private void writeBuildXML(File file, String projectName)
    {
        PrintWriter writer = PApplet.createWriter(file);
        writer.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
        writer.println((new StringBuilder()).append("<project name=\"").append(projectName).append("\" default=\"help\">").toString());
        writer.println("  <property file=\"local.properties\" />");
        writer.println("  <property file=\"ant.properties\" />");
        writer.println("  <property environment=\"env\" />");
        writer.println("  <condition property=\"sdk.dir\" value=\"${env.ANDROID_HOME}\">");
        writer.println("       <isset property=\"env.ANDROID_HOME\" />");
        writer.println("  </condition>");
        writer.println("  <loadproperties srcFile=\"project.properties\" />");
        writer.println("  <fail message=\"sdk.dir is missing. Make sure to generate local.properties using 'android update project'\" unless=\"sdk.dir\" />");
        writer.println("  <import file=\"custom_rules.xml\" optional=\"true\" />");
        writer.println("  <!-- version-tag: 1 -->");
        writer.println("  <import file=\"${sdk.dir}/tools/ant/build.xml\" />");
        writer.println("</project>");
        writer.flush();
        writer.close();
    }

    private void writeProjectProps(File file)
    {
        PrintWriter writer = PApplet.createWriter(file);
        writer.println("target=android-10");
        writer.println();
        writer.println("# Suppress the javac task warnings about \"includeAntRuntime\"");
        writer.println("build.sysclasspath=last");
         //Csoundo library requirement for Android Dependency(CsoundAndroid placed above)
        File sketchFolder = sketch.getFolder();
        File csdFile= new File(sketchFolder, "data/"+sketch.getName()+".csd");
        if(csdFile.exists()){
            if(Base.isWindows())
                writer.println("android.library.reference.1=..\\\\..\\\\..\\\\..\\\\My Documents\\\\Processing\\\\libraries\\\\CsoundAndroid");
            else if(Base.isLinux()){
                String androidRef = "android.library.reference.1=../.."+System.getenv("HOME")+"/sketchbook/libraries/CsoundAndroid";
                writer.println(androidRef);
            }
        }
        writer.flush();
        writer.close();
    }

    private void writeLocalProps(File file)
    {
        PrintWriter writer = PApplet.createWriter(file);
        String sdkPath = sdk.getSdkFolder().getAbsolutePath();
        if(Base.isWindows())
            writer.println((new StringBuilder()).append("sdk.dir=").append(sdkPath.replace('\\', '/')).toString());
        else
            writer.println((new StringBuilder()).append("sdk.dir=").append(sdkPath).toString());
        writer.flush();
        writer.close();
    }

    private void writeRes(File resFolder, String className)
        throws SketchException
    {
        File layoutFolder = mkdirs(resFolder, "layout");
        File layoutFile = new File(layoutFolder, "main.xml");
        writeResLayoutMain(layoutFile);
        File sketchFolder = sketch.getFolder();
        File localIcon36 = new File(sketchFolder, "icon-36.png");
        File localIcon48 = new File(sketchFolder, "icon-48.png");
        File localIcon72 = new File(sketchFolder, "icon-72.png");
        File buildIcon48 = new File(resFolder, "drawable/icon.png");
        File buildIcon36 = new File(resFolder, "drawable-ldpi/icon.png");
        File buildIcon72 = new File(resFolder, "drawable-hdpi/icon.png");
        
        //Csoundo Library requirement for Android Build
        File csdFile= new File(sketchFolder, "data/"+sketch.getName()+".csd");
        File buildCsdFile = new File(resFolder, "raw/"+sketch.getName().toLowerCase()+".csd");

        try
            {
                if(csdFile.exists() && (new File(resFolder, "raw")).mkdirs()){
                    Base.copyFile(csdFile, buildCsdFile);
                }
            }
         catch(IOException e)
            {
                System.err.println("Problem while copying .csd file.");
                e.printStackTrace();
            }
        
        if(!localIcon36.exists() && !localIcon48.exists() && !localIcon72.exists())
            try
            {
                if(buildIcon36.getParentFile().mkdirs())
                    Base.copyFile(mode.getContentFile("icons/icon-36.png"), buildIcon36);
                else
                    System.err.println("Could not create \"drawable-ldpi\" folder.");
                if(buildIcon48.getParentFile().mkdirs())
                    Base.copyFile(mode.getContentFile("icons/icon-48.png"), buildIcon48);
                else
                    System.err.println("Could not create \"drawable\" folder.");
                if(buildIcon72.getParentFile().mkdirs())
                    Base.copyFile(mode.getContentFile("icons/icon-72.png"), buildIcon72);
                else
                    System.err.println("Could not create \"drawable-hdpi\" folder.");
            }
            catch(IOException e)
            {
                e.printStackTrace();
            }
        else
            try
            {
                if(localIcon36.exists() && (new File(resFolder, "drawable-ldpi")).mkdirs())
                    Base.copyFile(localIcon36, buildIcon36);
                if(localIcon48.exists() && (new File(resFolder, "drawable")).mkdirs())
                    Base.copyFile(localIcon48, buildIcon48);
                if(localIcon72.exists() && (new File(resFolder, "drawable-hdpi")).mkdirs())
                    Base.copyFile(localIcon72, buildIcon72);
            }
            catch(IOException e)
            {
                System.err.println("Problem while copying icons.");
                e.printStackTrace();
            }
    }

    private File mkdirs(File parent, String name)
        throws SketchException
    {
        File result = new File(parent, name);
        if(!result.exists() && !result.mkdirs())
            throw new SketchException((new StringBuilder()).append("Could not create ").append(result).toString());
        else
            return result;
    }

    private void writeResLayoutMain(File file)
    {
        PrintWriter writer = PApplet.createWriter(file);
        writer.println("<?xml version=\"1.0\" encoding=\"utf-8\"?>");
        writer.println("<LinearLayout xmlns:android=\"http://schemas.android.com/apk/res/android\"");
        writer.println("              android:orientation=\"vertical\"");
        writer.println("              android:layout_width=\"fill_parent\"");
        writer.println("              android:layout_height=\"fill_parent\">");
        writer.println("</LinearLayout>");
        writer.flush();
        writer.close();
    }

    private void copyLibraries(File libsFolder, File assetsFolder)
        throws IOException
    {
        for(Iterator i$ = getImportedLibraries().iterator(); i$.hasNext();)
        {
            Library library = (Library)i$.next();
            File arr$[] = library.getAndroidExports();
            int len$ = arr$.length;
            int i2$ = 0;
            while(i2$ < len$) 
            {
                File exportFile = arr$[i2$];
                String exportName = exportFile.getName();
                if(!exportFile.exists())
                    System.err.println((new StringBuilder()).append(exportFile.getName()).append(" is mentioned in export.txt, but it's ").append("a big fat lie and does not exist.").toString());
                else
                if(exportFile.isDirectory())
                {
                    if(exportName.equals("armeabi") || exportName.equals("armeabi-v7a") || exportName.equals("x86"))
                        Base.copyDir(exportFile, new File(libsFolder, exportName));
                    else
                        Base.copyDir(exportFile, new File(assetsFolder, exportName));
                } else
                if(exportName.toLowerCase().endsWith(".zip"))
                {
                    System.err.println(".zip files are not allowed in Android libraries.");
                    System.err.println((new StringBuilder()).append("Please rename ").append(exportFile.getName()).append(" to be a .jar file.").toString());
                    String jarName = (new StringBuilder()).append(exportName.substring(0, exportName.length() - 4)).append(".jar").toString();
                    Base.copyFile(exportFile, new File(libsFolder, jarName));
                } else
                 //Filter for Csoundo Android Mode
                if(!exportName.toLowerCase().equals("android.jar")&&!exportName.toLowerCase().equals("csnd.jar") && !exportName.toLowerCase().equals("csoundandroid.jar")){
                    if(exportName.toLowerCase().endsWith(".jar"))
                        Base.copyFile(exportFile, new File(libsFolder, exportName));
                    else
                        Base.copyFile(exportFile, new File(assetsFolder, exportName));
                }
                i2$++;
            }
        }

    }

    private void copyCodeFolder(File libsFolder)
        throws IOException
    {
        File codeFolder = sketch.getCodeFolder();
        if(codeFolder != null && codeFolder.exists())
        {
            File arr$[] = codeFolder.listFiles();
            int len$ = arr$.length;
            for(int i$ = 0; i$ < len$; i$++)
            {
                File item = arr$[i$];
                if(item.isDirectory())
                    continue;
                String name = item.getName();
                String lcname = name.toLowerCase();
                if(lcname.endsWith(".jar") || lcname.endsWith(".zip"))
                {
                    String jarName = (new StringBuilder()).append(name.substring(0, name.length() - 4)).append(".jar").toString();
                    Base.copyFile(item, new File(libsFolder, jarName));
                }
            }

        }
    }

    protected String getPackageName()
    {
        return manifest.getPackageName();
    }

    public void cleanup()
    {
        tmpFolder.deleteOnExit();
    }

    static final String basePackage = "processing.test";
    static final String sdkName = "2.3.3";
    static final String sdkVersion = "10";
    static final String sdkTarget = "android-10";
    private final AndroidSDK sdk;
    private final File coreZipFile;
    private String target;
    private Manifest manifest;
    private File tmpFolder;
    private File buildFile;
    static final String ICON_72 = "icon-72.png";
    static final String ICON_48 = "icon-48.png";
    static final String ICON_36 = "icon-36.png";
}
