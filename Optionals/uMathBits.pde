/// @file uMathBits.pde
/// Bit tools.
/// @date 2023.03.04 (Last modification)
//*///////////////////////////////////////////////////////////////

/// Function for mutating integer bits.
/// Flip-flop the bit at the given position
int swithbit(int sou,int pos)
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

/// IBit counting function.
/// Counts the set bits of an integer
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

//*///////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - OPTIONAL TOOLS 
//*  - FUNCTIONS & CLASSES
//*  https://github.com/borkowsk/sym4processing
//*///////////////////////////////////////////////////////////////////////////
