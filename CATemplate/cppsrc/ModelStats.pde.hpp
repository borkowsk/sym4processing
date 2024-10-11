/// @file
/// @brief Simulation have to collect and write down statistics from every step.
//*        CA: STATISTICS LOG TEMPLATE
//  @date 2024-10-11 (last modification)
//*////////////////////////////////////////////////////////////////////////////////

PrintWriter outstat; ///< Handle to the text file with the record of model statistics.

/// Initialisation of statistic log->It prepares a unique statistics file name, 
/// opens the file and enters the header line.
void initializeStats() ///< GLOBAL!
{
  String FileName=modelName+=String("_")+year()+String('.')+nf(month(),2)+String('.')+nf(day(),2)+String('.')+nf(hour(),2)+String('.')+nf(minute(),2)+String('.')+nf(second(),2)+String('.')+millis();
  outstat=createWriter(FileName+ String(".out"));
  println(outstat,"$STEP\tAlive\t.....");//<-- complete the header fields!
}

float meanDummy=0; ///< the average of the non-zero cell values
int   liveCount=0; ///< number of non-zero cells

/// Couning all statistics->The function calculates all world statistics after the simulation step.
void doStatistics(pWorld world) ///< GLOBAL!
{
  doStatisticsOnCells(world->cells);
  /// ... statistics of other things
}

/// Statistics for cells (1D version). The function calculates and writes all cells statistics.
/// It is called in 'doStatistics()'.
/// NOTE: outstat file should be closed in exit() --> see Exit->pde
void doStatisticsOnCells(sarray<int> cells) ///< GLOBAL!
{  
  int curr;
  long summ=0;
  
  liveCount=0;
  
  for(int a=0;a<cells->length;a++)
    if( (curr=cells[a]) != 0 )
    {
      //Dummy stat
      summ+=curr;
      
      //if(curr==1) 
      //.....THIS PART IS FOR YOU!
      
      liveCount++;//Alive cells
    }
  
   if(liveCount>0)
   {
     meanDummy=summ/liveCount;
     if(outstat!=nullptr)
        println(outstat,StepCounter+String("\t")+liveCount+String("\t")+meanDummy);
   }
   else
   {
     simulationRun=false;
     if(outstat!=nullptr)
        println(outstat,StepCounter+String("\t")+liveCount+ String("\tFINISHED"));
   }
}

/// Statistics for cells (2D version). The function calculates and writes all cells statistics.
/// It is called in 'doStatistics()'.
/// NOTE: outstat file should be closed in exit() --> see Exit->pde
void doStatisticsOnCells(smatrix<int> cells) ///< GLOBAL!
{  
  long summ=0;
  int curr;
  
  liveCount=0;
  
  for(int a=0;a<cells->length;a++)
   for(int b=0;b<cells[a]->length;b++)
    if( (curr=cells[a][b]) != 0 )
    {
      //Dummy stat
      summ+=curr;
      
      //if(curr==1) 
      //.....THIS PART IS FOR YOU!
      
      liveCount++;//Alive cells
    }
  
   if(liveCount>0)
   {
      meanDummy=summ/liveCount;
      if(outstat!=nullptr)
         println(outstat,StepCounter+String("\t")+liveCount+String("\t")+meanDummy);
   }
   else
   {
     simulationRun=false;
     if(outstat!=nullptr)
        println(outstat,StepCounter+String("\t")+liveCount+ String("\tFINISHED"));
   }
}

//*//////////////////////////////////////////////////////////////////////////////////////////////
//*  https://www->researchgate->net/profile/WOJCIECH_BORKOWSKI - CA (Cellular Automaton) TEMPLATE
//*  https://github->com/borkowsk/sym4processing
//*//////////////////////////////////////////////////////////////////////////////////////////////
//NOTE! /data/wb/SCC/public/Processing2C/scripts did it 2024-10-11 17:07:02

