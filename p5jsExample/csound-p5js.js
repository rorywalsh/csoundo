/** Csound p5.js Example
 *  Based on code posted by Steven Yi <stevenyi@gmail.com> to the Csound mailing list.
 *  Modified by RW, 2018
 *
 *  Description: Simple JS file that creates a CsoundObj
 *  object and compiles and instance of Csound. This object is global
 *  and can be accessed from the sketch.js file
 */

// Signals when csound is loaded and used from sketch.js file
var csoundLoaded = false;
var cs;

// Called when Csound WASM completes loading
function onRuntimeInitialized()
{
    cs = new CsoundObj();

    //use this code to load a .csd file and have Csound compile and start it
    var fileManger = new FileManager(['csd'], console.log);
    fileManger.fileUploadFromServer("random.csd", function(){
      cs.compileCSD("random.csd");
      cs.start();
      cs.audioContext.resume();
    });

    csoundLoaded = true;

}

function load_script(src, async)
{
    var script = document.createElement('script');
    script.src = src;
    script.async = async;
    document.head.appendChild(script);
}

// Initialize Module before WASM loads
Module = {};
Module['wasmBinaryFile'] = 'wasm/libcsound.wasm';
Module['print'] = console.log;
Module['printErr'] = console.log;
Module['onRuntimeInitialized'] = onRuntimeInitialized;

if(typeof WebAssembly !== undefined)
{
  console.log("Using WASM Csound...");
  load_script("FileManager.js", false);
  load_script("wasm/libcsound.js", false);
  load_script("wasm/FileList.js", false);
  load_script("wasm/CsoundObj.js", false);
}
