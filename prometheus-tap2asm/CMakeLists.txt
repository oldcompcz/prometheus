cmake_minimum_required(VERSION 3.16)
project(prometheus_tap2asm C)

set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS OFF)

add_library(promtap STATIC
  src/promtap.c
  src/trdos.c
)
target_include_directories(promtap PUBLIC include PRIVATE src)
if(MSVC)
  target_compile_options(promtap PRIVATE /W4 /WX)
else()
  target_compile_options(promtap PRIVATE -Wall -Wextra -Wpedantic -Werror)
endif()

add_executable(prometheus-tap2asm src/main.c)
target_link_libraries(prometheus-tap2asm PRIVATE promtap)

include(CTest)
if(BUILD_TESTING)
  add_executable(test_core tests/test_core.c)
  target_include_directories(test_core PRIVATE include src)
  target_link_libraries(test_core PRIVATE promtap)
  if(MSVC)
    target_compile_options(test_core PRIVATE /W4 /WX)
  else()
    target_compile_options(test_core PRIVATE -Wall -Wextra -Wpedantic -Werror)
  endif()
  add_test(NAME core COMMAND test_core)
  if(UNIX)
    add_test(
      NAME cli
      COMMAND ${CMAKE_COMMAND} -E env
              PROMTAP_BIN=$<TARGET_FILE:prometheus-tap2asm>
              sh ${CMAKE_CURRENT_SOURCE_DIR}/tests/test_cli.sh
    )
    set_tests_properties(cli PROPERTIES
      DEPENDS core
      WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
    )
  endif()
endif()
