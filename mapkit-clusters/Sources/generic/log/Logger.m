
// BSD License. <jano@jano.com.es>

#import "Logger.h"

@implementation Logger

@synthesize logThreshold, async;


+(Logger *)singleton {
    static dispatch_once_t pred;
    static Logger *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[Logger alloc] init];
        shared.logThreshold = LOGGER_LEVEL;
        shared.async = FALSE;
    });
    return shared;
}


-(void) debugWithLevel:(LoggerLevel)level
                  line:(int)line
              funcName:(const char *)funcName
               message:(NSString *)msg, ... {
    
    const char* const levelName[6] = { "TRACE", "DEBUG", " INFO", " WARN", "ERROR", "SILENT" };
    
    va_list ap;         // define variable ap of type va
    va_start (ap, msg); // initializes ap
	msg = [[NSString alloc] initWithFormat:msg arguments:ap];
    va_end (ap);        // invalidates ap
    
    BOOL skipClassInfo = FALSE; // should we add class info?
    {
        // Process format characters at the beginning of the string:
        //   - The ` character means skip class/method/line info.
        //   - The > character means use white bg + black fg.
        NSCharacterSet *format = [NSCharacterSet characterSetWithCharactersInString:@"`>"];
        int i = 0;
        for (; i<[msg length]; i++) {
            unichar character = [msg characterAtIndex:i];
            if (![format characterIsMember:character]) break;
            switch (character) {
                case '`':
                    skipClassInfo = TRUE;
                    break;
                default:
                    break;
            }
        }
        if (i>0) msg = [msg substringFromIndex:i];
    }
    
    // remove annoying user's \n at beginning and end
    msg = [msg stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\n"]];
    
    if (level>=logThreshold){
        
        // if we didn't start the message with ` then add class/method/line
        if (!skipClassInfo){
            msg = [NSString stringWithFormat:@"%s %50s:%3d - %@", levelName[level], funcName, line, msg];
        }
        
        if ([self isAsync]){
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    fprintf(stdout,"%s\n", [msg UTF8String]);
                });
            });
        } else {
            fprintf(stdout,"%s\n", [msg UTF8String]);
        }
        
    }
}


@end


