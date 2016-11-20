
#import "NSDictionary+Log.h"

@implementation NSDictionary (Log)


-(NSString *)descriptionWithLocale:(id)locale
{
    NSMutableString *strM = [[NSMutableString alloc] init];
    
    [strM appendString:@"{"];
    
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        //
        [strM appendFormat:@"\n\t%@ = %@\n",key,obj];
        
    }];
    
    [strM appendString:@"}"];
    
    return strM;
}

@end



@implementation NSArray (Log)

-(NSString *)descriptionWithLocale:(id)locale
{
    NSMutableString *strM = [[NSMutableString alloc] init];
    
    [strM appendString:@"\n{"];
    
  
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        [strM appendFormat:@"\n\t %@\n",obj];
        
    }];
    
    [strM appendString:@"}\n"];

    
    return strM;
}

@end
