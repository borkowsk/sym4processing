//parameters_140318a.pde - działa tylko dla aplikacji wyeksportowanej

void setup()
{
    background(128);
    size(100, 100);
    //Is passing parameters possible?
    if(args!=null)
    {
      println("args length is " + args.length);
      for(int a=0;a<args.length;a++)
        println(args[a]);
    }
}
