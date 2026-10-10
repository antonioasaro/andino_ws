# CMake generated Testfile for 
# Source directory: /home/ubuntu/andino_ws/src/andino/andino_base
# Build directory: /home/ubuntu/andino_ws/build/andino_base
# 
# This file includes the relevant testing commands required for 
# testing this directory and lists subdirectories to be tested as well.
add_test(clang_format "/usr/bin/python3" "-u" "/opt/ros/humble/share/ament_cmake_test/cmake/run_test.py" "/home/ubuntu/andino_ws/build/andino_base/test_results/andino_base/clang_format.xunit.xml" "--package-name" "andino_base" "--output-file" "/home/ubuntu/andino_ws/build/andino_base/ament_clang_format/clang_format.txt" "--command" "/opt/ros/humble/bin/ament_clang_format" "--xunit-file" "/home/ubuntu/andino_ws/build/andino_base/test_results/andino_base/clang_format.xunit.xml" "--config" "/home/ubuntu/andino_ws/src/andino/andino_base/.clang-format")
set_tests_properties(clang_format PROPERTIES  LABELS "clang_format;linter" TIMEOUT "60" WORKING_DIRECTORY "/home/ubuntu/andino_ws/src/andino/andino_base" _BACKTRACE_TRIPLES "/opt/ros/humble/share/ament_cmake_test/cmake/ament_add_test.cmake;125;add_test;/opt/ros/humble/share/ament_cmake_clang_format/cmake/ament_clang_format.cmake;57;ament_add_test;/home/ubuntu/andino_ws/src/andino/andino_base/CMakeLists.txt;31;ament_clang_format;/home/ubuntu/andino_ws/src/andino/andino_base/CMakeLists.txt;0;")
subdirs("applications")
subdirs("src")
