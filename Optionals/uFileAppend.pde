/// Tools for CSV files. ("uFileAppend.pde")
/// @date 2025-04-02 (Last modification)
//-//////////////////////////////////////////////////////////////////////////////

/// @defgroup StreamUtils Functions & classes for streams & files
/// @{                                                         
//-//////////////////////////////////////////////////////////////

/*_OnlyProcessingBlockBegin*/
import java.io.BufferedWriter; // Here we import the necessary library component.
import java.io.FileWriter;     // Here we import the necessary library component.
/*_OnlyProcessingBlockEnd*/

/// @details
///   C++ translation is disabled because this is almost pure JAVA.
///   The exported function: `void appendTextToFile(String filename, String text)`
///   must have specialised, efficient C++ version. 

/*_OnlyProcessingBlockBegin*/
/// Appends text to the end of a text file located in the data directory. 
/// @note It creates the file if it does not exist!
/// Can be used for big files with lots of rows, 
/// existing lines will not be rewritten.
/// See: https://stackoverflow.com/questions/17010222/how-do-i-append-text-to-a-csv-txt-file-in-processing
void appendTextToFile(String filename, String text) ///< GLOBAL
{
  File f = new File(dataPath(filename));
  if(!f.exists()){
    createFile(f);
  }
  try {
    PrintWriter out = new PrintWriter(new BufferedWriter(new FileWriter(f, true)));
    out.println(text);
    out.close();
  }catch (IOException e){
      e.printStackTrace();
  }
}

/// Creates a new file including all sub-folders in the path.
void createFile(File f)
{
  File parentDir = f.getParentFile();
  try{
    parentDir.mkdirs(); 
    f.createNewFile();
  }catch(Exception e){
    e.printStackTrace();
  }
}    
/*_OnlyProcessingBlockEnd*/

//*/////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - OPTIONAL TOOLS 
//*  - FUNCTIONS & CLASSES
//*  https://github.com/borkowsk/sym4processing
/// @}
//*/////////////////////////////////////////////////////////////////////////////
