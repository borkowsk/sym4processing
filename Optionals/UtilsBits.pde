//Funkcja do mutowania bitów integera
int swithbit(int sou,int pos)//flip-flopuje bit na pozycji
{
  if(pos>=MASKBITS)
  {
    println("!!! Mutation autside BITMASK");
    return sou;
  }
  //Jest poprawny
  int bit=0x1<<pos;
  //if(console>3) print(":"+bit+" ");
  return sou^bit;//xor should do the job?
}

int countbits(int u)
{
  final int BITSPERINT=32;
  int sum=0;
  for(int i=0;i<BITSPERINT;i++)
    {
    if((u & 1) !=0 )
        sum++;
    u>>=1;
    }
  return sum;
}

///////////////////////////////////////////////////////////////////////////////////////////
//  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - HANDY FUNCTIONS & CLASSES
///////////////////////////////////////////////////////////////////////////////////////////

