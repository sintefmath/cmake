#Tries to find the Freeglut library
#
# Copyright SINTEF
# Author: <Erik W. Bjønnes> Erik.Bjonnes@sintef.no

SET(Freeglut_ROOT "" CACHE PATH "Root to freeglut directory")
MARK_AS_ADVANCED( Freeglut_ROOT )

#find freeglut library
FIND_LIBRARY(Freeglut_LIBRARY NAMES glut freeglut
  PATHS
  ${Freeglut_ROOT}/lib
  #/usr/lib
  #/usr/lib64
  ~/mylibs/freeglut/lib
  /usr/local/lib
  /usr/local/lib64
  "C:/scene_cxx_thirdparty/freeglut-2.6.0-3/lib"
)

#FIXME if glut and freeglut both is installed, it can use glut's library with 
#freeglut's header. Need to make sure this doesn't happen
#WORKAROUND, currently only checks in /usr/local/lib so install freeglut there

#find freeglut header
FIND_PATH(Freeglut_INCLUDE_DIR NAMES GL/freeglut.h
  PATHS
  ${Freeglut_ROOT}/include
  /usr/include
  /usr/local/include
  ~/mylibs/freeglut/include
  "C:/scene_cxx_thirdparty/freeglut-2.6.0-3/include"
)

#check that we've found it
SET(Freeglut_FOUND "NO")
IF(Freeglut_LIBRARY)
  IF(Freeglut_INCLUDE_DIR)
    SET(Freeglut_FOUND "YES")
  ENDIF(Freeglut_INCLUDE_DIR)
ENDIF(Freeglut_LIBRARY)

#mark freeglut options as advanced
MARK_AS_ADVANCED(
  Freeglut_LIBRARY
  Freeglut_INLUDE_DIR
)