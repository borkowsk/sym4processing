/// @file uFileAppend.pde
/// Tools for CSV files.
/// @date 2023.03.04 (Last modification)
//*///////////////////////////////////////////////////////////////////////
import java.io.BufferedWriter;
import java.io.FileWriter;

/// Appends text to the end of a text file located in the data directory. 
/// @note It creates the file if it does not exist!
/// Can be used for big files with lots of rows, 
/// existing lines will not be rewritten.
/// See: https://stackoverflow.com/questions/17010222/how-do-i-append-text-to-a-csv-txt-file-in-processing
void appendTextToFile(String filename, String text)
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

/// Creates a new file including all subfolders in the path.
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

//*/////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - OPTIONAL TOOLS 
//*  - FUNCTIONS & CLASSES
//*  https://github.com/borkowsk/sym4processing
//*/////////////////////////////////////////////////////////////////////////////
