/// World full of cells need method of visualisation on screen/window.
//*        CA: BASIC VISUALISATION
//  @date 2024-10-21 (last modification)
//*//////////////////////////////////////////////////////////////////////////

/// Visualization of cells (Two-dimensional version). NOTE: Not efficient for cwidth==1 !
void visualizeCells(int[][] cells)  ///< GLOBAL!
{
  for(int a=0;a<cells.length;a++)
   for(int b=0;b<cells[a].length;b++)
   {
    //Colorisation
    switch(cells[a][b]){
    case 0: fill(0);break;
    case 1: fill(255,0,0);break;
    case 2: fill(0,255,0);break;
    case 3: fill(0,0,255);break;
    case 4: fill(255,255,0);break;
    case 5: fill(0,255,255);break;
    case 6: fill(255,0,255);break;
    default:
      fill(128);break;
    }
    
    rect(b*cwidth,a*cwidth,cwidth,cwidth);//'a' is vertical!
   }
}

//OR

/// Visualization of cells (One-dimensional version). @note Not efficient for cwidth==1 !
void visualizeCells(int[] cells)  ///< GLOBAL!
{
   for(int a=0;a<cells.length;a++)
   {
    //Colorisation
    switch(cells[a]){
    case 0: fill(0);break;
    case 1: fill(255,0,0);break;
    case 2: fill(0,255,0);break;
    case 3: fill(0,0,255);break;
    default:
      fill(128);break;
    }
    
    int t=(StepCounter/STEPSperVIS)%side;//Uwzględniamy różne częstości wizualizacji
    noStroke();
    rect(a*cwidth,t*cwidth,cwidth,cwidth);
    stroke(255);
    line(0,(t+1)*cwidth+1,width,(t+1)*cwidth+1);
   }
}

//*//////////////////////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - CA (Cellular Automaton) TEMPLATE
//*  https://github.com/borkowsk/sym4processing
//*//////////////////////////////////////////////////////////////////////////////////////////////
