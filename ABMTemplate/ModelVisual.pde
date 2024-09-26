/// @file 
/// @brief World full of agents need method of visualisation on screen/window.
//*        ABM: BASIC VISUALISATION
/// @date 2024-09-26 (last modification)
//*//////////////////////////////////////////////////////////////////////////

/// @brief Visualization of agents (2D version).
void visualizeAgents(Agent[][] agents) ///< GLOBAL!
{
  Agent curra;
  for(int a=0;a<agents.length;a++)
   for(int b=0;b<agents[a].length;b++)
   {
    //Colorisation
    if( (curra=agents[a][b]) != null )
    {
      if(curra.dummy>=0)
        fill(curra.dummy*255,0,curra.dummy*255);
      else
        fill(-curra.dummy*255,-curra.dummy*255,0);
    }
    else
    {
      fill(EMPTYGRAY);
    }
    
    rect(b*cwidth,a*cwidth,cwidth,cwidth); //a is vertical!
   }
}

//OR

/// @brief Visualization of agents (1D version).
void visualizeAgents(Agent[] agents) ///< GLOBAL!
{
   Agent curra;
   for(int a=0;a<agents.length;a++)
   {
    //Colorisation    
    if( (curra=agents[a]) != null )
    {
      if(curra.dummy>=0)
        fill(curra.dummy*255,0,curra.dummy*255);
      else
        fill(-curra.dummy*255,-curra.dummy*255,0);
    }
    else
    {
      fill(EMPTYGRAY);
    }
    
    /// We take into account different visualization frequencies!
    int t=(StepCounter/STEPSperVIS)%side; 
    
    rect(a*cwidth,t*cwidth,cwidth,cwidth);
    
    stroke(255);
    line(0,(t+1)*cwidth+1,width,(t+1)*cwidth+1);
   }
}

//*////////////////////////////////////////////////////////////////////////////////////////////
//*  Partly sponsored by the EU project "GuestXR" (https://guestxr.eu/)
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - ABM (Agent Base Model) TEMPLATE
//*  https://github.com/borkowsk/sym4processing
//*////////////////////////////////////////////////////////////////////////////////////////////
