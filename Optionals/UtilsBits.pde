/// Bit tools
//*///////////////////

/// Function for mutating integer bits
int swithbit(int sou,int pos)//flip-flopuje bit na pozycji
{
  if(pos>=MASKBITS)//Define MASKBITS somewhere
  {
    println("!!! Mutation autside BITMASK");
    return sou;
  }
  
  int bit=0x1<<pos; // There is a correct position
  
  //print(":"+bit+" ");
  return sou^bit;//xor should do the job? TOCO CHECK?
}

/// Integer bit counting function
int countbits(int u)
{
  final int BITSPERINT=32; assert Integer.BYTES==4;
  int sum=0;
  for(int i=0;i<BITSPERINT;i++)
    {
    if((u & 1) !=0 )
        sum++;
    u>>=1;
    }
  return sum;
}

//*///////////////////////////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - OPTIONAL TOOLS - FUNCTIONS & CLASSES
//*  https://github.com/borkowsk/sym4processing
//*///////////////////////////////////////////////////////////////////////////////////////////////////
