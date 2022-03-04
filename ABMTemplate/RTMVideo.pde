/// Tool for made video from simulation 
//* PL: Narzędzie do tworzenia wideo z symulacji
//*////////////////////////////////////////////////////////////////////////////////////
/// --> http://funprogramming.org/VideoExport-for-Processing/examples/basic/basic.pde
//*
/// Apart from the "hamoid" library, you also need to install the ffmpeg program to make it work !!! 

import com.hamoid.*;// Here we import the necessary library containing the VideoExport class

/// USAGE/UŻYCIE:
/// This initVideoExport function call must be in setup() for the Video module to work:
//  PL: To wywołanie funkcji initVideoExport musi być w setup(), aby moduł Video zadziałał:
///
///  initVideoExport(this,FileName,Frames)); // The VideoExport class must have access to
///                                          // the Processing application object
///                                          // It's best to run at the end of the setup().
///                                          // NOTE !!!: The window must be EVEN sizes
//
//                                          // Klasa VideoExport musi mieć dostęp do 
//                                          // obiektu aplikacji Processingu
//                                          // Najlepiej wywołać na koncu setupu. 
//                                          // UWAGA!!!: Okno musi mieć PARZYSTE rozmiary
///  
/// We call Next Video Frame for each frame of the movie, most often in the draw () function:
//  PL: NextVideoFrame wywołujemy dla każdej klatki filmu, najczęściej w funkcji draw():
///
///  NextVideoFrame();//Video frame
///
///     ... and at the end of the video we call CloseVideo:
//  PL: ... a na koniec filmu wywołujemy CloseVideo:
///
///  CloseVideo();// Ideally in exit ()
//                // PL: Najlepiej w exit()


VideoExport        videoExport; ///> CLASS object from additional library - must be installed
                                //   PL: Obiekt KLASY z dodatkowej biblioteki - trzeba zainstalować
                                 
static int         videoFramesFreq=0;///> How many frames per second for the movie. It doesn't have to be the same as in frameRate!
                                     //   PL: Ile klatek w sekundzie filmu. Nie musi być to samo co w frameRate!   

static boolean     videoExportEnabled=false;///> Has film making been initiated?
                                            //   PL: Czy tworzenie filmu zostało zainicjowane?
  
///> Copyright of your movie  
///> Change it to your copyright. Best in setup() function.
//   PL: Zawartość zmień na swój copyright. Najlepiej w funkcji setup().                                   
String copyrightNote="(c) W.Borkowski @ ISS University of Warsaw";

/// Make the beginning of the movie file!
//  PL: Zrób początek pliku filmowego!
void initVideoExport(processing.core.PApplet parent, String Name,int Frames)
{
  videoFramesFreq=Frames;
  videoExport = new VideoExport(parent,Name); //Klasa VideoExport musi mieć dostep do obiektu aplikacji Processingu
  videoExport.setFrameRate(Frames);//Nie za szybko
  videoExport.startMovie();
  fill(0,128,255);text(Name,1,20);
  videoExportEnabled=true;
}
                
/// Initial second sequence for title and copyright
//  PL: Początkowa sekundowa sekwencja na tytuł i copyright
void FirstVideoFrame()
{
  if(videoExportEnabled)
  {  
     fill(0,128,255);text(copyrightNote,1,height); 
     //text(videoExport.VERSION,width/2,height);
     delay(200);
     for(int i=0;i<videoFramesFreq;i++)// Must be a second or something ...
       videoExport.saveFrame();//Video frame
  }
}

/// Each subsequent frame of the movie
//  PL: Każda kolejna klatka filmu
void NextVideoFrame()
{  
   if(videoExportEnabled)
     videoExport.saveFrame();//Video frame
}
                     
/// This is what we call when we want to close the movie file.
/// This function adds an ending second sequence with an author's note
//  PL: To wołamy gdy chcemy zamknąć plik filmu.
//  PL: Funkcja dodaje kończącą sekundową sekwencje z notą autorską.
/// NOTE: there should be some "force screen update", but not found :-(
///       So, if you x-click the window while drawing, the last frame
///       will probably be incomplete
// PL: UWAGA! 
//     Powinno być jakieś "force screen update", ale nie znalazłem
//     Jeśli kliknięcie x okna nastąpi w trakcie rysowania to ostatnia klatka
//     będzie prawdopodobnie niekompletna
void CloseVideo() 
{
  if(videoExport!=null)
  { 
   fill(0);
   text(copyrightNote,1,height);

   for(int i=0;i<videoFramesFreq;i++)//Have to last about one second
       videoExport.saveFrame();//Video frames for final freeze
   videoExport.saveFrame();//Video frame - LAST
   videoExport.endMovie();//Koniec filma
  }
}

//*//////////////////////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - MODELING TEMPLATES
//*  https://github.com/borkowsk/sym4processing
//*//////////////////////////////////////////////////////////////////////////////////////////////
