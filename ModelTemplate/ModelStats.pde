PrintWriter outstat;

void initializeStats()
{
  String FileName=modelName+="_"+year()+'.'+nf(month(),2)+'.'+nf(day(),2)+'.'+nf(hour(),2)+'.'+nf(minute(),2)+'.'+nf(second(),2)+'.'+millis();
  outstat=createWriter(FileName+".out");
  outstat.println("$STEP\tmeanStress\t.....");
}

float meanStress=0;
int   liveCount=0;

void doStatistics()
{  
  Agent curra;
  for(int a=0;a<World.length;a++)
   for(int b=0;b<World[a].length;b++)
    if( (curra=World[a][b]) != null )
    {
      //.....
      liveCount++;
    }
  
   outstat.println(StepCounter+"\t"+meanStress+"\t.....");
   //outstat should be closed in Exit()
}

///////////////////////////////////////////////////////////////////////////////////////////
//  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - STATS LOG TEMPLATE
///////////////////////////////////////////////////////////////////////////////////////////
