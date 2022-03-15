/// Simulation have to collect and write down statistics from every step
//* CA: STATISTICS LOG TEMPLATE
//*////////////////////////////////////////////////////////////////////////////////

PrintWriter outstat; ///< Handle to the text file with the record of model statistics

/// It prepares a unique statistics file name, opens the file 
/// and enters the header line.
void initializeStats()
{
  String FileName=modelName+="_"+year()+'.'+nf(month(),2)+'.'+nf(day(),2)+'.'+nf(hour(),2)+'.'+nf(minute(),2)+'.'+nf(second(),2)+'.'+millis();
  outstat=createWriter(FileName+".out");
  outstat.println("$STEP\tAlive\t.....");//<-- complete the header fields!
}

float meanDummy=0;///< the average of the non-zero cell values
int   liveCount=0;///< number of non-zero cells

/// The function calculates all world statistics after the simulation step
void doStatistics(World world)
{
  doStatisticsOnCells(world.cells);
  /// ... statistics of other things
}

/// Cell statistics. One-dimensional version
/// outstat file should be closed in exit() --> see Exit.pde
void doStatisticsOnCells(int[] cells)
{  
  int curr;
  long summ=0;
  
  liveCount=0;
  
  for(int a=0;a<cells.length;a++)
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
     if(outstat!=null)
        outstat.println(StepCounter+"\t"+liveCount+"\t"+meanDummy);
   }
   else
   {
     simulationRun=false;
     if(outstat!=null)
        outstat.println(StepCounter+"\t"+liveCount+"\tFINISHED");
   }
}

/// Cell statistics. Two-dimensional version
/// outstat file should be closed in exit() --> see Exit.pde
void doStatisticsOnCells(int[][] cells)
{  
  long summ=0;
  int curr;
  
  liveCount=0;
  
  for(int a=0;a<cells.length;a++)
   for(int b=0;b<cells[a].length;b++)
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
      if(outstat!=null)
         outstat.println(StepCounter+"\t"+liveCount+"\t"+meanDummy);
   }
   else
   {
     simulationRun=false;
     if(outstat!=null)
        outstat.println(StepCounter+"\t"+liveCount+"\tFINISHED");
   }
}

//*//////////////////////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - CA (Cellular Automaton) TEMPLATE
//*  https://github.com/borkowsk/sym4processing
//*//////////////////////////////////////////////////////////////////////////////////////////////
