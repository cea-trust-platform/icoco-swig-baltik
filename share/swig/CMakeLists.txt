cmake_minimum_required(VERSION 3.5)

set(ATELIER  ON)
include(../../build/src/CMakeLists.txt.trust)      # Needs to be put before "project()" (it tweaks compiler)
set(LIBRARY_OUTPUT_PATH  ${CMAKE_BUILD_DIR})   # Make sure we don't pollute TRUST/lib directory
SET(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)

project(ICoCo_SWIG CXX)
enable_testing()

set(TRUST_ROOT $ENV{TRUST_ROOT})
set(MEDCOUPLING_DIR "$ENV{TRUST_MEDCOUPLING_ROOT}/$ENV{TRUST_ARCH}_opt")

if(NOT $ENV{TRUST_ARCH_CC} STREQUAL "linux_nvc++")
add_definitions(-Wno-error)
add_definitions(-Wno-suggest-override)
add_definitions(-Wno-shadow)
else()
# Disable some warnings for nvc++
add_definitions(--diag_suppress1349 --diag_suppress550)
endif()

set(CMAKE_CXX_COMPILER  $ENV{TRUST_CC})
set(CMAKE_SKIP_RULE_DEPENDENCY 0)

message("Utilisation de la librairie : ${libtrio_name} " )
find_library(libTrio NAMES ${libtrio_name}.a PATHS ${TRUST_ROOT}/lib NO_DEFAULT_PATH )

##
## libbaltik_name and libBaltik for TRUST baltiks (such as triocfd)
##
#set(libbaltik_name _TRUSTModule${ajout}${OPT})
#SET (project_directory $ENV{project_directory})

#message("Utilisation de la librairie : ${libbaltik_name} " )
#find_library(libBaltik NAMES ${libbaltik_name}.so PATHS ${project_directory}/build/src/exec${ajout}${OPT} NO_DEFAULT_PATH )

#if (NOT libBaltik)
#    message(FATAL_ERROR "Could not find BALTIK library: ${libbaltik_name}.so - did you run: make module_optim in your baltik (potentially in debug)??")
#endif()

find_package(PythonInterp 3 REQUIRED)  # Make sure to find TRUST Python first (even if not technically needed) ...
find_package(PythonLibs 3 REQUIRED)    # ... so that TRUST Python libs are found too.

find_package(SWIG REQUIRED)
include(${SWIG_USE_FILE})

##
## Python module build
##
include_directories(SYSTEM
  ${CMAKE_CURRENT_SOURCE_DIR}
  ${TRUST_ROOT}/src/Kernel/ICoCo
  ${TRUST_ROOT}/lib/src/LIBICOCOAPI/include
  ${MEDCOUPLING_DIR}/include
  ${PYTHON_INCLUDE_PATH})

set_source_files_properties(swigbaltikicoco.i PROPERTIES CPLUSPLUS ON)
set_source_files_properties(swigbaltikicoco.i PROPERTIES SWIG_FLAGS "-py3")

swig_add_library(swigbaltikicoco LANGUAGE python SOURCES swigbaltikicoco.i)
swig_link_libraries(swigbaltikicoco ${libdeps} ${libBaltik} ${libTrio} ${syslib} ${PYTHON_LIBRARIES} )

##
## Tests
##
# Copy files to binary since a trust run generates a lot of crap ...
file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/test)
file(GLOB tst_files "${CMAKE_CURRENT_SOURCE_DIR}/test/*")
file(COPY ${tst_files} DESTINATION ${CMAKE_CURRENT_BINARY_DIR}/test)
add_test(NAME baltik_swig
         COMMAND ${CMAKE_COMMAND} -E env
              PYTHONPATH=${CMAKE_BINARY_DIR}:$ENV{PYTHONPATH}
           ${PYTHON_EXECUTABLE} test_swigbaltikicoco.py
         WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/test)

##
## Installation
##
install(TARGETS ${SWIG_MODULE_swigbaltikicoco_REAL_NAME} DESTINATION lib)
install(FILES ${CMAKE_CURRENT_BINARY_DIR}/swigbaltikicoco.py DESTINATION lib)
