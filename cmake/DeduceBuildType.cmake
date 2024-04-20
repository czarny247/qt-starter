function(DEDUCE_BUILD_TYPE)
    if(CMAKE_BUILD_TYPE STREQUAL "")
    message(WARNING "No CMAKE_BUILD_TYPE specified. Setting it to Debug")
    set(CMAKE_BUILD_TYPE "Debug")
    elseif(NOT (CMAKE_BUILD_TYPE STREQUAL "Debug" OR CMAKE_BUILD_TYPE STREQUAL "Release"))
    message(FATAL_ERROR "CMAKE_BUILD_TYPE should be Debug or Release. Current: ${CMAKE_BUILD_TYPE}")
    #TODO SUPPORT MORE BUILD TYPES
    endif()
endfunction()
