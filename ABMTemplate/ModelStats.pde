/// @file 
/// @brief Simulation have to collect and write down statistics from every step.
//* ABM: STATISTICS LOG TEMPLATE
/// @date 2024-03-12
//*/////////////////////////////////////////////////////////////////////////////////////

PrintWriter outstat;         ///< Handle to the text file with the record of model statistics

/// @brief Initilise statistic log file. @details
/// It prepares a unique statistics file name, opens the file 
/// and writes the header line.
void initializeStats()      ///< GLOBAL!
{
  String FileName=modelName+="_"+year()+'.'+nf(month(),2)+'.'+nf(day(),2)+'.'
                           +nf(hour(),2)+'.'+nf(minute(),2)+'.'+nf(second(),2)+'.'+millis();
  outstat=createWriter(FileName+".out");
  //HEADER LINE:
  outstat.println("$STEP\tAlive\t....."); //<-- complete the header fields!
}

float meanDummy=0;         ///< average value for the dummy field
int   liveCount=0;         ///< number of living agents

/// @brief Every step statistics. @details
/// The function calculates all world statistics after the simulation step.
/// NOTE: For the sake of performance, it may be called not every step 
/// but every ten 10 steps or even less often. 
void doStatistics(World world) ///< GLOBAL!
{
  doStatisticsOnAgents(world.agents);
  /// ... statistics of other things
}

/// @brief Agent statistics (1D version). @details
/// It calculates and writes statistics of agents.
/// File 'outstat' should be closed in exit() --> see Exit.pde
void doStatisticsOnAgents(Agent[] agents) ///< GLOBAL!
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
}

/// @brief Agent statistics (2D version). @details
/// It calculates and writes statistics of agents.
/// File 'outstat' should be closed in exit() --> see Exit.pde
void doStatisticsOnAgents(Agent[][] agents) ///< GLOBAL!
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
}


//*////////////////////////////////////////////////////////////////////////////////////////////
//*  Partly sponsored by the EU project "GuestXR" (https://guestxr.eu/)
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - ABM (Agent Base Model) TEMPLATE
//*  https://github.com/borkowsk/sym4processing
//*////////////////////////////////////////////////////////////////////////////////////////////
