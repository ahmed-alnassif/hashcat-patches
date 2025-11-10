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

# 3. ONLY replace the main Linux compilation section (around line 458)
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
    
    s/^ifeq (\$(UNAME),Linux)$/ifeq ($(UNAME),Linux)/
}
