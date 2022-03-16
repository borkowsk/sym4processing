///  Handling of exit from aplication - mainly closing open files! Implementation for RTSIJeremi 
///  File: "RTMExit.pde"
///  @a "https://github.com/borkowsk/RTSI_public"
/////////////////////////////////////////////////////////////////////////////////////

void exit()          //it is called whenever a window is closed. 
{
  noLoop();          //For to be sure...
  delay(100);        // it is possible to close window when function draw( ) is still working!
  
  //Close any open global files!
  //if(statisticsLogEnabled)
  //      CloseStatistics();

  //Finalise of VIDEO export!
  //if(videoExportEnabled) 
  //        CloseVideo();    
          
  println("Thank You");
  super.exit();       //What library superclass have to do at exit
} 

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///  Last modification 2022.03.16
///  @a "https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI" - EXIT from TEMPLATE
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
