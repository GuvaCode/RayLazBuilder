#!/bin/bash
#for compile in windows download and unpack w64devkit from https://github.com/skeeto/w64devkit

# Parametrs
unamestr=$(uname)
proctype=$(uname -m)
rayUri=https://github.com/raysan5/raylib/archive/refs/heads/master.zip #Download from master

# Create temp dir
mkdir -p temp
mkdir -p bin

# Check if there is already a folder from the source
if [ ! -d src ]; then
   wget $rayUri -P temp
   cd temp
   unzip master.zip
   cd raylib-master
   cp -r src ../../
   cd ../../
   rm -R temp
 fi

#Go to source folder
cd src

# Create two files and clear them 
touch raygui.c physac.c
true >raygui.c
true >physac.c

# Filling in the values
echo '#define RAYGUI_IMPLEMENTATION' >>raygui.c
echo '#include "extras/raygui.h"   ' >>raygui.c
echo '#define PHYSAC_IMPLEMENTATION' >>physac.c
echo '#include "extras/physac.h"   ' >>physac.c

# To make the dynamic shared version and included module gui and physac
make PLATFORM=PLATFORM_DESKTOP RAYLIB_LIBTYPE=SHARED RAYLIB_MODULE_RAYGUI=TRUE RAYLIB_MODULE_PHYSAC=TRUE RAYLIB_RES_FILE=

# Goto root folder
cd ../

# We get the version of the system and hardware. Create companion folders and copy the library
if [[ "$unamestr" == 'Windows_NT' ]]; then
 mkdir -p bin/windows
  if [[ "$proctype" == 'x86_64' ]]; then
      mkdir -p bin/windows/x86_64
	  cp src/raylib.dll bin/windows/x86_64 
  fi
  if [[ "$proctype" == 'i686' ]]; then
      mkdir -p bin/windows/i686
      cp src/raylib.dll bin/windows/i686
  fi  
fi

#We clean up the trash
cd src
make clean
cd ../
rmdir temp
echo 'Done ...'







