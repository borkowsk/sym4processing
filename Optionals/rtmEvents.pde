/// Example of a keyboard event handling. ("rtmEvents.pde")
/// @date 2024-11-22 (Last modification)
/// @note This file shoud be COPIED into the project directory and modified when needed.
//-/////////////////////////////////////////////////////////////////////////////////////

/// @defgroup Generally usable classes & functions
/// @{
//-///////////////////////////////////////////////

/// The handler called every time when keyboard key is pressed.
/// You can use 'key' and 'keyCode' Processing variable inside. 
void keyPressed() 
{
  fill(128);  //print(CODED);//DEBUG
  if(key!=CODED) println("Key:'",key,'\''); else println("Key coded:'",keyCode,'\'');
  switch(key)
  {
  case 'q':
  case 'Q': exit();break;
  
  case 'o': FRAMEFREQ/=2;frameRate(FRAMEFREQ);println("Requested",FRAMEFREQ,"frames/sec");break;
  case '0': FRAMEFREQ*=2;frameRate(FRAMEFREQ);println("Requested",FRAMEFREQ,"frames/sec");break;
  case '1': VISFREQ=1;println(VISFREQ,"step/frame");text("StPerV: "+VISFREQ,0,height-16);break;
  case '2': VISFREQ=2;println(VISFREQ,"step/frame");text("StPerV: "+VISFREQ,0,height-16);break;
  case '3': VISFREQ=5;println(VISFREQ,"step/frame");text("StPerV: "+VISFREQ,0,height-16);break;
  case '4': VISFREQ=10;println(VISFREQ,"step/frame");text("StPerV: "+VISFREQ,0,height-16);break;
  case '5': VISFREQ=25;println(VISFREQ,"step/frame");text("StPerV: "+VISFREQ,0,height-16);break;
  case '6': VISFREQ=50;println(VISFREQ,"step/frame");text("StPerV: "+VISFREQ,0,height-16);break;
  case '7': VISFREQ=100;println(VISFREQ,"step/frame");text("StPerV: "+VISFREQ,0,height-16);break;
  case '8': VISFREQ=150;println(VISFREQ,"step/frame");text("StPerV: "+VISFREQ,0,height-16);break;
  case '9': VISFREQ=200;println(VISFREQ,"step/frame");text("StPerV: "+VISFREQ,0,height-16);break;
  case ' ': //SPACE - dump the current screen             
            save("screen"+nf(frameCount,6,5)+".PNG");
            println("screen"+nf(frameCount,6,5)+".PNG","SAVED!");
            break;
  default:println("Command '"+key+"' unknown");
  case '\t':
       {  //HELP
          int startX=75;
          int startY=10;
          int fsize=8;
          textSize(fsize);
          fill(64);textAlign(LEFT,TOP);
          println("USE:");
          println("\u2423 \t for dump the current screen"); text("SPACE \t for dump the current screen",startX,startY);         
          println("1-9 \t for less frequent visualisation");text("1-9 \t for less frequent visualisation",startX,startY+=fsize);         
          println("o 0 \t for less & more frequent frames");text("o 0 \t for less & more frequent frames",startX,startY+=fsize);         
          println("q,Q \t exit");                           text("q,Q \t exit",startX,startY+=fsize);         
          println("\n");
          //see: http://blog.elliottcable.name/posts/useful_unicode.xhtml
       }    
  break;
  }
  
  if (key == ESC) 
  {
    key = 0;  // Don't let them escape!
  }
}

//*////////////////////////////////////////////////////////////////////////////////////////////
//*  https://github.com/borkowsk/sym4processing
//*  See: "https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI" - KEYBOARD EVENTS TEMPLATE
/// @}
//*////////////////////////////////////////////////////////////////////////////////////////////
