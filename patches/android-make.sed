# Android Makefile Patches

# 1. Add Android detection after UNAME line
/UNAME.*:=.*shell uname -s/a\
\
# Detect Android\
ANDROID_DETECT := $(findstring Android,$(shell uname -a))\
ifneq (,$(ANDROID_DETECT))\
  UNAME                   := Android\
endif

# 2. Add Android to supported OS filter
/ifeq (,$(filter \$(UNAME),.*Linux.*OpenBSD.*FreeBSD.*NetBSD.*DragonFly.*Darwin.*CYGWIN.*MSYS2))/s/\(Linux\)\(.*OpenBSD.*FreeBSD.*NetBSD.*DragonFly.*Darwin.*CYGWIN.*MSYS2\)/Android \1\2/

# 3. Replace Linux section with Android + Linux (FIXED with proper endif)
/^## Native compilation target$/,/^endif # Linux/ {
    /^ifeq (\$(UNAME),Linux)$/i\
ifeq ($(UNAME),Android)\
  CFLAGS_NATIVE           := $(CFLAGS)\
  CFLAGS_NATIVE           += -D__ANDROID__\
  LFLAGS_NATIVE           := $(LFLAGS)\
  LFLAGS_NATIVE           += -lpthread\
  LFLAGS_NATIVE           += -ldl\
  LFLAGS_NATIVE           += -lrt\
  LFLAGS_NATIVE           += -lm\
  LFLAGS_NATIVE           += -liconv\
  LFLAGS_NATIVE           += -L$(PREFIX)/lib\
  $(info Android environment detected.)\
else

    /^endif # Linux$/a\
endif # Android
}

# 4. Fix the Linux section to be else if (but keep original since we're using else above)
# This line is now optional since we're using the "else" approach above
