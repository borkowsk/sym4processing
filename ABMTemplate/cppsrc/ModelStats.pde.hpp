/// @file 
/// @brief Simulation have to collect and write down statistics from every step.
//*        ABM: STATISTICS LOG TEMPLATE
/// @date 2024-10-20 (last modification)
//*/////////////////////////////////////////////////////////////////////////////////////

PrintWriter outstat;         ///< Handle to the text file with the record of model statistics

/// @brief Initialise statistic log file. @details
/// It prepares a unique statistics file name, opens the file 
/// and writes the header line.
void initializeStats()      ///< GLOBAL!
{
  String FileName=modelName+=String("_")+year()+String('.')+nf(month(),2)+String('.')+nf(day(),2)+String('.')
                           +nf(hour(),2)+String('.')+nf(minute(),2)+String('.')+nf(second(),2)+String('.')+millis();
  outstat=createWriter(FileName+ String(".out"));
  //HEADER LINE:
  println(outstat,"$STEP\tAlive\t....."); //<-- complete the header fields!
}

float meanDummy=0;         ///< average value for the dummy field.
int   liveCount=0;         ///< number of living agents.

/// @brief Every step statistics. @details
/// The function calculates all world statistics after the simulation step.
/// @note For the sake of performance, it may be called not every step 
///       but every ten 10 steps or even less often. 
void doStatistics(pWorld world) ///< GLOBAL!
{
  doStatisticsOnAgents(world->agents);
  /// ... statistics of other things
}

/// @brief pAgent statistics(1D version). @details
/// It calculates and writes statistics of agents.
/// File 'outstat' should be closed in exit() --> see Exit->pde
void doStatisticsOnAgents(sarray<pAgent> agents) ///< GLOBAL!
{  
  pAgent curra;
  double summ=0;
  liveCount=0;
  
  for(int a=0;a<agents->length;a++)
    if( (curra=agents[a]) != nullptr )
    {
      //Dummy statistic
      summ+=curra->dummy;
     
      //.....THIS PART IS FOR YOU!
      
      liveCount++;
    }
  
   if(outstat!=nullptr)
      println(outstat,StepCounter+String("\t")+liveCount+String("\t")+(summ/liveCount));
   
   meanDummy=(float)(summ/liveCount);
}

/// @brief pAgent statistics(2D version). @details
/// It calculates and writes statistics of agents.
/// File 'outstat' should be closed in exit() --> see Exit->pde
void doStatisticsOnAgents(smatrix<pAgent> agents) ///< GLOBAL!
{  
  pAgent curra;
  double summ=0;
  liveCount=0;
  
  for(int a=0;a<agents->length;a++)
   for(int b=0;b<agents[a]->length;b++)
    if( (curra=agents[a][b]) != nullptr )
    {
      //Dummy statistic
      summ+=curra->dummy;
     
      //.....THIS PART IS FOR YOU!
      
      liveCount++;
    }
  
   if(outstat!=nullptr)
      println(outstat,StepCounter+String("\t")+liveCount+String("\t")+(summ/liveCount));
   
   meanDummy=(float)(summ/liveCount);
}


//*////////////////////////////////////////////////////////////////////////////////////////////
//*  Partly sponsored by the EU project "GuestXR" (https://guestxr->eu/)
//*  https://www->researchgate->net/profile/WOJCIECH_BORKOWSKI - ABM (Agent Base Model) TEMPLATE
//*  https://github->com/borkowsk/sym4processing
//*////////////////////////////////////////////////////////////////////////////////////////////
//MADE NOTE: /data/wb/SCC/public/Processing2C/scripts did it 2024-10-20 19:45:02 !

