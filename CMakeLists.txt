cmake_minimum_required(VERSION 3.19)

project(Umbrella)

include(cmake/CPM.cmake)
include(cmake/Packages.cmake)

if(USE_SKSE)
    include(cmake/SKSE.cmake)
endif()
if(USE_COMMONLIB)
    include(cmake/CommonLib.cmake)
endif()