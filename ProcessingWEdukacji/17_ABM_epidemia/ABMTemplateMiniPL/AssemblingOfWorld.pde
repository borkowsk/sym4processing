// World is a one of two central class of each ABM model
///////////////////////////////////////////////////////////////
int StepCounter=0;//GLOBALNY LICZNIK KROKÓW SYMULACJI

class World
{
  //Agent agents[];//JEDNOWYMIAROWA TABLICA AGENTÓW
  //OR
  Agent agents[][];//DWUWYMIAROWA TABLICA AGENTÓW
  
  World(int side)//KONSTRUKTOR ŚWIATA
  {
    //agents=new Agent[side];
    //OR
    agents=new Agent[side][side];
  }
}

//BARDZIEJ ZŁOŻONE FUNKCJONALNOŚCI ZOSTAŁY ZDEFINIOWANE JAKO OSOBNE FUNKCJE
//A NIE METDY KLASY World ZE WZGLĘDU NA OGRANICZENIA SKŁADNI PROCESSINGU
///////////////////////////////////////////////////////////////////////////

void initializeModel(World world)
{
  initializeAgents(world.agents);
}

void visualizeModel(World world)
{
  visualizeAgents(world.agents);
}

void dummyChange(World world) //FUKCJE MOŻNA USUNĄĆ GDY POJAWI SIĘ
{                             //REALNY KOD MODELU
  dummyChangeAgents(world.agents);
}

void modelStep(World world)
{
   //Dummy part
   dummyChange(world);
   //OR
   //... MIEJSCE NA TWÓJ REALNY KOD MODELU np. agentsChange(world);
   
   StepCounter++;
}

///////////////////////////////////////////////////////////////////////////////////////////////
//  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - ABM: WORLD OF AGENTS FOR FILL UP
///////////////////////////////////////////////////////////////////////////////////////////////
