include_guard(GLOBAL)

function(download_userver)
  set(OPTIONS)
  set(ONE_VALUE_ARGS VERSION TRY_DIR)
  set(MULTI_VALUE_ARGS OPTIONS)
  cmake_parse_arguments(
      ARG "${OPTIONS}" "${ONE_VALUE_ARGS}" "${MULTI_VALUE_ARGS}" ${ARGN}
  )
  if(NOT ARG_VERSION)
    set(ARG_VERSION develop)
  endif()

  if(ARG_TRY_DIR AND EXISTS "${ARG_TRY_DIR}")
    foreach(OPTION IN LIST ARG_OPTIONS)
      separate_arguments(OPTION)
      list(GET OPTION 0 KEY)
      list(GET OPTION 1 VALUE)
      set("${KEY}" "${VALUE}" CACHE STRING "" FORCE)
    endforeach()

    message(STATUS "Using userver from ${ARG_TRY_DIR}")
    add_subdirectory("${ARG_TRY_DIR}")
    return()
  endif()

  include(get_cpm)
  CPMAddPackage(
      NAME userver
      GITHUB_REPOSITORY userver-framework/userver
      GIT_TAG "${ARG_VERSION}"
      OPTIONS ${ARG_OPTIONS}
  )
endfunction()
