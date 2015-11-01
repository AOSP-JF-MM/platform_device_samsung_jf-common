LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_SRC_FILES := \
    libril_jflte.cpp

LOCAL_SHARED_LIBRARIES := libbinder

LOCAL_MODULE := libril_jflte
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := SHARED_LIBRARIES

include $(BUILD_SHARED_LIBRARY)

