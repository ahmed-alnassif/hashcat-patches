# Android affinity.c Patches - Pattern Based

# Add Android headers after event.h include
/#include "event.h"/a\
#if defined(__ANDROID__)\
#include <sched.h>\
#include <unistd.h>\
#endif

# Replace pthread_setaffinity_np with Android version
/pthread_t thread = pthread_self ();/,/const int rc = pthread_setaffinity_np/ {
    /const int rc = pthread_setaffinity_np (thread, sizeof (cpu_set_t), &cpuset);/c\
  #if defined(__ANDROID__)\
    const int rc = sched_setaffinity (gettid(), sizeof (cpu_set_t), &cpuset);\
  #else\
    const int rc = pthread_setaffinity_np (thread, sizeof (cpu_set_t), &cpuset);\
  #endif
}
