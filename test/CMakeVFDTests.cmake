
# Copyright by The HDF Group.
# All rights reserved.
#
# This file is part of HDF5.  The full HDF5 copyright notice, including
# terms governing use, modification, and redistribution, is contained in
# the COPYING file, which can be found at the root of the source code
# distribution tree, or in https://support.hdfgroup.org/ftp/HDF5/releases.
# If you do not have access to either file, you may request a copy from
# help@hdfgroup.org.
#

##############################################################################
##############################################################################
###           T E S T I N G                                                ###
##############################################################################
##############################################################################
# included from CMakeTEsts.cmake

set (VFD_LIST
    sec2
    stdio
    core
    core_paged
    split
    multi
    family
)
if (DIRECT_VFD)
  set (VFD_LIST ${VFD_LIST} direct)
endif ()

foreach (vfdtest ${VFD_LIST})
  file (MAKE_DIRECTORY "${PROJECT_BINARY_DIR}/${vfdtest}")
  if (BUILD_SHARED_LIBS)
    file (MAKE_DIRECTORY "${PROJECT_BINARY_DIR}/${vfdtest}-shared")
  endif ()
endforeach ()

foreach (vfdtest ${VFD_LIST})
  foreach (h5_tfile ${HDF5_TEST_FILES})
    HDFTEST_COPY_FILE("${HDF5_TOOLS_DIR}/testfiles/${h5_tfile}" "${PROJECT_BINARY_DIR}/${vfdtest}/${h5_tfile}" "HDF5_VFDTEST_LIB_files")
    if (BUILD_SHARED_LIBS)
      HDFTEST_COPY_FILE("${HDF5_TOOLS_DIR}/testfiles/${h5_tfile}" "${PROJECT_BINARY_DIR}/${vfdtest}-shared/${h5_tfile}" "HDF5_VFDTEST_LIBSH_files")
    endif ()
  endforeach ()
endforeach ()

foreach (vfdtest ${VFD_LIST})
  foreach (ref_file ${HDF5_REFERENCE_FILES})
    HDFTEST_COPY_FILE("${HDF5_TEST_SOURCE_DIR}/testfiles/${ref_file}" "${PROJECT_BINARY_DIR}/${vfdtest}/${ref_file}" "HDF5_VFDTEST_LIB_files")
    if (BUILD_SHARED_LIBS)
      HDFTEST_COPY_FILE("${HDF5_TEST_SOURCE_DIR}/testfiles/${ref_file}" "${PROJECT_BINARY_DIR}/${vfdtest}-shared/${ref_file}" "HDF5_VFDTEST_LIBSH_files")
    endif ()
  endforeach ()
endforeach ()

foreach (vfdtest ${VFD_LIST})
  foreach (h5_file ${HDF5_REFERENCE_TEST_FILES})
    HDFTEST_COPY_FILE("${HDF5_TEST_SOURCE_DIR}/${h5_file}" "${HDF5_TEST_BINARY_DIR}/${vfdtest}/${h5_file}" "HDF5_VFDTEST_LIB_files")
    if (BUILD_SHARED_LIBS)
      HDFTEST_COPY_FILE("${HDF5_TEST_SOURCE_DIR}/${h5_file}" "${HDF5_TEST_BINARY_DIR}/${vfdtest}-shared/${h5_file}" "HDF5_VFDTEST_LIBSH_files")
    endif ()
  endforeach ()
endforeach ()

add_custom_target(HDF5_VFDTEST_LIB_files ALL COMMENT "Copying files needed by HDF5_VFDTEST_LIB tests" DEPENDS ${HDF5_VFDTEST_LIB_files_list})
if (BUILD_SHARED_LIBS)
  add_custom_target(HDF5_VFDTEST_LIBSH_files ALL COMMENT "Copying files needed by HDF5_VFDTEST_LIBSH tests" DEPENDS ${HDF5_VFDTEST_LIBSH_files_list})
endif ()

