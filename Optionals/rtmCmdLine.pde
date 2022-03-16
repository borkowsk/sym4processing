/// Template handling of program call parameters, if available.
//*/////////////////////////////////////////////////////////////

void checkCommandLine() /// Parsing command line if available
{ 
    //extern int debug_level;// EXPECTED!
    
    //Is passing parameters possible?
    if(args==null)
    {
       if(debug_level>0) println("Command line parameters not available");
       return; //Not available!!!
    }

    if(debug_level>0)
    {
      println("args length is " + args.length);
      for(int a=0;a<args.length;a++)
          print(args[a]," ");
      println();
    }
    
    //... UTILISE PARAMETERS BELOW ...
    int Fcount=0;
    for(int a=0;a<args.length;a++)
    {
      String[] list = split(args[a], ':');
      if(debug_level>1)
      {
        for(String s:list) 
          print("'"+s+"'"+' ');
        println();
      }
      
      if(list[0].equals("FRAMEFREQ"))
      {
        //*_extern* int           FRAMEFREQ=10;/// simulation speed
        FRAMEFREQ=Integer.parseInt(list[1]);
        println("Speed vel FRAMEFREQ:",FRAMEFREQ);
      }
      else
      if(list[0].equals("DEBUG"))
      {
        //*_extern* int           debug_level=0;/// level of debugging messages
        debug_level=Integer.parseInt(list[1]);
        println("debug_level:",debug_level);
      }
      else
      /* if(list[0].equals("PARAMETER"))
      {
        //*_extern* int           parameter;//=20;/// Side of area
        //*_extern* int           fromParam1;//=40; /// Min & max...
        //*_extern* int           fromParam2;//=40; /// random number
        parameter=int(list[1]);
        fromParam1=parameter*-2;
        fromParam2=parameter*2;
        println("PARAMETER:",parameter,"fromParam:",fromParam1,fromParam2);
      }
      else */
      {
        Fcount++;
      }
    }
    
    if(Fcount>0 ) println("Failed to understand",Fcount,"parameters");
}

//*///////////////////////////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - OPTIONAL TOOLS - FUNCTIONS & CLASSES
//*  https://github.com/borkowsk/sym4processing
//*///////////////////////////////////////////////////////////////////////////////////////////////////
