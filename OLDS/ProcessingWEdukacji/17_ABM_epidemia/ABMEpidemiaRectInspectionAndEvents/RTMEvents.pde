//  Dopasowana do modelu obsługa zdarzeń
///////////////////////////////////////////////////
 

//double minDist2Selec=MAX_INT;
//double maxTransSelec=-MAX_INT;


void keyPressed() 
{
  println("RECIVED:'",key,"\' CODE:",int(key)); 
  switch(key)
  {
  case '1': STEPSperVIS=1;text("StPerV: "+STEPSperVIS,1,16);/*DeltaMC=1;*/StepCounter=int(StepCounter);break;
  case '2': STEPSperVIS=2;text("StPerV: "+STEPSperVIS,1,16);StepCounter=int(StepCounter);break;
  case '3': STEPSperVIS=5;text("StPerV: "+STEPSperVIS,1,16);StepCounter=int(StepCounter);break;
  case '4': STEPSperVIS=10;text("StPerV: "+STEPSperVIS,1,16);StepCounter=int(StepCounter);break;
  case '5': STEPSperVIS=25;text("StPerV: "+STEPSperVIS,1,16);StepCounter=int(StepCounter);break;
  case '6': STEPSperVIS=50;text("StPerV: "+STEPSperVIS,1,16);StepCounter=int(StepCounter);break;
  case '7': STEPSperVIS=100;text("StPerV: "+STEPSperVIS,1,16);StepCounter=int(StepCounter);break;
  case '8': STEPSperVIS=150;text("StPerV: "+STEPSperVIS,1,16);StepCounter=int(StepCounter);break;
  case '9': STEPSperVIS=200;text("StPerV: "+STEPSperVIS,1,16);StepCounter=int(StepCounter);break;
//  case '0': STEPSperVIS=1;DeltaMC=0.2;text("DeltaMC: "+DeltaMC,1,16);break;
  case ' ': save(modelName+"."+nf((float)StepCounter,6,5)+".PNG");
            //write(world,modelName+"."+nf((float)StepCounter,6,5));//Aktualny stan ekosystemu
            break;
  case ESC: simulationRun=!simulationRun; break;
  case 's': simulationRun=false; break;
  case 'r': simulationRun=true; break;
  default:println("Command '"+key+"' unknown");
          println("USE:");
          println("1-9 for less frequent visualisation");
          println("  0 for most frequent visualisation");
          println("ESC,r,s for pause/run simulation");
          println("SPACE for dump the current screen\n"); 
  break;
  }
  
  if (key == ESC) 
  {
    key = 0;  // Fools! don't let them escape!
  }
}


///////////////////////////////////////////////////////////////////////////////////////////
//  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - ABM EVENTS TEMPLATE
///////////////////////////////////////////////////////////////////////////////////////////
