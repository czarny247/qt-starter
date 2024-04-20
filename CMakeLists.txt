cmake_minimum_required(VERSION 3.23)
project(QtStarter CXX)

set(BUILT_DIR ${CMAKE_BINARY_DIR}/built CACHE PATH "Where to copy ready executables and their dependencies")

list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")
include(ConfigureDeployment)
include(DeduceBuildType)
include(InstallationHelpers)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

DEDUCE_BUILD_TYPE()
set(RT_OUT_DIR ${BUILT_DIR}/${CMAKE_BUILD_TYPE})

include(CMakePrintHelpers)
cmake_print_variables(CMAKE_PREFIX_PATH)

find_package(Qt6
	COMPONENTS 
    	Quick
    	Gui
    	Core
	REQUIRED
)

qt_policy(SET QTP0001 NEW)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

set(PRIVATE_LINK_LIBRARIES
	Qt6::Gui
	Qt6::Core
	Qt6::Quick)

set(SOURCE
	${PROJECT_NAME}/src/main.cpp
)

qt_add_executable(
	${PROJECT_NAME}
	MANUAL_FINALIZATION
	${SOURCE}
)

target_link_libraries(${PROJECT_NAME} PRIVATE ${PRIVATE_LINK_LIBRARIES})
set_target_properties(${PROJECT_NAME} PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${RT_OUT_DIR})

#TODO PASS QTMODULES TO FN
qt_add_qml_module(${PROJECT_NAME}
	URI ${PROJECT_NAME}.ui
	OUTPUT_DIRECTORY ${RT_OUT_DIR}
	VERSION 1.0
	QML_FILES ${PROJECT_NAME}/ui/main.qml) #STORE VARIABLE PROJECTUI OR STH

target_compile_definitions(
	${PROJECT_NAME}
	PRIVATE
		$<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>
)

qt_finalize_executable(${PROJECT_NAME})

option(BUILD_FOR_INSTALLATION "Build for installation?" OFF)

set(INSTALL_ROOT ${PROJECT_NAME})


list(APPEND DESTINATION_TYPES "BUILD")

if(BUILD_FOR_INSTALLATION)
	list(APPEND DESTINATION_TYPES "INSTALLATION")
endif()

CONFIGURE_INSTALLATION_FOR(
	DESTINATION_TYPES ${DESTINATION_TYPES}
	APPNAME ${PROJECT_NAME}
)