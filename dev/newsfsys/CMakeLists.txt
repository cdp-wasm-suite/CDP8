# CMakeLists.txt for newsfsys (Release 8) RWD 2022
if(APPLE)
  set(CMAKE_C_FLAGS "-O2 -Dunix -D__MAC__ -DMAC -DENABLE_PVX")
else()
  if(MINGW OR MSVC)
    # The sources use _X86_ as a little-endian marker, but the Windows/MinGW
    # SDK headers use the same macro to select the target architecture —
    # defining it on an ARM64 build makes them emit x86 intrinsics. Only
    # define it for x86 targets; sfsys.c recognises ARM64 by itself.
    if(CMAKE_SYSTEM_PROCESSOR MATCHES "ARM64|arm64|aarch64")
      set(CDP_ARCH_DEFS "")
    else()
      set(CDP_ARCH_DEFS "-D_X86_ ")
    endif()
    if(MINGW)
      set(CMAKE_C_FLAGS "-O2 ${CDP_ARCH_DEFS}-DWIN32 -D_WIN32 -D__GNUWIN32__ -DENABLE_PVX")
    else()
      set(CMAKE_C_FLAGS "-O2 ${CDP_ARCH_DEFS}-DWIN32 -D_WIN32 -DENABLE_PVX")
    endif()
  else()
    set(CMAKE_C_FLAGS "-O2 -Dunix -Dlinux -D_X86_ -DENABLE_PVX")
  endif()
endif()

include_directories(../newinclude)
#RWD 2025 pvx file handling now always in pvxio2
if(MINGW OR MSVC)
   set(SFSYS_SRCS sfsys.c snd.c sfdir.c osbind.c props.c shortcuts.c scandir.c alias.c ieee80.c)
else()
   set(SFSYS_SRCS sfsys.c snd.c sfdir.c osbind.c props.c ieee80.c)
endif()

add_library(sfsys ${SFSYS_SRCS})
