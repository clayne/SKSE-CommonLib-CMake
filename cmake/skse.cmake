if(NOT MSVC)
    message(FATAL_ERROR "Building SKSE requires MSVC!")
endif()

set(SKSE_VERSION "2_00_19")
set(SKSE_DOWNLOAD_URL "https://skse.silverlock.org/beta/skse64_${SKSE_VERSION}.7z")

# Download Path
set(SKSE_DOWNLOAD_PATH "${CMAKE_BINARY_DIR}/skse64_${SKSE_VERSION}.7z")

# Extraction Path
set(SKSE_EXTRACTION_PATH "${CMAKE_BINARY_DIR}/skse64-extracted")

# Source Path
set(SKSE_SOURCE_PATH "${CMAKE_SOURCE_DIR}/skse64")

# Download archive
if(NOT EXISTS ${SKSE_DOWNLOAD_PATH})
    message("Downloading SKSE from ${SKSE_DOWNLOAD_URL} to ${SKSE_DOWNLOAD_PATH}")
    file(DOWNLOAD ${SKSE_DOWNLOAD_URL} ${SKSE_DOWNLOAD_PATH} TIMEOUT 60)
endif()

# Extract archive
if(NOT EXISTS ${SKSE_EXTRACTION_PATH})
    message("Extracting SKSE from ${SKSE_DOWNLOAD_PATH} to ${SKSE_EXTRACTION_PATH}")
    file(ARCHIVE_EXTRACT
            INPUT ${SKSE_DOWNLOAD_PATH}
            # only want common, skse64 and skse64_common the rest is useless
            PATTERNS "**/src/common/**" "**/src/skse64/skse64/**" "**/src/skse64/skse64_common/**"
            DESTINATION ${SKSE_EXTRACTION_PATH}
            #LIST_ONLY
            )
endif()

# Copy extracted files
if(NOT EXISTS ${SKSE_SOURCE_PATH})
    message("Copying SKSE source from ${SKSE_EXTRACTION_PATH} to ${SKSE_SOURCE_PATH}")
    file(MAKE_DIRECTORY ${SKSE_SOURCE_PATH})
    file(GLOB SKSE_TMP_GLOB LIST_DIRECTORIES true "${SKSE_EXTRACTION_PATH}/skse64_${SKSE_VERSION}/src/*")
    foreach(X IN LISTS SKSE_TMP_GLOB)
        file(COPY ${X} DESTINATION ${SKSE_SOURCE_PATH})
    endforeach()
endif()

# Fix self-referencing imports
set(PS_BIN "C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe")
function(FIX_IMPORTS FOLDER_PATH PREFIX)
    execute_process(COMMAND ${PS_BIN}
            ${CMAKE_CURRENT_LIST_DIR}/../scripts/fix-imports.ps1 ${SKSE_SOURCE_PATH}/${FOLDER_PATH} ${PREFIX})
endfunction()

# common
FIX_IMPORTS(common common)

# skse64_common
FIX_IMPORTS(skse64/skse64_common skse64_common)

# Copy prepared CMakeLists.txt files
function(COPY_IF_NOT_EXIST FROM TO)
    if(NOT EXISTS ${TO})
        message("Copying file from ${CMAKE_CURRENT_LIST_DIR}/${FROM} to ${TO}")
        configure_file(${CMAKE_CURRENT_LIST_DIR}/${FROM} ${TO} COPYONLY)
    endif()
endfunction()

# top-level
COPY_IF_NOT_EXIST(top-CMakeLists.txt ${SKSE_SOURCE_PATH}/CMakeLists.txt)

# common
COPY_IF_NOT_EXIST(common-CMakeLists.txt ${SKSE_SOURCE_PATH}/common/CMakeLists.txt)

# skse64_common
COPY_IF_NOT_EXIST(skse64_common-CMakeLists.txt ${SKSE_SOURCE_PATH}/skse64/skse64_common/CMakeLists.txt)

# skse64

# Include in project
add_subdirectory(${SKSE_SOURCE_PATH})