##############################################################################
##############################################################################
###                         V F D   T E S T S                              ###
##############################################################################
##############################################################################

  set (H5_VFD_SKIP_TESTS
      cache
      accum
      fheap
      big
      vfd
      error_test
      err_compat
      tcheck_version
      testmeta
      links_env
  )
  if (NOT CYGWIN)
    list(REMOVE_ITEM ${H5_VFD_SKIP_TESTS} big cache)
  endif ()

  # Windows only macro
  macro (CHECK_VFD_TEST vfdtest vfdname resultcode)
    if ("${vfdtest}" STREQUAL "flush1" OR "${vfdtest}" STREQUAL "flush2")
      if ("${vfdname}" STREQUAL "multi" OR "${vfdname}" STREQUAL "split")
        if (NOT BUILD_SHARED_LIBS AND NOT ${HDF_CFG_NAME} MATCHES "Debug")
          add_test (NAME VFD-${vfdname}-${vfdtest}
              COMMAND "${CMAKE_COMMAND}"
                  -D "TEST_PROGRAM=$<TARGET_FILE:${vfdtest}>"
                  -D "TEST_ARGS:STRING="
                  -D "TEST_VFD:STRING=${vfdname}"
                  -D "TEST_EXPECT=${resultcode}"
                  -D "TEST_OUTPUT=${vfdname}-${vfdtest}"
                  -D "TEST_FOLDER=${PROJECT_BINARY_DIR}/${vfdname}"
                  -P "${HDF_RESOURCES_DIR}/vfdTest.cmake"
          )
          set_tests_properties (VFD-${vfdname}-${vfdtest} PROPERTIES
              ENVIRONMENT "srcdir=${HDF5_TEST_BINARY_DIR}/${vfdname}"
              WORKING_DIRECTORY ${HDF5_TEST_BINARY_DIR}/${vfdname}
          )
          if (BUILD_SHARED_LIBS)
            add_test (NAME VFD-${vfdname}-${test}-shared
                COMMAND "${CMAKE_COMMAND}"
                    -D "TEST_PROGRAM=$<TARGET_FILE:${vfdtest}-shared>"
                    -D "TEST_ARGS:STRING="
                    -D "TEST_VFD:STRING=${vfdname}"
                    -D "TEST_EXPECT=${resultcode}"
                    -D "TEST_OUTPUT=${vfdname}-${vfdtest}-shared"
                    -D "TEST_FOLDER=${PROJECT_BINARY_DIR}/${vfdname}-shared"
                    -P "${HDF_RESOURCES_DIR}/vfdTest.cmake"
            )
            set_tests_properties (VFD-${vfdname}-${vfdtest}-shared PROPERTIES
                ENVIRONMENT "srcdir=${HDF5_TEST_BINARY_DIR}/${vfdname}-shared"
                WORKING_DIRECTORY ${HDF5_TEST_BINARY_DIR}/${vfdname}-shared
            )
          endif ()
        else ()
          add_test (NAME VFD-${vfdname}-${vfdtest}
              COMMAND ${CMAKE_COMMAND} -E echo "SKIP VFD-${vfdname}-${vfdtest}"
          )
          if (BUILD_SHARED_LIBS)
            add_test (NAME VFD-${vfdname}-${test}-shared
                COMMAND ${CMAKE_COMMAND} -E echo "SKIP VFD-${vfdname}-${vfdtest}-shared"
            )
          endif ()
        endif ()
      else ()
        add_test (NAME VFD-${vfdname}-${vfdtest}
            COMMAND "${CMAKE_COMMAND}"
                -D "TEST_PROGRAM=$<TARGET_FILE:${vfdtest}>"
                -D "TEST_ARGS:STRING="
                -D "TEST_VFD:STRING=${vfdname}"
                -D "TEST_EXPECT=${resultcode}"
                -D "TEST_OUTPUT=${vfdname}-${vfdtest}"
                -D "TEST_FOLDER=${PROJECT_BINARY_DIR}/${vfdname}"
                -P "${HDF_RESOURCES_DIR}/vfdTest.cmake"
        )
        set_tests_properties (VFD-${vfdname}-${vfdtest} PROPERTIES
            ENVIRONMENT "srcdir=${HDF5_TEST_BINARY_DIR}/${vfdname}"
            WORKING_DIRECTORY ${HDF5_TEST_BINARY_DIR}/${vfdname}
        )
        if (BUILD_SHARED_LIBS)
          add_test (NAME VFD-${vfdname}-${test}-shared
              COMMAND "${CMAKE_COMMAND}"
                -D "TEST_PROGRAM=$<TARGET_FILE:${vfdtest}-shared>"
                -D "TEST_ARGS:STRING="
                -D "TEST_VFD:STRING=${vfdname}"
                -D "TEST_EXPECT=${resultcode}"
                -D "TEST_OUTPUT=${vfdname}-${vfdtest}-shared"
                -D "TEST_FOLDER=${PROJECT_BINARY_DIR}/${vfdname}-shared"
                -P "${HDF_RESOURCES_DIR}/vfdTest.cmake"
          )
          set_tests_properties (VFD-${vfdname}-${vfdtest}-shared PROPERTIES
              ENVIRONMENT "srcdir=${HDF5_TEST_BINARY_DIR}/${vfdname}-shared"
              WORKING_DIRECTORY ${HDF5_TEST_BINARY_DIR}/${vfdname}-shared
          )
        endif ()
      endif ()
    else ()
      add_test (NAME VFD-${vfdname}-${vfdtest}
          COMMAND "${CMAKE_COMMAND}"
              -D "TEST_PROGRAM=$<TARGET_FILE:${vfdtest}>"
              -D "TEST_ARGS:STRING="
              -D "TEST_VFD:STRING=${vfdname}"
              -D "TEST_EXPECT=${resultcode}"
              -D "TEST_OUTPUT=${vfdname}-${vfdtest}"
              -D "TEST_FOLDER=${PROJECT_BINARY_DIR}/${vfdname}"
              -P "${HDF_RESOURCES_DIR}/vfdTest.cmake"
      )
      set_tests_properties (VFD-${vfdname}-${vfdtest} PROPERTIES
          ENVIRONMENT "srcdir=${HDF5_TEST_BINARY_DIR}/${vfdname};HDF5TestExpress=${HDF_TEST_EXPRESS}"
          WORKING_DIRECTORY ${HDF5_TEST_BINARY_DIR}/${vfdname}
      )
      if (BUILD_SHARED_LIBS AND NOT "${vfdtest}" STREQUAL "cache")
        add_test (NAME VFD-${vfdname}-${vfdtest}-shared
            COMMAND "${CMAKE_COMMAND}"
                -D "TEST_PROGRAM=$<TARGET_FILE:${vfdtest}-shared>"
                -D "TEST_ARGS:STRING="
                -D "TEST_VFD:STRING=${vfdname}"
                -D "TEST_EXPECT=${resultcode}"
                -D "TEST_OUTPUT=${vfdname}-${vfdtest}-shared"
                -D "TEST_FOLDER=${PROJECT_BINARY_DIR}/${vfdname}-shared"
                -P "${HDF_RESOURCES_DIR}/vfdTest.cmake"
        )
        set_tests_properties (VFD-${vfdname}-${vfdtest}-shared PROPERTIES
            ENVIRONMENT "srcdir=${HDF5_TEST_BINARY_DIR}/${vfdname}-shared;HDF5TestExpress=${HDF_TEST_EXPRESS}"
            WORKING_DIRECTORY ${HDF5_TEST_BINARY_DIR}/${vfdname}-shared
        )
        endif ()
    endif ()
  endmacro ()

  macro (DO_VFD_TEST vfdtest vfdname resultcode)
      add_test (NAME VFD-${vfdname}-${vfdtest}
          COMMAND "${CMAKE_COMMAND}"
              -D "TEST_PROGRAM=$<TARGET_FILE:${vfdtest}>"
              -D "TEST_ARGS:STRING="
              -D "TEST_VFD:STRING=${vfdname}"
              -D "TEST_EXPECT=${resultcode}"
              -D "TEST_OUTPUT=${vfdname}-${vfdtest}"
              -D "TEST_FOLDER=${PROJECT_BINARY_DIR}/${vfdname}"
              -P "${HDF_RESOURCES_DIR}/vfdTest.cmake"
      )
      set_tests_properties (VFD-${vfdname}-${vfdtest} PROPERTIES
          ENVIRONMENT "srcdir=${HDF5_TEST_BINARY_DIR}/${vfdname}"
          WORKING_DIRECTORY ${HDF5_TEST_BINARY_DIR}/${vfdname}
      )
      if (BUILD_SHARED_LIBS)
        add_test (NAME VFD-${vfdname}-${vfdtest}-shared
            COMMAND "${CMAKE_COMMAND}"
                -D "TEST_PROGRAM=$<TARGET_FILE:${vfdtest}-shared>"
                -D "TEST_ARGS:STRING="
                -D "TEST_VFD:STRING=${vfdname}"
                -D "TEST_EXPECT=${resultcode}"
                -D "TEST_OUTPUT=${vfdname}-${vfdtest}-shared"
                -D "TEST_FOLDER=${PROJECT_BINARY_DIR}/${vfdname}-shared"
                -P "${HDF_RESOURCES_DIR}/vfdTest.cmake"
        )
        set_tests_properties (VFD-${vfdname}-${vfdtest}-shared PROPERTIES
            ENVIRONMENT "srcdir=${HDF5_TEST_BINARY_DIR}/${vfdname}-shared"
            WORKING_DIRECTORY ${HDF5_TEST_BINARY_DIR}/${vfdname}-shared
        )
      endif ()
  endmacro ()

  macro (ADD_VFD_TEST vfdname resultcode)
    foreach (test ${H5_TESTS})
      if (NOT "${test}" IN_LIST H5_VFD_SKIP_TESTS)
        if (WIN32)
          CHECK_VFD_TEST (${test} ${vfdname} ${resultcode})
        else ()
          DO_VFD_TEST (${test} ${vfdname} ${resultcode})
        endif ()
      endforeach ()
      set_tests_properties (VFD-${vfdname}-flush2 PROPERTIES DEPENDS VFD-${vfdname}-flush1)
      set_tests_properties (VFD-${vfdname}-flush1 PROPERTIES TIMEOUT 10)
      set_tests_properties (VFD-${vfdname}-flush2 PROPERTIES TIMEOUT 10)
      set_tests_properties (VFD-${vfdname}-istore PROPERTIES TIMEOUT 1800)
      if (NOT CYGWIN)
        set_tests_properties (VFD-${vfdname}-cache PROPERTIES TIMEOUT 1800)
      endif ()
      if (BUILD_SHARED_LIBS)
        set_tests_properties (VFD-${vfdname}-flush2-shared PROPERTIES DEPENDS VFD-${vfdname}-flush1-shared)
        set_tests_properties (VFD-${vfdname}-flush1-shared PROPERTIES TIMEOUT 10)
        set_tests_properties (VFD-${vfdname}-flush2-shared PROPERTIES TIMEOUT 10)
        set_tests_properties (VFD-${vfdname}-istore-shared PROPERTIES TIMEOUT 1800)
        if (NOT CYGWIN AND NOT WIN32)
          set_tests_properties (VFD-${vfdname}-cache-shared PROPERTIES TIMEOUT 1800)
        endif ()
      endif ()
      if (HDF5_TEST_FHEAP_VFD)
        add_test (NAME VFD-${vfdname}-fheap
            COMMAND "${CMAKE_COMMAND}"
                -D "TEST_PROGRAM=$<TARGET_FILE:fheap>"
                -D "TEST_ARGS:STRING="
                -D "TEST_VFD:STRING=${vfdname}"
                -D "TEST_EXPECT=${resultcode}"
                -D "TEST_OUTPUT=${vfdname}-fheap"
                -D "TEST_FOLDER=${PROJECT_BINARY_DIR}/${vfdname}"
                -P "${HDF_RESOURCES_DIR}/vfdTest.cmake"
        )
        set_tests_properties (VFD-${vfdname}-fheap PROPERTIES
            TIMEOUT 1800
            ENVIRONMENT "srcdir=${HDF5_TEST_BINARY_DIR}/${vfdname};HDF5TestExpress=${HDF_TEST_EXPRESS}"
            WORKING_DIRECTORY ${HDF5_TEST_BINARY_DIR}/${vfdname}
        )
        if (BUILD_SHARED_LIBS)
          add_test (NAME VFD-${vfdname}-fheap-shared
              COMMAND "${CMAKE_COMMAND}"
                  -D "TEST_PROGRAM=$<TARGET_FILE:fheap-shared>"
                  -D "TEST_ARGS:STRING="
                  -D "TEST_VFD:STRING=${vfdname}"
                  -D "TEST_EXPECT=${resultcode}"
                  -D "TEST_OUTPUT=${vfdname}-fheap-shared"
                  -D "TEST_FOLDER=${PROJECT_BINARY_DIR}/${vfdname}-shared"
                  -P "${HDF_RESOURCES_DIR}/vfdTest.cmake"
          )
          set_tests_properties (VFD-${vfdname}-fheap-shared PROPERTIES
              TIMEOUT 1800
              ENVIRONMENT "srcdir=${HDF5_TEST_BINARY_DIR}/${vfdname}-shared;HDF5TestExpress=${HDF_TEST_EXPRESS}"
              WORKING_DIRECTORY ${HDF5_TEST_BINARY_DIR}/${vfdname}-shared
          )
        endif ()
      endif ()
    endif ()
  endmacro ()

  # Run test with different Virtual File Driver
  foreach (vfd ${VFD_LIST})
    ADD_VFD_TEST (${vfd} 0)
  endforeach ()
