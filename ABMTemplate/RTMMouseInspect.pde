//* Obsługa wyszukiwania obiektu po kliknięciu myszy
//* ABM: MOUSE EVENTS TEMPLATE
//*/////////////////////////////////////////////////////////////////////
int searchedX=-1;
int searchedY=-1;
boolean Clicked=false;
int selectedX=-1;
int selectedY=-1;
Agent selected=null;

/// Simple version of Pair containing a pair of integers
class PairOfInt
{
    public final int a;
    public final int b;

    public PairOfInt(int a,int b) 
    {
        this.a = a;
        this.b = b;
    }
};

/// This function is automatically run by Processing when 
/// any mouse button is pressed. 
/// Inside, you can use the variables 'mouseX' and 'mouseY'.
void mouseClicked()
{
  println("Mouse clicked at ",mouseX,mouseY);//DEBUG
  Clicked=true;
  searchedX=mouseX;
  searchedY=mouseY; 
  
  PairOfInt result=findCell(TheWorld.agents);//But 1D searching is belong to you!
  if(result!=null)//Znaleziono
  {
    selectedX=result.a;
    selectedY=result.b;
    if((selected=TheWorld.agents[selectedY][selectedX])!=null)
    {
      println("Cell",selectedX,selectedY,"belong to",TheWorld.agents[selectedY][selectedX]);
      //... more info about the cell & the agent
    }
    else
      println("Cell",selectedX,selectedY,"is empty");
  }
}

/// Convert mouse coordinates to cell coordinates
/// The parameter is only for checking type and SIZES
/// Works as long as the agents visualization starts at point 0,0
PairOfInt findCell(Agent[][] agents)
{ 
  int x=mouseX/cwidth;
  int y=mouseY/cwidth;
  if(0<=y && y<agents.length
  && 0<=x && x<agents[y].length)
      return new PairOfInt(x,y);
  else
      return null;
}

//*////////////////////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - ABM (Agent Base Model) TEMPLATE
//*  https://github.com/borkowsk/sym4processing
//*////////////////////////////////////////////////////////////////////////////////////////////
