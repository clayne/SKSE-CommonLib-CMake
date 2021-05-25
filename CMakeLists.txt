cmake_minimum_required(VERSION 3.19)

project(Umbrella)

if(USE_SKSE)
    include(cmake/SKSE.cmake)
endif()

if(USE_COMMONLIB)
    include(cmake/CommonLib.cmake)
endif()