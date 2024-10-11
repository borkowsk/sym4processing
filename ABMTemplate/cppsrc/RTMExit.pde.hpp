/// @file 
/// @brief Everything that needs to be done when the application is terminated.
//*        ABM: EXIT HANDLIG TEMPLATE
/// @date 2024-10-11 (last modification)
//*////////////////////////////////////////////////////////////////////////////

/// @brief Exit handler->It is called whenever a window is closed.
/// @note  In C++ translation it is "global" by default.
void processing_window::exit()          
{
  noLoop();          //For to be sure... (Not needed in Pr. 3->x?)
  delay(100);        // it is possible to close window when draw() is still working!
  //write(world,modelName+String(".")+nf((float)StepCounter,5,5)); //end state of the system
  
  if(outstat!=nullptr)
  {
    outstat->flush();  // Writes the remaining data to the file
    outstat->close();  // Finishes the file
  }
  
  if(WITH_VIDEO) CloseVideo();    //Finalise of Video export
  
  println(modelName,"said: Thank You!");
  
  processing_window_base::exit();       // What library superclass have to do at exit() !!!
} 


//*////////////////////////////////////////////////////////////////////////////////////////////
//*  Partly sponsored by the EU project "GuestXR" (https://guestxr->eu/)
//*  https://www->researchgate->net/profile/WOJCIECH_BORKOWSKI - ABM (Agent Base Model) TEMPLATE
//*  https://github->com/borkowsk/sym4processing
//*////////////////////////////////////////////////////////////////////////////////////////////
//NOTE! /data/wb/SCC/public/Processing2C/scripts did it 2024-10-11 16:48:39

