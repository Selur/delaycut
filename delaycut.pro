QT         += core gui

greaterThan(QT_MAJOR_VERSION, 4) {
  QT += widgets
  DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x000000
}

CONFIG     += qt console c++11
TARGET      = delaycut
TEMPLATE    = app

INCLUDEPATH += src

SOURCES    += src/main.cpp\
              src/delaycut.cpp \
              src/delayac3.cpp \
              src/dragdroplineedit.cpp

HEADERS    += src/delaycut.h \
              src/sil48.h \
              src/delayac3.h \
              src/dc_types.h \
              src/dragdroplineedit.h

FORMS      += src/delaycut.ui

win32 {
  RESOURCES  += src/icon_ico.qrc
  RC_FILE     = src/delaycut.rc
}

!win32 {
  lessThan(QT_MAJOR_VERSION, 6) {
    QMAKE_CXXFLAGS += -std=c++11 # C++11 support
  } else {
    QMAKE_CXXFLAGS += -std=c++17 # C++17 support
  }

  QMAKE_CXXFLAGS += -Wno-unused-but-set-variable -Wno-unused-variable
  RESOURCES  += src/icon_png.qrc
  target.path = /usr/bin
  INSTALLS   += target
}

win32-g++* {
  lessThan(QT_MAJOR_VERSION, 6) {
    QMAKE_CXXFLAGS += -std=c++11 # C++11 support
  } else {
    QMAKE_CXXFLAGS += -std=c++17 # C++17 support
    QMAKE_CXXFLAGS += /Zc:__cplusplus
  }
  QMAKE_CXXFLAGS += -Wno-unused-but-set-variable

  # tested with MXE (https://github.com/mxe/mxe)
  !contains(QMAKE_HOST.arch, x86_64):QMAKE_LFLAGS += -Wl,--large-address-aware
}

win32-msvc* {
  lessThan(QT_MAJOR_VERSION, 6) {
    CONFIG += c++11 # C++11 support
  } else {
    CONFIG += c++17 # C++11 support
    QMAKE_CXXFLAGS += /std:c++17
  }
  QMAKE_LFLAGS += /STACK:64000000
  QMAKE_CXXFLAGS += -bigobj

  greaterThan(QT_MAJOR_VERSION, 5) {
    QMAKE_LFLAGS += /entry:mainCRTStartup
  }
  QMAKE_CFLAGS_RELEASE += -WX
  QMAKE_CFLAGS_RELEASE_WITH_DEBUGINFO += -WX
  QMAKE_CFLAGS_RELEASE += -link notelemetry.obj

  # some Windows headers violate strictStrings rules
  QMAKE_CXXFLAGS_RELEASE -= -Zc:strictStrings
  QMAKE_CFLAGS_RELEASE -= -Zc:strictStrings
  QMAKE_CFLAGS -= -Zc:strictStrings
  QMAKE_CXXFLAGS -= -Zc:strictStrings
  QMAKE_CXXFLAGS_RELEASE += /Zc:__cplusplus
  QMAKE_CFLAGS_RELEASE += /Zc:__cplusplus
  QMAKE_CFLAGS += /Zc:__cplusplus
  QMAKE_CXXFLAGS += /Zc:__cplusplus

  greaterThan(QT_MAJOR_VERSION, 4):greaterThan(QT_MINOR_VERSION, 4) { # Qt5.5
    lessThan(QT_MAJOR_VERSION, 6) {
      QT += winextras
    }
    DEFINES += NOMINMAX
  }
  QMAKE_CXXFLAGS += -permissive-
}

QMAKE_CLEAN += qrc_icon_ico.cpp \
               qrc_icon_ico.o \
               qrc_icon_png.cpp \
               qrc_icon_png.o

