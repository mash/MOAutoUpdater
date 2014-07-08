#import "MOLog.h"

NSString *_MOLog(NSString *format, ...){
    va_list args;
    va_start(args, format);
    NSString *str = [[NSString alloc] initWithFormat: format arguments: args];
    va_end(args);
    return str;
}

void MOLog(NSString *msg) {
    NSLog(@"[IRLauncher]%@", msg);
}
