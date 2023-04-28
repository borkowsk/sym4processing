/** @file  @brief .....       
 *  @defgroup StreamUtils Functions & classes for checking streams
 *  @date 2023.04.28 (Last modification)                        @author borkowsk
 *  @{                                             
 */ ////////////////////////////////////////////////////////////////////////////

/*_OnlyProcessingBlockBegin*/
import java.io.InputStreamReader;

/// @brief A class that allows checking the state of a JAVA PrintWriter stream.
/// @details "https://stackoverflow.com/questions/21028924/is-there-a-way-to-test-if-a-printwriter-is-open-and-ready-for-output-without-wr"
class StatePrintWriter extends PrintWriter 
{
    public StatePrintWriter(PrintWriter writer) { super/*PrintWriter*/(writer);
    }

    public boolean isOpen() 
    {
        return out != null;
    }
}
/*_OnlyProcessingBlockEnd*/

/*_OnlyProcessingBlockBegin*/
/// @brief A class that allows checking the state of a `BufferedReader` stream  TODO!!!
/// @details "https://stackoverflow.com/questions/981196/how-to-know-if-a-bufferedreader-stream-is-closed"
class StateBufferedReader extends BufferedReader 
{
    public StateBufferedReader(BufferedReader reader) { super(reader); }

    public boolean isOpen() 
    {
        //TODO!!!
        return false; //TMP
    }
};
/*_OnlyProcessingBlockEnd*/

boolean isOpen(PrintWriter/*_reference*/ wrrr)				   ///< GLOBAL!
{
/*_OnlyCppBlockBegin
  return wrrr@@@isOpen(); //Kropki są zawsze zmieniane na -> ale @ @ @ na kropki :-D
_OnlyCppBlockEnd*/
/*_OnlyProcessingBlockBegin*/
  StatePrintWriter chk = new StatePrintWriter(wrrr);
  return chk.isOpen();
/*_OnlyProcessingBlockEnd*/
}

/*_OnlyProcessingBlockBegin*/
/// Atrapa C-owej funkcji system, ale chyba nie do końca działająca 
///                                                (mkdir xxxxxxx/ nie działa!)
/// @see
/// \n "https://stackoverflow.com/questions/792024/how-to-execute-system-commands-linux-bsd-using-java"
/// \n "https://docs.oracle.com/javase/7/docs/api/java/io/InputStreamReader.html"
int system(String cmd)				                                  ///< GLOBAL!
{
  println("Executing system command:'"+cmd+"'");
  Runtime r = Runtime.getRuntime();
  try{
      Process p = r.exec(cmd);
      delay(1000);
      
      BufferedReader b = new BufferedReader(new InputStreamReader(p.getInputStream()));
      String line = "";
  
      while ((line = b.readLine()) != null) {
          println(line);
      
      p.waitFor();
    }

    b.close();
  }
  catch (IOException e) 
  {
    e.printStackTrace();
    return -1;
  }
  catch (InterruptedException e)
  {
    e.printStackTrace();
    return -2;
  }
  return 0;
}
/*_OnlyProcessingBlockEnd*/

//******************************************************************************
/// See: "https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI" 
//* USEFUL COMMON CODES - HANDY FUNCTIONS & CLASSES
/// @}
//******************************************************************************        

