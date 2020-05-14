// Obsługa wyszukiwania obiektu po kliknięciu myszy
///////////////////////////////////////////////////////////////////////
int searchedX=-1;
int searchedY=-1;
boolean Clicked=false;
Agent  theSelected=null; 

double minDist2Selec=MAX_INT;//???
double maxTransSelec=-MAX_INT;//???

void mouseClicked()
{
  println("Mouse clicked at ",mouseX,mouseY);//DEBUG
  Clicked=true;
  theSelected=null;
  searchedX=mouseX;
  searchedY=mouseY; //Searching may be implemented in visualisation!
  //Implementing of searching is belong to you!
}
