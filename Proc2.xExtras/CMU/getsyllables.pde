/// @brief Funkcja dzieląca na sylaby. Na razie marna.
String[] getSyllables(String word) {
  ArrayList<String> syllables = new ArrayList<String>();
  
  String vowels = "aeiouyAEIOUY"; // lista samogłosek
  char[] letters = word.toCharArray(); // rozdzielenie słowa na litery
  
  String syllable = "";
  boolean lastLetterVowel = true; // czy ostatnia litera była samogłoska
  
  for (int i = 0; i < letters.length; i++) 
  {
    char letter = letters[i];
    boolean isVowel = (vowels.indexOf(letter) != -1); // czy litera jest samogłoską
    
    if (isVowel) 
    {
      if (!lastLetterVowel) 
      {
        syllables.add(syllable);
        syllable = "";
      }
      lastLetterVowel = true;
    } 
    else 
    {
      lastLetterVowel = false;
    }
    
    syllable += letter;
  }
  
  if (!syllable.equals("")) {
    syllables.add(syllable);
  }
  
  return syllables.toArray(new String[syllables.size()]);
}
