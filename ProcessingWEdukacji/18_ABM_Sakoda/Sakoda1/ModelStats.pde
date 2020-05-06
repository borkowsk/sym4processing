// Simulation have to collect and write down statistics from every step
///////////////////////////////////////////////////////////////////////////////////////
PrintWriter outstat;

void initializeStats()
{
  String FileName=modelName+="_"+year()+'.'+nf(month(),2)+'.'+nf(day(),2)+'.'+nf(hour(),2)+'.'+nf(minute(),2)+'.'+nf(second(),2)+'.'+millis();
  outstat=createWriter(FileName+".out");
  outstat.println("$STEP\tAlive\t.....");//<-- complete the header fields!
}

float meanDummy=0;
int   liveCount=0;

void doStatistics(World world)
{
  doStatisticsOnAgents(world.agents);
}

void doStatisticsOnAgents(Agent[] agents)
{  
  Agent curra;
  double summ=0;
  liveCount=0;
  
  for(int a=0;a<agents.length;a++)
    if( (curra=agents[a]) != null )
    {
      //Dummy statistic
      summ+=curra.dummy;
     
      //.....THIS PART IS FOR YOU!
      
      liveCount++;
    }
  
   if(outstat!=null)
      outstat.println(StepCounter+"\t"+liveCount+"\t"+(summ/liveCount));
   
   meanDummy=(float)(summ/liveCount);
   
   //outstat should be closed in exit() --> see Exit.pde
}

void doStatisticsOnAgents(Agent[][] agents)
{  
  Agent curra;
  double summ=0;
  liveCount=0;
  
  for(int a=0;a<agents.length;a++)
   for(int b=0;b<agents[a].length;b++)
    if( (curra=agents[a][b]) != null )
    {
      //Dummy statistic
      summ+=curra.dummy;
     
      //.....THIS PART IS FOR YOU!
      
      liveCount++;
    }
  
   if(outstat!=null)
      outstat.println(StepCounter+"\t"+liveCount+"\t"+(summ/liveCount));
   
   meanDummy=(float)(summ/liveCount);
   
   //outstat should be closed in exit() --> see Exit.pde
}

///////////////////////////////////////////////////////////////////////////////////////////
//  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - ABM: STATISTICS LOG TEMPLATE
///////////////////////////////////////////////////////////////////////////////////////////
