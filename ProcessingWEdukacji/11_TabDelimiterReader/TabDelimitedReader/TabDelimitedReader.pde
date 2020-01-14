//Czytanie danych tekstowych  
String fileName="positions.txt";
BufferedReader reader;
String line;
 
void setup() 
{
  // Open the file from the createWriter() example
  reader = createReader(fileName);    
}
 
void draw() 
{
  try { //Magia łapania wyjątków czyli sytuacji awaryjnych
    line = reader.readLine();
  } catch (IOException e) {
    e.printStackTrace();//Drukujemy informacje co sie stało
    line = null;
  }
  
  if (line == null) {
    // Stop reading because of an error or file is empty
    noLoop();  
  } else {
    String[] pieces = split(line, TAB);
    int x = int(pieces[0]);
    int y = int(pieces[1]);
    point(x, y);
  }
} 
