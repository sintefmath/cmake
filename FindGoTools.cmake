# - Tries to find the GoTools Core library
#
# Original version by: jan.b.thomassen@sintef.no
# Contributions from sverre.briseid@sintef.no
# Rewritten to model FindBoost by andre.brodtkorb@sintef.no
# Rewritten to find optimised&debug by erik.bjonnes@sintef.no
#

message("Trying to find the following GoTools components: '${GoTools_FIND_COMPONENTS}'")

SET(GoTools_ROOT "" CACHE PATH "Root to GoTools directory")
MARK_AS_ADVANCED( GoTools_ROOT )

#Set default search paths for includes
set(GoTools_INCLUDE_SEARCH_PATHS "")
list(APPEND GoTools_INCLUDE_SEARCH_PATHS
  "${GoTools_ROOT}/include"
  "$ENV{HOME}/include"
  "$ENV{HOME}/install/include"
  "C:/Program Files (x86)/GoTools/include"
  "$ENV{PROGRAMFILES}/SINTEF/GoTools/include"
)
	
#Set default search paths for libs
set(GoTools_LIBRARY_SEARCH_PATHS "")
list(APPEND GoTools_LIBRARY_SEARCH_PATHS
  "${GoTools_ROOT}/lib"
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


set(GoTools_LIBRARIES_DEBUG "")
set(GoTools_LIBRARIES_RELEASE "")

foreach(component ${GoTools_FIND_COMPONENTS})
  message("Finding '${component}'")
  FIND_LIBRARY(GoTools_${component}_LIBRARY_DEBUG
    NAMES ${component}
    PATHS ${GoTools_LIBRARY_SEARCH_PATHS}
    PATH_SUFFIXES GoTools Debug Win32/Debug 
    )
  list(APPEND GoTools_LIBRARIES_DEBUG "${GoTools_${component}_LIBRARY_DEBUG}")

  FIND_LIBRARY(GoTools_${component}_LIBRARY_RELEASE
    NAMES ${component}
    PATHS ${GoTools_LIBRARY_SEARCH_PATHS}
    PATH_SUFFIXES GoTools Release Win32/Release
    )
  list(APPEND GoTools_LIBRARIES_RELEASE "${GoTools_${component}_LIBRARY_RELEASE}")
  MARK_AS_ADVANCED( GoTools_${component}_LIBRARY_DEBUG )
  MARK_AS_ADVANCED( GoTools_${component}_LIBRARY_RELEASE )

endforeach()

set( GoTools_LIBRARIES "" )
foreach( _libname IN LISTS GoTools_LIBRARIES_RELEASE )
  list( APPEND GoTools_LIBRARIES optimized "${_libname}" )
endforeach()
foreach( _libname IN LISTS GoTools_LIBRARIES_DEBUG )
  list( APPEND GoTools_LIBRARIES debug "${_libname}" )
endforeach()


# Check that we have found everything
SET(GoTools_FOUND FALSE)
IF(GoTools_INCLUDE_DIRS AND GoTools_LIBRARIES)
  SET(GoTools_FOUND TRUE)
  #show the include directory and libraries found
  SET(GoTools_INCLUDE_DIR ${GoTools_INCLUDE_DIRS} CACHE STRING "GoTools Libraries requested")
  SET(GoTools_LIBRARY ${GoTools_LIBRARIES} CACHE STRING "GoTools Libraries requested")
  #hide the specific lists used to set the above variables
  SET(GoTools_INCLUDE_DIRS CACHE INTERNAL "There are no dependencies, so this should not be used")
  SET(GoTools_LIBRARIES CACHE INTERNAL "There are no dependencies, so this should not be used")
ENDIF(GoTools_INCLUDE_DIRS AND GoTools_LIBRARIES)

