// World is a one of two central class of each ABM model
///////////////////////////////////////////////////////////////
int StepCounter=0;//GLOBALNY LICZNIK KROKÓW SYMULACJI

class World
{
  Agent agents[][];//DWUWYMIAROWA TABLICA AGENTÓW
  int      env[][];//TABLICA SRODOWISKA - "environment"
  
  World(int side)//KONSTRUKTOR ŚWIATA
  {
    env=new int[side][2*side];
    agents=new Agent[side][2*side];
  }
}

//BARDZIEJ ZŁOŻONE FUNKCJONALNOŚCI ZOSTAŁY ZDEFINIOWANE JAKO OSOBNE FUNKCJE
//A NIE METODY KLASY World ZE WZGLĘDU NA OGRANICZENIA SKŁADNI PROCESSINGU
//NIE POZWALAJĄCEJ SCHOWAĆ GDZIEŚ INDZIEJ MNIEJ ISTOTNYCH METOD KLASY
///////////////////////////////////////////////////////////////////////////

void initializeModel(World world)
{
  initializeEnv(world.env);
  initializeAgents(world.agents,world.env);
}

void visualizeModel(World world)
{
  visualizeEnv(world.env);
  visualizeAgents(world.agents);
}

void modelStep(World world)
{
   //environmentChange(world.env);//W tej symulacji niepotrzebne
   agentsChange(world.agents);//TU NASTĄPI WYBÓR FUNKCJI PRZECIĄŻONEJ!
   sheduleAgents(world.agents,world.env,StepCounter);
   StepCounter++;
}

///////////////////////////////////////////////////////////////////////////////////////////////
//  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - ABM: WORLD OF AGENTS FOR FILL UP
///////////////////////////////////////////////////////////////////////////////////////////////
