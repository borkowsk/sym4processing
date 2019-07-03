//Funkcja do mutowania bitów integera
int swithbit(int sou,int pos)//flip-flopuje bit na pozycji
{
  if(pos>=MASKBITS)//Define MASKBITS somewhere
  {
    println("!!! Mutation autside BITMASK");
    return sou;
  }
  //Jest poprawna pozycja
  int bit=0x1<<pos;
  
  //print(":"+bit+" ");
  return sou^bit;//xor should do the job?
}

//Funkcja zliczania bitów intigera
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
