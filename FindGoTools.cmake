# - Tries to find the GoTools Core library
#
# Original version by: jan.b.thomassen@sintef.no
# Contributions from sverre.briseid@sintef.no
# Rewritten to model FindBoost by andre.brodtkorb@sintef.no
# Rewritten to find optimised&debug by erik.bjonnes@sintef.no
#
INCLUDE(FindPackageHandleStandardArgs)

MESSAGE("Trying to find the following GoTools components: '${GoTools_FIND_COMPONENTS}'")

SET(GoTools_ROOT "" CACHE PATH "Root to GoTools directory")
MARK_AS_ADVANCED( GoTools_ROOT )

#Set default search paths for includes
SET(GoTools_INCLUDE_SEARCH_PATHS "")
LIST(APPEND GoTools_INCLUDE_SEARCH_PATHS
  "${GoTools_ROOT}/include"
  "$ENV{HOME}/include"
  "$ENV{HOME}/install/include"
  "C:/Program Files (x86)/GoTools/include"
  "$ENV{PROGRAMFILES}/SINTEF/GoTools/include"
)
	
#Set default search paths for libs
SET(GoTools_LIBRARY_SEARCH_PATHS "")
LIST(APPEND GoTools_LIBRARY_SEARCH_PATHS
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


SET(GoTools_LIBRARIES_DEBUG "")
SET(GoTools_LIBRARIES_RELEASE "")
SET(GoTools_ALL_FOUND TRUE INTERNAL)

FOREACH(component ${GoTools_FIND_COMPONENTS})
  FIND_LIBRARY(GoTools_${component}_LIBRARY_RELEASE
    NAMES ${component} GoTools${component}
    PATHS ${GoTools_LIBRARY_SEARCH_PATHS}
    PATH_SUFFIXES GoTools Release Win32/Release
    )
  IF(GoTools_${component}_LIBRARY_RELEASE)
    LIST(APPEND GoTools_LIBRARIES_RELEASE "${GoTools_${component}_LIBRARY_RELEASE}")
  ENDIF()

  FIND_LIBRARY(GoTools_${component}_LIBRARY_DEBUG
    NAMES "${component}d" "GoTools${component}d"
    PATHS ${GoTools_LIBRARY_SEARCH_PATHS}
    PATH_SUFFIXES GoTools 
    )
  IF(GoTools_${component}_LIBRARY_DEBUG)
    LIST(APPEND GoTools_LIBRARIES_DEBUG "${GoTools_${component}_LIBRARY_DEBUG}")
  ENDIF()

  FIND_LIBRARY(GoTools_${component}_LIBRARY_DEBUG
    NAMES ${component}
    PATHS ${GoTools_LIBRARY_SEARCH_PATHS}
    PATH_SUFFIXES  Debug Win32/Debug 
    )
  IF(GoTools_${component}_LIBRARY_DEBUG)
    LIST(APPEND GoTools_LIBRARIES_DEBUG "${GoTools_${component}_LIBRARY_DEBUG}")
  ENDIF()

  MARK_AS_ADVANCED( GoTools_${component}_LIBRARY_DEBUG )
  MARK_AS_ADVANCED( GoTools_${component}_LIBRARY_RELEASE )
    IF(GoTools_${component}_LIBRARY_DEBUG OR GoTools_${component}_LIBRARY_RELEASE )
      MESSAGE("Found '${component}'")
    ELSE()
      MESSAGE("Could NOT find '${component}'")
      SET(GoTools_ALL_FOUND FALSE)
    ENDIF()
ENDFOREACH()

SET( GoTools_LIBRARIES "" )
FOREACH( _libname IN LISTS GoTools_LIBRARIES_RELEASE )
  LIST( APPEND GoTools_LIBRARIES optimized "${_libname}" )
ENDFOREACH()
FOREACH( _libname IN LISTS GoTools_LIBRARIES_DEBUG )
  LIST( APPEND GoTools_LIBRARIES debug "${_libname}" )
ENDFOREACH()


SET(GoTools_INCLUDE_DIR ${GoTools_INCLUDE_DIRS} CACHE STRING "GoTools Libraries requested" FORCE)
SET(GoTools_LIBRARY ${GoTools_LIBRARIES} CACHE STRING "GoTools Libraries requested" FORCE)

SET(GoTools_INCLUDE_DIRS  INTERNAL ". There are no dependencies so 'GoTools_INCLUDE_DIRS' should not be used")
SET(GoTools_LIBRARIES  INTERNAL ". There are no dependencies so 'GoTools_LIBRARIES' should not be used")

FIND_PACKAGE_HANDLE_STANDARD_ARGS(GoTools FOUND_VAR GoTools_FOUND 
  REQUIRED_VARS GoTools_INCLUDE_DIR GoTools_LIBRARY GoTools_ALL_FOUND )

