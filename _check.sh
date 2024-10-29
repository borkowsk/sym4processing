#!/bin/bash
## Checking for required dependencies.
## @date 2024-06-14 (last modifications)
## @author wborkowski@uw.edu.pl

#EDIT=nano

# https://intoli.com/blog/exit-on-errors-in-bash-scripts/
set -e 
echo -e $COLOR1"Running script: " $COLOR2 `realpath $0` $NORMCO

source ./screen.ini
#echo -e $COLOR1 "screen.ini SUB:" $COLOR2 $SUB $NORMCO "\n\n"

echo -e $COLOR3"\n\tThis script stops on any error!\n\tWhen it stop, remove source of the error & run it again!\n"$NORMCO
  
echo -e $COLOR1"Test for required software:\n" 
echo -e $COLOR2"Processing.org..."$NORMCO

find ~/ -name "processing" -type f -executable -print > processing_dirs.lst
grep --color "processing" processing_dirs.lst
wc -l processing_dirs.lst

echo -e $COLOR1"\n\tLooks like you have Processing."
echo -e $COLOR2"\tRemember to run 'install' in its main directory."$NORMCO

echo -e $COLOR2"\n'hamoid' video library installed in Processing... "$NORMCO
find ~/ -name "hamoid"  -print > hamoid_dirs.lst
grep --color "hamoid" hamoid_dirs.lst
wc -l hamoid_dirs.lst

echo -e $COLOR1"\n\tLooks like you have Hamoid Video Library."

echo -e $COLOR2"\nffmpeg tool installed in your system... (if not, try 'sudo apt  install ffmpeg')"$COLOR1
ffmpeg -version | grep --color "ffmpeg.*version"
echo -e $COLOR1"\n\tLooks like you have ffmpeg tool instaled\n"


#instalacja zmiennej ze ścieżką do IDE processingu
#jesli jest to potrzebne
set +e

echo -e $COLOR1"Now puts variable PRIDE into '.profile' ..."$COLOR2

grep -q "PRIDE" $HOME/.profile

if [  $? != 0  ]
then
     tmp=`tail -1 processing_dirs.lst`
     PRIDE="$tmp"
     echo -e "\nProcessing IDE is" $PRIDE
     echo -e "\nexport PRIDE="$tmp >> $HOME/.profile
fi
echo  -e "In$COLOR1 $HOME/.profile $NORMCO:"
grep --color "PRIDE" $HOME/.profile

echo -e $COLOR2 "\n\tREMEMBER! Changes in '.profile' have effect after relogin!\n\n" $NORMCO



