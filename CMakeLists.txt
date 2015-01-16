cmake_minimum_required(VERSION 2.6)

set(IDL_DIR ${CMAKE_CURRENT_BINARY_DIR}/)
set(CMAKE_ALLOW_LOOSE_LOOP_CONSTRUCTS true)
if (NOT CMAKE_MODULE_PATH)
  set(CMAKE_MODULE_PATH ~/src/hrpsys/trunk/cmake_modules/ CACHE STRING "set path to cmake_modules")
endif (NOT CMAKE_MODULE_PATH)

add_definitions(-std=gnu++0x)

#message (STATUS "/_/_/_/_/_/_/_/_/_/_/_/=${IDL_DIR}")

####
## settings for OpenRTM and OpenHRP
##
include(FindPkgConfig)
include(CheckIncludeFiles)
find_package(OpenRTM REQUIRED)
find_package(OpenHRP REQUIRED)


include_directories(${OPENRTM_INCLUDE_DIRS})
link_directories(${OPENRTM_LIBRARY_DIRS})
include_directories(${OPENHRP_INCLUDE_DIRS})
link_directories(${OPENHRP_LIBRARY_DIRS})

include_directories(${CHOREONOID_INCLUDE_DIRS})
link_directories(${CHOREONOID_LIBRARY_DIRS})

include_directories(/usr/local/include)
include_directories(${CMAKE_MODULE_PATH})

##################
#########
##################
if(NOT CHOREONOID_DIR)
 if(UNIX)
    pkg_check_modules(CHOREONOID REQUIRED choreonoid-body-plugin)
    if(CHOREONOID_FOUND)
      set(CHOREONOID_DIR ${CHOREONOID_INCLUDE_DIRS})
    endif()
  endif()
else()
  set(CHOREONOID_INCLUDE_DIRS ${CHOREONOID_DIR})
endif()

message("choreonoid DIR here " ${CHOREONOID_DIR})

set(CHOREONOID_DIR ${CHOREONOID_DIR} CACHE PATH "The directory of the choreonoid library")

if(NOT CHOREONOID_INCLUDE_DIRS)
  message(FATAL_ERROR "Please specify the choreonoid directory to CHOREONOID_DIR.")
else()
  include_directories(${CHOREONOID_INCLUDE_DIRS})
  link_directories(${CHOREONOID_LIBRARY_DIRS})
endif()

include(GenerateStubSkel)

####
## for each component
##
set(comp_name wuTest)
set(comp_sources ${comp_name}.cpp)

generate_stub_skel(${comp_name}Service)
set(comp_sources ${comp_sources} ${comp_name}Service_impl.cpp ${comp_name}ServiceSk.cpp)

add_library(${comp_name} SHARED ${comp_sources})
target_link_libraries(${comp_name} ${CHOREONOID_LIBRARIES} CnoidBody CnoidBodyPlugin CnoidUtil CnoidBase )
target_link_libraries(${comp_name} ${OPENRTM_LIBRARIES})

target_link_libraries(${comp_name} lapack blas f2c m)
set_target_properties(${comp_name} PROPERTIES PREFIX "")

if (NO_COMP)
  set(target ${comp_name})
else()
  set(target ${comp_name} ${comp_name}Comp)
  add_executable(${comp_name}Comp ${comp_name}Comp.cpp ${comp_sources})
  target_link_libraries(${comp_name}Comp ${OPENRTM_LIBRARIES})
  target_link_libraries(${comp_name}Comp ${CHOREONOID_LIBRARIES} CnoidBody CnoidBodyPlugin CnoidUtil CnoidBase )
  target_link_libraries(${comp_name}Comp boost_filesystem)
  target_link_libraries(${comp_name}Comp m)
endif()

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -ggdb3 -fno-schedule-insns -fno-schedule-insns2 -fno-strict-aliasing")

#install(TARGETS  ${comp_name}
#  RUNTIME DESTINATION bin CONFIGURATIONS Release Debug
#  LIBRARY DESTINATION lib CONFIGURATIONS Release Debug
#  )

message(runrun "${RUNTIME}")

#INSTALL(FILES  ${comp_name}.so  DESTINATION  "/home/wu/chorenoid/lib/choreonoid-1.5/rtc")
##INSTALL(FILES  ${comp_name}Service.jar  DESTINATION  "/usr/local/share/java")