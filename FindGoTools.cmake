# - Tries to find the GoTools Core library
#
# Original version by: jan.b.thomassen@sintef.no
# Contributions from sverre.briseid@sintef.no
# Rewritten to model FindBoost by andre.brodtkorb@sintef.no
#

message("Trying to find the following GoTools components: '${GoTools_FIND_COMPONENTS}'")

SET(GOTOOLS_ROOT "" CACHE PATH "Root to GoTools directory")
MARK_AS_ADVANCED( GOTOOLS_ROOT )

#Set default search paths for includes
set(GoTools_INCLUDE_SEARCH_PATHS "")
list(APPEND GoTools_INCLUDE_SEARCH_PATHS
  "${GOTOOLS_ROOT}/include"
  "$ENV{HOME}/include"
  "$ENV{HOME}/install/include"
  "C:/Program Files (x86)/GoTools/include"
  "$ENV{PROGRAMFILES}/SINTEF/GoTools/include"
)
	
#Set default search paths for libs
set(GoTools_LIBRARY_SEARCH_PATHS "")
list(APPEND GoTools_LIBRARY_SEARCH_PATHS
  "${GOTOOLS_ROOT}/lib"
  "$ENV{HOME}/lib"
  "$ENV{HOME}/install/lib"
  "C:/Program Files (x86)/GoTools/lib"
  "$ENV{PROGRAMFILES}/SINTEF/GoTools/lib"
)

# Find include path
FIND_PATH(GoTools_INCLUDE_DIRS 
  NAMES "GoTools/geometry/SplineSurface.h"
  PATHS ${GoTools_INCLUDE_SEARCH_PATHS}
  PATH_SUFFIXES GoTools 
)

SET(GoToolsCoreLibName "")
IF(WIN32)
  SET(GoToolsCoreLibName "GoToolsCore.lib")
ELSE(WIN32)
  SET(GoToolsCoreLibName "GoToolsCore.so" "GoToolsCore.a")
ENDIF(WIN32)

# Find library path
FIND_PATH(GoTools_LIBRARY_DIR
  NAMES ${GoToolsCoreLibName}
  PATHS ${GoTools_LIBRARY_SEARCH_PATHS}
  PATH_SUFFIXES GoTools Win32/Release Win32/Debug Release Debug
  )

set(GoTools_LIBRARIES "")

foreach(component ${GoTools_FIND_COMPONENTS})
	message("Finding '${component}'")
	FIND_LIBRARY(debug_lib
	  NAMES ${component}
	  PATHS ${GoTools_LIBRARY_DIR}
	)
	FIND_LIBRARY(GoTools_${component}_LIBRARY
	  NAMES ${component}
	  PATHS ${GoTools_LIBRARY_DIR}
	)
	list(APPEND GoTools_LIBRARIES "${GoTools_${component}_LIBRARY}")
	message("Gotools libs: ${GoTools_LIBRARIES}")
endforeach()


# Check that we have found everything
SET(GoTools_FOUND FALSE)
IF(GoTools_INCLUDE_DIRS AND GoTools_LIBRARIES)
  SET(GoTools_FOUND TRUE)
  SET(GoTools_INCLUDE_DIR ${GoTools_INCLUDE_DIRS})
ENDIF(GoTools_INCLUDE_DIRS AND GoTools_LIBRARIES)
