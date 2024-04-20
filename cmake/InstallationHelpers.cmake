function(CHECK_VS_2022 RESULT)
    string(FIND ${CMAKE_CXX_COMPILER} "2022" FOUND_INDEX)
    if(FOUND_INDEX EQUAL -1)
        set(${RESULT} FALSE PARENT_SCOPE)
    else()
        set(${RESULT} TRUE PARENT_SCOPE)
    endif()
endfunction()

function(INSTALL_SYSTEM_LIBRARIES where)
    if(WIN32)
        if(CMAKE_BUILD_TYPE STREQUAL Debug)
            set(CMAKE_INSTALL_DEBUG_LIBRARIES TRUE)
            set(CMAKE_INSTALL_DEBUG_LIBRARIES_ONLY TRUE)
        endif()

        set(CMAKE_INSTALL_UCRT_LIBRARIES TRUE)
        set(CMAKE_INSTALL_SYSTEM_RUNTIME_LIBS_SKIP TRUE)

        ##################################################################################
        # below lines are still relevant as of MSVC 17.5.33530.505                       #
        # there is a bug where MSVC sets incorrect MSVC_VERSION and MSVC_TOOLSET_VERSION #
        # MSVC_TOOLSET_VERSION is set 142 in MSVC Build tools 2022                       #
        # which should have MSVC_TOOLSET_VERSION 143                                     #
        # The outcome is that some debug libraries are not correctly installed           #
        #                                                                                #
        # MSVC_VERSION, while also incorrect, does not impact libraries installation     #
        # and so has been left unchanged                                                 #
        # references:                                                                    #
        # https://cmake.org/cmake/help/latest/variable/MSVC_TOOLSET_VERSION.html         #
        # https://bluecromos.atlassian.net/browse/ISA-913                                #
        ##################################################################################
        CHECK_VS_2022(IS_VS2022)
        if(MSVC_TOOLSET_VERSION GREATER_EQUAL 143 AND IS_VS2022)
            message(
                DEPRECATION
                "Visual Studio 2022 MSVC_TOOLSET_VERSION workaround may be no longer valid. Please verify.")
        elseif(IS_VS2022)
            set(MSVC_TOOLSET_VERSION 143)
        endif()

        include(InstallRequiredSystemLibraries)
        install(PROGRAMS ${CMAKE_INSTALL_SYSTEM_RUNTIME_LIBS} DESTINATION ${where})
    endif()
endfunction()

include(ConfigureDeployment)

function(CONFIGURE_INSTALLATION_FOR)
    cmake_parse_arguments(
        "" 
        "" 
        "APPNAME"
        "DESTINATION_TYPES" ${ARGN}
    )

    set(DESTINATION_FULL "")
    set(DESTINATION_ROOT ${_APPNAME})

    foreach(destination_type IN LISTS _DESTINATION_TYPES)
        if(destination_type MATCHES "^INSTALLATION$")
            set(DESTINATION_FULL ${CMAKE_INSTALL_PREFIX}/${DESTINATION_ROOT})
        endif()
        if(destination_type MATCHES "^BUILD$")
            set(DESTINATION_FULL ${RT_OUT_DIR})
        endif()

        CONFIGURE_DEPLOYMENT(${_APPNAME} ${DESTINATION_FULL})
        INSTALL_SYSTEM_LIBRARIES(${DESTINATION_ROOT})
        install(TARGETS ${_APPNAME} DESTINATION ${DESTINATION_ROOT})
    endforeach()
endfunction()