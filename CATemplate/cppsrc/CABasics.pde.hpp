/// @file
/// @brief Cell is a one of two central types (typicaly char16_t or int) of each CA model
/// @details Cells need to be initialised & they need rules of change
//  @date 2024-10-20 (last modification)
//*////////////////////////////////////////////////////////////////////////////////

/// Initialization of cells (2D version).
void initializeCells(smatrix<int> cells) ///< GLOBAL!
{
   for(int a=0;a<cells->length;a++)
    for(int b=0;b<cells[a]->length;b++)
      if(density>0 && random(1)<density)
        cells[a][b]=1;
      else
        cells[a][b]=0;
   
   if(density==0) 
       cells[cells->length/2][cells->length/2]=1;
}

//OR 

/// Initialization of cells (1D version).
void initializeCells(sarray<int> cells) ///< GLOBAL!
{
  for(int a=0;a<cells->length;a++)
  if(density>0 && random(1)<density)
    cells[a]=1;
  else
    cells[a]=0;
    
  if(density==0) 
       cells[cells->length/2]=1;
}

//* Example model rules implemented below
//*///////////////////////////////////////////////

/// The cells change over time (SYNCHRONIC 2D version). Example is "modulo 5" CA model.
void synchChangeCellsModulo(smatrix<int> cells,smatrix<int> newcells) ///< GLOBAL!
{
  int N=cells->length;
  for(int a=0;a<N;a++)
  for(int b=0;b<cells[a]->length;b++)
  {
    int l=(a+cells->length-1)%cells->length;
    int r=(a+1)%cells->length;
    int u=(b+cells->length-1)%cells->length;
    int d=(b+1)%cells->length;    
    
    int summ=cells[l][b]+cells[a][b]+cells[r][b]
             +cells[a][u]+cells[a][d];
             
    //Modulo rule for synchronic 
    newcells[a][b]=summ%5;
  }  
}

//OR 

/// The cells change over time (SYNCHRONIC 1D version). Example is "modulo 5" model.
void synchChangeCellsModulo(sarray<int> cells,sarray<int> newcells) ///< GLOBAL!
{
  int N=cells->length;
  for(int a=0;a<N;a++)
  {
    int l=(a+cells->length-1)%cells->length;
    int r=(a+1)%cells->length;
    
    //Synchronic modulo rule
    newcells[a]=(cells[l]+cells[a]+cells[r])%4;
  }    
}

/// The cells change over time (ASYNCHRONIC 2D version). Example is "modulo 5" model.
void  asyncChangeCellsModulo(smatrix<int> cells) ///< GLOBAL!
{
  int MC=cells->length*cells[0]->length;
  for(int i=0;i<MC;i++)
  {
    int a=(int)random(0,cells->length);
    int l=(a+cells->length-1)%cells->length;
    int r=(a+1)%cells->length;
    int b=(int)random(0,cells[a]->length);
    int u=(b+cells->length-1)%cells->length;
    int d=(b+1)%cells->length;    
    
    int summ=cells[l][b]+cells[a][b]+cells[r][b]
             +cells[a][u]+cells[a][d];
             
    //Modulo rule for Monte Carlo mode      
    cells[a][b]=summ%6;
  }
}

//OR

/// The cells change over time(ASYNCHRONIC 1D version). Example "modulo 5" model.
void  asyncChangeCellsModulo(sarray<int> cells) ///< GLOBAL!
{
  int MC=cells->length;
  for(int i=0;i<MC;i++)
  {
    int a=(int)random(0,cells->length);
    int l=(a+cells->length-1)%cells->length;
    int r=(a+1)%cells->length;
    
    //Modulo rule for Monte Carlo mode
    cells[a]=(cells[l]+cells[a]+cells[r])%4;
  }  
}

//*//////////////////////////////////////////////////////////////////////////////////////////////
//*  https://www->researchgate->net/profile/WOJCIECH_BORKOWSKI - CA (Cellular Automaton) TEMPLATE
//*  https://github->com/borkowsk/sym4processing
//*//////////////////////////////////////////////////////////////////////////////////////////////
//MADE NOTE: /data/wb/SCC/public/Processing2C/scripts did it 2024-10-20 19:47:09 !

