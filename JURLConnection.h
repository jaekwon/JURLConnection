//
//  JURLConnection.h
//  iDoneThis
//
//  Created by Jae Kwon on 6/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef STR
 #define STR(fmt, ...) [NSString stringWithFormat:(fmt), ## __VA_ARGS__]
#endif
#ifndef DICT
 #define DICT(key, ...) [NSDictionary dictionaryWithKeysAndObjectsMaybeNil: key, ## __VA_ARGS__, nil]
#endif
#ifndef ARR
 #define ARR(item, ...) [NSArray arrayWithObjects:(item), ## __VA_ARGS__, nil]
#endif

@interface JURLConnection : NSObject {
    NSURLConnection *conn;
    NSMutableData *data;
    NSURLResponse *response;
    NSError *error;
    void (^callback)(id jconn);
}

@property(nonatomic, retain)NSURLConnection *conn;
@property(nonatomic, retain)NSMutableData *data;
@property(nonatomic, retain)NSURLResponse *response;
@property(nonatomic, retain)NSError *error;
@property(nonatomic, copy)void (^callback)(id jconn);

// options isn't supported yet
+ (JURLConnection *)requestUrl:(id)url params:(NSDictionary *)params options:(NSDictionary *)options callback:(void(^)(id))callback;

// utility methods
+ (NSString *)urlStringWithUrl:(id)url params:(NSDictionary *)params;
+ (NSURL *)urlWithUrl:(id)url params:(NSDictionary *)params;

@end
