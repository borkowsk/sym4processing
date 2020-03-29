
void checkCommandLine()
{
    //Is passing parameters possible?
    if(args==null)
            return; //No!!!

    println("args length is " + args.length);
    int count=0;
    for(int a=0;a<args.length;a++)
    {
      print(args[a]);
      //... UTILISE PARAMETERS HERE ...
      count++;
    }
}
