//
//  Utils.m
//  iDoneThis
//
//  Created by Jae Kwon on 6/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSDictionary+Utils.h"


@implementation NSDictionary (Utils)

+ (id)dictionaryWithKeysAndObjectsMaybeNil:(id)arg1, ... {
    va_list args;
    id object;
    va_start(args, arg1);
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    int counter = 1;
    id key = arg1;
    while((object = va_arg(args, id)) || (counter%2==1)) {
        // knock myself out
        if (object == nil)
            object = [NSNull null];
        if (counter % 2 == 0)
            key = object;
        else
            [dict setObject:object forKey:key];
        counter++;
        // knock's on you.
    }
    va_end(args);
    return dict;
}

- (id)objectMaybeNilForKey:(id)key {
    id value = [self objectForKey:key];
    if (value == [NSNull null]) return nil;
    return value;
}

@end
