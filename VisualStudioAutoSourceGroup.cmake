function(VisualStudioAutoSourceGroup TARGET)
# Copyright SINTEF 2014
# Author: André R. Brodtkorb <Andre.Brodtkorb@sintef.no>
#
# Macro to implement automatically creating source groups
# for visual studio IDE. All sources are placed according
# to their location on disk relative to relpath or 
# CMAKE_CURRENT_SOURCE_DIR
#
# CMakeParseArguments(<target> [RELPATH <relpath>])

include(CMakeParseArguments)

if(MSVC_IDE)
	cmake_parse_arguments(MSASG "" "RELPATH" "" ${ARGN} )

	if(TARGET ${TARGET})
		get_target_property(srcs ${TARGET} SOURCES)
		foreach(filename ${srcs})	
			get_filename_component(tmp1 ${filename} ABSOLUTE)
			if(MSASG_RELPATH)
				get_filename_component(MSASG_RELPATH ${MSASG_RELPATH} ABSOLUTE)
				file(TO_CMAKE_PATH ${MSASG_RELPATH} MSASG_RELPATH)
				file(RELATIVE_PATH tmp2 ${MSASG_RELPATH} ${tmp1})
			else()
				file(RELATIVE_PATH tmp2 ${CMAKE_CURRENT_SOURCE_DIR} ${tmp1})
			endif()
			get_filename_component(tmp3 ${tmp2} DIRECTORY)
			if(tmp3)
				file(TO_NATIVE_PATH ${tmp3} dir)
			else()
				set(dir ${tmp2})
			endif()
			source_group(${dir} FILES ${filename})
		endforeach()
	else()
		message("'${TARGET}' passed to VisualStudioAutoSourceGroup is not a valid target")
	endif()
endif()
endfunction()