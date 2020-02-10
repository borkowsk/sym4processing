PrintWriter outstat;

void initializeStats()
{
  String FileName=modelName+="_"+year()+'.'+nf(month(),2)+'.'+nf(day(),2)+'.'+nf(hour(),2)+'.'+nf(minute(),2)+'.'+nf(second(),2)+'.'+millis();
  outstat=createWriter(FileName+".out");
  outstat.println("$STEP\tmeanStress\t.....");
}

float meanStress=0;
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
  
   outstat.println(StepCounter+"\t"+meanStress+"\t"+(summ/liveCount));
   //outstat should be closed in Exit()
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
  
   outstat.println(StepCounter+"\t"+meanStress+"\t"+(summ/liveCount));
   //outstat should be closed in Exit()
}

///////////////////////////////////////////////////////////////////////////////////////////
//  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - STATISTICS LOG TEMPLATE
///////////////////////////////////////////////////////////////////////////////////////////
