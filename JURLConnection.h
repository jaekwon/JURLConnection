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
#ifndef WITH_GCQ
  #define WITH_GCQ dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{ // GCQ is the global concurrent queue
  #define END_WITH });
#endif

@interface JURLConnection : NSObject {
    NSURLConnection *conn;
    NSMutableData *data;
    NSURLResponse *response;
    NSError *error;
    id callback;
    
    // if the response is text type...
    NSString *text;
}

@property(nonatomic, retain)NSURLConnection *conn;
@property(nonatomic, retain)NSMutableData *data;
@property(nonatomic, retain)NSURLResponse *response;
@property(nonatomic, retain)NSError *error;
@property(nonatomic, copy)void (^callback)(JURLConnection *jconn);
@property(nonatomic, retain)NSString *text;

// options isn't supported yet
// places a job asynchronously on the global concurrent queue.
+ (JURLConnection *)requestUrl:(id)url params:(NSDictionary *)params options:(NSDictionary *)options callback:(void(^)(JURLConnection *))callback;

// utility methods
+ (NSString *)urlStringWithUrl:(id)url params:(NSDictionary *)params;
+ (NSURL *)urlWithUrl:(id)url params:(NSDictionary *)params;

@end
