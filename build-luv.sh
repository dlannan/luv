#!/usr/bin/env bash

# Build Script for luv lib to be run by CI on github or gitlab
#    Notes: 
#         I see no value in makefiles and cmake when the below will work just fine. 
#         This is more maintainable, more platform friendly and much less work to config.
#         If I were building thousands of files or similar, I would use lua-make. 

PLATFORM=$1

# Default compiler and linker settings
BASE_INCLUDE="-I./ -I/usr/include -I/usr/local/include -I./util"
BASE_INLCUDE_LIB="-L/usr/local/include -L/usr/include "

COMPILE_FLAGS="-lpthread -ldl -lm"

DEFS="-DLUV"

echo "Building for platform ${PLATFORM}"

# Source files. Add to list as needed. If this gets to big. Break up into multiple lists. Simple.
tgt01=("luv-dll" "luv_dll" "-fpic" "-shared -rdynamic")

TARGET_FILES=(tgt01[@])

# Simple build loops. 
# ----------------------------- BUILD LINUX ---------------------------------
if [ "${PLATFORM}" = "linux" ]; then
echo "Linux."
COMPILE_FLAGS="$COMPILE_FLAGS -lX11 -lXi -lXcursor -lGL -lpthread -lasound"

COUNT=${#TARGET_FILES[@]}
for ((i=0; i<$COUNT; i++))
do
    declare -a tgt=(${!TARGET_FILES[i]})

    gcc -c ${BASE_INCLUDE} ${tgt[2]} ${DEFS} lib/${tgt[0]}.c -o ./bin/lib${tgt[1]}.o ${COMPILE_FLAGS}
    gcc ${tgt[3]} ${BASE_INLCUDE_LIB} -o ./bin/lib${tgt[1]}.so ./bin/lib${tgt[1]}.o ${REMOTERY} ${COMPILE_FLAGS}
done

# ----------------------------- BUILD MACOS ---------------------------------
elif [ "${PLATFORM}" = "macosx" ]; then
echo "MacOS."
DEFS="-D__APPLE__ -DSOKOL_GLCORE"
COMPILE_FLAGS="-arch x86_64 -framework Cocoa -framework QuartzCore -framework AudioToolbox -framework OpenGL $COMPILE_FLAGS"

COUNT=${#TARGET_FILES[@]}
for ((i=0; i<$COUNT; i++))
do
    declare -a tgt=(${!TARGET_FILES[i]})
    
    g++ -c -xobjective-c++ ${BASE_INCLUDE} ${tgt[2]} ${DEFS} lib/${tgt[0]}.c -o ./bin/lib${tgt[1]}_macos.o
    g++ -dynamiclib ${BASE_INLCUDE_LIB} -o ./bin/lib${tgt[1]}_macos.so ./bin/lib${tgt[1]}_macos.o ${REMOTERY} ${COMPILE_FLAGS}
done

# ----------------------------- BUILD MACOS ARM64 ---------------------------------
elif [ "${PLATFORM}" = "macos_arm64" ]; then
echo "MacOS Arm64"
DEFS="-D__APPLE__ -D__APPLE__ -DSOKOL_GLCORE"
COMPILE_FLAGS="-arch arm64 -framework Cocoa -framework QuartzCore -framework AudioToolbox -framework OpenGL $COMPILE_FLAGS"

COUNT=${#TARGET_FILES[@]}
for ((i=0; i<$COUNT; i++))
do
    declare -a tgt=(${!TARGET_FILES[i]})

    g++ -c -xobjective-c++ ${BASE_INCLUDE} ${tgt[2]} ${DEFS} lib/${tgt[0]}.c -o ./bin/lib${tgt[1]}_macos_arm64.o 
    g++ -dynamiclib ${BASE_INLCUDE_LIB} -o ./bin/lib${tgt[1]}_macos_arm64.so ./bin/lib${tgt[1]}_macos_arm64.o ${REMOTERY} ${COMPILE_FLAGS}
done

# ----------------------------- BUILD IOS64 ---------------------------------
elif [ "${PLATFORM}" = "ios64" ]; then
echo "IOS64."
DEFS="-DTARGET_OS_IPHONE -D__APPLE__ -DSOKOL_GLCORE"
COMPILE_FLAGS="-framework Cocoa -framework QuartzCore -framework AudioToolbox -framework OpenGL $COMPILE_FLAGS"

COUNT=${#TARGET_FILES[@]}
for ((i=0; i<$COUNT; i++))
do
    declare -a tgt=(${!TARGET_FILES[i]})

    g++ -c -xobjective-c++ ${BASE_INCLUDE} ${tgt[2]} ${DEFS} lib/${tgt[0]}.c -o ./bin/lib${tgt[1]}_ios64.o 
    g++ -dynamiclib ${BASE_INLCUDE_LIB} -o ./bin/lib${tgt[1]}_ios64.so ./bin/lib${tgt[1]}_ios64.o ${REMOTERY} ${COMPILE_FLAGS}
done

# ----------------------------- BUILD ANDROID ---------------------------------
elif [ "${PLATFORM}" = "android" ]; then
echo "Android."
fi

