/// Example of a handling of exit from aplication (mainly closing open files!) 
/// @date 2023.02.28 (Last modification)
//*/////////////////////////////////////////////////////////////////////////////////

/// It is called whenever a window is closed. 
void exit()          
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

//*/////////////////////////////////////////////////////////////////////////////////////
//*  https://github.com/borkowsk/sym4processing
//*  See: "https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI" - EXIT from TEMPLATE
//*/////////////////////////////////////////////////////////////////////////////////////
