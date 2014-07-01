#import <Foundation/Foundation.h>

NSString *_AULog(NSString *format, ...);
void AULog(NSString *msg);

// '#define LOG_DISABLED 1' before '#import "Log.h"' in .m file to disable logging only in that file
#ifndef AULOG_DISABLED
# define AULOG_DISABLED 0
#endif

#if (DEBUG && ! AULOG_DISABLED)
# define AULOG_CURRENT_METHOD NSLog(@"%s#%d", __PRETTY_FUNCTION__, __LINE__)
# define AULOG(...)           NSLog(@"%s#%d %@", __PRETTY_FUNCTION__, __LINE__, _AULog(__VA_ARGS__))
#
#else
#  define AULOG_CURRENT_METHOD
#  define AULOG(...)
#
#endif
