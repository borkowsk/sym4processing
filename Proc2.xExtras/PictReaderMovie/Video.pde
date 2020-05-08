//////////////////////////////////////////////////////
// To musi być w setup() żeby było Video:
//
//  initVideoExport(this,FileName,int FramesFreq)); //Klasa VideoExport musi mieć dostep do obiektu aplikacji Processingu
//                         //Najlepiej wywołać na koncu setupu. Okno musi mieć PARZYSTE rozmiary
//  
//a to dla każdej klatki
//  NextVideoFrame();//Video frame
//
//na koniec zaś:
//  CloseVideo()
//
import com.hamoid.*;//Oraz importujemy niezbędną biblioteką zawierającą klasę VideoExport

boolean     videoExportEnabled=true;

VideoExport videoExport;//KLASA z biblioteki VideoExport Abe Pazosa - trzeba zainstalować
                        //http://funprogramming.org/VideoExport-for-Processing/examples/basic/basic.pde
                        //Oraz zainstalować program ffmpeg żeby działało
                        // Set video and audio quality.
                        // Video quality: 100 is best, lossless video (but big file size)
                        //   Set it to 0 (worst) if you enjoy poor quality videos :)
                        //   70 is the default.
                        // Audio quality: 128 is the default, 192 very good,
                        //   256 is near lossless but big file size.
                        //videoExport.setQuality(70, 128);
int videoFramesFreq=0;                        
void initVideoExport(processing.core.PApplet parent, String Name,int Frames)
{
  videoFramesFreq=Frames;
  if(videoExportEnabled)
  {
     videoExport = new VideoExport(parent,Name); //Klasa VideoExport musi mieć dostep do obiektu aplikacji Processingu
     videoExport.setQuality(99, 0);//No sound!
     videoExport.setFrameRate(Frames);//Nie za szybko
     videoExport.startMovie();
     text(Name,1,20);
  }
}
                        
void firstVideoFrame(int R,int G,int B)
{
  if(videoExportEnabled)
  {  
    if(R!=0 && G!=0 && B!=0)
       fill(R,G,B);
     text("Pict2Movie (c) W.Borkowski @ ISS University of Warsaw",1,height); 
     //text(videoExport.VERSION,width/2,height);
     delay(200);
     for(int i=0;i<videoFramesFreq;i++)//Musi trwać sekundę czy coś...
       videoExport.saveFrame();//Video frame
  }
}

void nextVideoFrame()
{  
   if(videoExportEnabled)
     videoExport.saveFrame();//Video frame
}
                     
void closeVideo() //To wołamy gdy chcemy zamknąć
{
  if(videoExport!=null)
  { 
   fill(0);
  // text("Prepared at koko@fau.edu by A.Nowak nowak@fau.edu  & ",1,height-18)
   text("W.Borkowski wborkowski@uw.edu.pl",1,height-3);//Raczej się nie pojawia :-(
   //powinno być jakieś "force screen update", ale nie znalazłem
   for(int i=0;i<videoFramesFreq;i++)//Musi trwać sekundę czy coś...
       videoExport.saveFrame();//Video frame
   videoExport.saveFrame();//Video frame - LAST
   videoExport.endMovie();//Koniec filma
  }
}