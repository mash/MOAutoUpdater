#import <Foundation/Foundation.h>

NSString *_MOLog(NSString *format, ...);
void MOLog(NSString *msg);

// '#define LOG_DISABLED 1' before '#import "Log.h"' in .m file to disable logging only in that file
#ifndef MOLOG_DISABLED
# define MOLOG_DISABLED 0
#endif

#if (DEBUG && ! MOLOG_DISABLED)
# define MOLOG_CURRENT_METHOD NSLog(@"%s#%d", __PRETTY_FUNCTION__, __LINE__)
# define MOLOG(...)           NSLog(@"%s#%d %@", __PRETTY_FUNCTION__, __LINE__, _MOLog(__VA_ARGS__))
#
#else
#  define MOLOG_CURRENT_METHOD
#  define MOLOG(...)
#
#endif
