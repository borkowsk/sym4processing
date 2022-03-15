//Pętla z dwiema instrukcjami

size(500,500);//Potrzebny rozmiar okna
noSmooth();//Bez wygladzania

for(int i=0;i<256;i++) //POWTARZAJ/REPEAT 256x
{ //Instrukcja blokowa/code block
  stroke(i);
  line(i*2,i*2,0,500);
} //KONIEC/END

//http://processingwedukacji.blogspot.com
