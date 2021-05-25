if(NOT MSVC)
    message(FATAL_ERROR "Building CommonLib requires MSVC!")
endif()

# Download URL
set(COMMONLIB_DOWNLOAD_URL "https://github.com/Ryan-rsm-McKenzie/CommonLibSSE/archive/refs/heads/master.zip")

# Download Path
set(COMMONLIB_DOWNLOAD_PATH "${CMAKE_BINARY_DIR}/CommonLibSSE-master.7z")

# Extraction Path
set(COMMONLIB_EXTRACTION_PATH "${CMAKE_BINARY_DIR}/CommonLibSSE-extracted")

# Source Path
set(COMMONLIB_SOURCE_PATH "${CMAKE_SOURCE_DIR}/CommonLibSSE")

# Download archive
if(NOT EXISTS ${COMMONLIB_DOWNLOAD_PATH})
    message("Downloading CommonLibSSE from ${COMMONLIB_DOWNLOAD_URL} to ${COMMONLIB_DOWNLOAD_PATH}")
    file(DOWNLOAD ${COMMONLIB_DOWNLOAD_URL} ${COMMONLIB_DOWNLOAD_PATH} TIMEOUT 60)
endif()

# Extract archive
if(NOT EXISTS ${COMMONLIB_EXTRACTION_PATH})
    message("Extracting CommonLibSSE from ${COMMONLIB_DOWNLOAD_PATH} to ${COMMONLIB_EXTRACTION_PATH}")
    file(ARCHIVE_EXTRACT
            INPUT ${COMMONLIB_DOWNLOAD_PATH}
            #PATTERNS "*"
            DESTINATION ${COMMONLIB_EXTRACTION_PATH}
            )
endif()

# Copy extracted files
if(NOT EXISTS ${COMMONLIB_SOURCE_PATH})
    message("Copying CommonLibSSE source from ${COMMONLIB_EXTRACTION_PATH} to ${COMMONLIB_SOURCE_PATH}")
    file(MAKE_DIRECTORY ${COMMONLIB_SOURCE_PATH})
    file(GLOB COMMONLIB_TMP_GLOB LIST_DIRECTORIES true "${COMMONLIB_EXTRACTION_PATH}/CommonLibSSE-master/*")
    foreach(X IN LISTS COMMONLIB_TMP_GLOB)
        file(COPY ${X} DESTINATION ${COMMONLIB_SOURCE_PATH})
    endforeach()
endif()