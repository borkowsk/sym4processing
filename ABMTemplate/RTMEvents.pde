/// Model-specific event handler. 
/// Of course, the creator of a specific application has to match actions.
//* ABM: EVENTS TEMPLATE
//*///////////////////////////////////////////////////////////////////////

/// Keyboard click handler. Automatically run by Processing 
/// when any key on the keyboard is pressed. 
/// Inside, you can use the variables 'key' and 'keyCode'.
/// NOTE: In C++ translation it is "global" by default.
void keyPressed()
{
  println("RECIVED:'",key,"\' CODE:",int(key)); 
  switch(key)
  {
  case '1': STEPSperVIS=1;println("StPerV: "+STEPSperVIS);break;
  case '2': STEPSperVIS=2;println("StPerV: "+STEPSperVIS);break;
  case '3': STEPSperVIS=5;println("StPerV: "+STEPSperVIS);break;
  case '4': STEPSperVIS=10;println("StPerV: "+STEPSperVIS);break;
  case '5': STEPSperVIS=25;println("StPerV: "+STEPSperVIS);break;
  case '6': STEPSperVIS=50;println("StPerV: "+STEPSperVIS);break;
  case '7': STEPSperVIS=100;println("StPerV: "+STEPSperVIS);break;
  case '8': STEPSperVIS=150;println("StPerV: "+STEPSperVIS);break;
  case '9': STEPSperVIS=200;println("StPerV: "+STEPSperVIS);break;
//  case '0': STEPSperVIS=1;DeltaMC=0.2;println("DeltaMC: "+DeltaMC);break;
  case ' ': save(modelName+"."+nf((float)StepCounter,6,5)+".PNG"); // // Save the contents of the simulation window!
            //write(world,modelName+"."+nf((float)StepCounter,6,5)); // Save the current model state!
            break;
  case ESC: simulationRun=!simulationRun; break;
  case 's': simulationRun=false; break;
  case 'r': simulationRun=true; break;
  case 'q': exit(); break;
  default:println("Command '"+key+"' unknown");
          println("USE:");
          println("1-9 for less frequent visualisation");
          println("  0 for most frequent visualisation");
          println("ESC,r,s for pause/run simulation");
          println("SPACE for dump the current screen\n"); //... "and state\n); 
  break;
  }
  
  if (key == ESC) 
  {
    key = 0;  // Fools! don't let them escape!
  }
}


//*////////////////////////////////////////////////////////////////////////////////////////////
//*  Partly sponsored by the EU project "GuestXR" (https://guestxr.eu/)
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - ABM (Agent Base Model) TEMPLATE
//*  https://github.com/borkowsk/sym4processing
//*////////////////////////////////////////////////////////////////////////////////////////////
