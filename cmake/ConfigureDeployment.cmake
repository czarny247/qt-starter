function(CONFIGURE_DEPLOYMENT what where)
    if(Qt6_FOUND AND WIN32 AND TARGET Qt6::qmake AND NOT TARGET Qt6::windeployqt)
        get_target_property(_qt6_qmake_location Qt6::qmake IMPORTED_LOCATION)
        
        execute_process(
            COMMAND ${_qt6_qmake_location} -query QT_INSTALL_PREFIX
            RESULT_VARIABLE return_code
            OUTPUT_VARIABLE qt6_install_prefix
            OUTPUT_STRIP_TRAILING_WHITESPACE
        )

        set(imported_location "${qt6_install_prefix}/bin/windeployqt.exe")

        if(EXISTS ${imported_location})
            add_executable(Qt6::windeployqt IMPORTED)

            set_target_properties(Qt6::windeployqt PROPERTIES
                IMPORTED_LOCATION ${imported_location})
        endif()
    endif()

    if(TARGET Qt6::windeployqt)
        add_custom_command(TARGET ${what}
            POST_BUILD
            COMMAND ${CMAKE_COMMAND} -E remove_directory "${CMAKE_CURRENT_BINARY_DIR}/windeployqt"
            COMMAND set PATH=%PATH%$<SEMICOLON>${qt6_install_prefix}/bin
            COMMAND Qt6::windeployqt
                --qmldir "${PROJECT_SOURCE_DIR}/${what}/ui"
                --dir "${CMAKE_CURRENT_BINARY_DIR}/windeployqt"
                "$<TARGET_FILE_DIR:${what}>/$<TARGET_FILE_NAME:${what}>")

        install(
            DIRECTORY
            "${CMAKE_CURRENT_BINARY_DIR}/windeployqt/"
            DESTINATION ${where}
        )
    endif()
endfunction()