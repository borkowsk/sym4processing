
String[] lines; ///< Korpus języka
IntDict   syllFreq= new IntDict(); ///< Frekwencja poszczególnych sylab

void setup() 
{
  // Pobieranie bazy CMU Pronouncing Dictionary
  lines = loadStrings("https://svn.code.sf.net/p/cmusphinx/code/trunk/cmudict/cmudict-0.7b");
}

int i=0;
//Każde wywołanie draw() przetwarza jedną linię pobranego korpusu.
void draw() 
{
   String oneLine=lines[i++];
   String[] splitted=split(oneLine,' ');
   char first=splitted[0].charAt(0);
   char last=splitted[0].charAt(splitted[0].length()-1);
   if(Character.isAlphabetic(first)
   && Character.isAlphabetic(last)
   )
   {
     print(splitted[0],"->");
     String[] syls=getSyllables(splitted[0]);
     for(String s:syls)
         print('('+s+')');
     println();    
   }

}
