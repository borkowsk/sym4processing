// Agent is a one of two central class of each ABM model
// Agent need to be initialised & they need logic of change 
///////////////////////////////////////////////////////////////

void initializeAgents(Agent[][] agents,int[][] env)
{
   //Umieszczamy agentow w domach i szukamy im pracy
   for(int a=0;a<agents.length;a++)
    for(int b=0;b<agents[a].length;b++)
      if(env[a][b]==Env_FLAT && random(1)<density)//Tylko w obszarach mieszkalnych
      {
        Agent curr=new Agent();
        //DODATKOWY KOD INICJALIZACJI AGENTÓW, np. curr.initialise();
        curr.flatX=curr.workX=b;
        curr.flatY=curr.workY=a;
        liveCount++;
        
        //Kazdemu agentowi dajemy N szans znalezienia miejsca pracy
        for(int i=0;i<Nprob;i++)
        {
          curr.workX=int(random(agents[0].length));
          curr.workY=int(random(agents.length));
          if( env[curr.workY][curr.workX]/100==1 //Wszystkie miejsca pracy mają wartość w zakresie 100-199
          &&  (env[curr.workY][curr.workX] & 1) !=1 //Jak zajęte to ma na końcu jedynkę. Taka sztuczka   
          )
          {
             env[curr.workY][curr.workX] |= 1;//Zaklepuje sobie top miejsce pracy
             break;//Mam już miejsce pracy
          }
          else //Nadal pracuje w domu
          {
            curr.workX=curr.flatX;
            curr.workY=curr.flatY;
          }
          
          agents[a][b]=curr;
        }
      }
      
   //Inicjowanie infekcji z pozycji losowej
   int a=int(random(agents.length));
   int b=int(random(agents[0].length));
   if(agents[a][b]==null)//Gdyby go nie było
   {
      agents[a][b]=new Agent();
      liveCount++;
   }
   agents[a][b].state=Infected;
}

void  agentsChange(Agent[][] agents)//do zmiany na agentsChange()
{
  //Zapamiętujemy stan przed krokiem
  int befInfected=sumInfected;
  int befRecovered=sumRecovered;
  int befDeath=sumDeath;
  
  int MC=agents.length*agents[0].length;
  for(int i=0;i<MC;i++)
  {
    int a=(int)random(0,agents.length);//agents[a].lenght na wypadek gdyby nam przyszło do głowy zrobić prostokąt
    int b=(int)random(0,agents[a].length);//print(a,b,' ');
    if(agents[a][b]!= null )
    {
       //Jesli pusty lub zdrowy to nic nie robimy
       if(agents[a][b].state<Infected || Recovered<=agents[a][b].state) continue;
       
       //Wyliczenie lokalizacji sąsiadów
       int dw=(a+1) % agents.length;   
       int up=(agents.length+a-1) % agents.length;
       int right = (b+1) % agents[a].length;      
       int left  = (agents[a].length+b-1) % agents[a].length;

       if(agents[a][left]!=null
       && agents[a][left].state==Susceptible && random(1) < 1-agents[a][left].immunity )
         {agents[a][left].state=Infected; sumInfected++;}
        
       if(agents[a][right]!=null
       && agents[a][right].state==Susceptible && random(1) < 1-agents[a][right].immunity )
         {agents[a][right].state=Infected; sumInfected++;}
        
       if(agents[up][b]!=null
       && agents[up][b].state==Susceptible && random(1) < 1-agents[up][b].immunity )
         {agents[up][b].state=Infected; sumInfected++;}
        
       if(agents[dw][b]!=null
       && agents[dw][b].state==Susceptible && random(1) < 1-agents[dw][b].immunity ) 
         {agents[dw][b].state=Infected; sumInfected++;}

       float prob=random(1);//Los na dany dzień
       
       if(prob<PDeath) //Albo tego dnia umiera
        { 
          sumDeath++;liveCount--;
          //agents[a][b]=null;//Można by dawać mu stan "dead", ale...
          agents[a][b].state=Death;//Ale to trzeba uwzglednić przy statystyce!
        }
        else
        {
          //Albo jest wyleczony
          if(++(agents[a][b].state)==Recovered)
          {
              sumRecovered++;
              //agents[a][b].immunity=1;//Dla sprawdzenia, ale demoluje ;-) wykres
          }
          //else //NADAL CIERPI!
        }
    }
  }
  //Zapamiętujemy zmiane w podstawowych statystykach jaka się dokonała w kroku symulacji
  deaths.append(sumDeath-befDeath);
  newcas.append(sumInfected-befInfected);
  cured.append(sumRecovered-befRecovered);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////
//  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - ABM: BASIC INITIALISATION & EVERY STEP CHANGE
////////////////////////////////////////////////////////////////////////////////////////////////////////////
