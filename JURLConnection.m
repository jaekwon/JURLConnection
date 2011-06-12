//
//  JURLConnection.m
//  iDoneThis
//
//  Created by Jae Kwon on 6/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JURLConnection.h"


@implementation JURLConnection

@synthesize conn, data, onSuccess, onFailure;

- (id)init {
    if ((self = [super init])) {
        conn = nil;
        data = [[NSMutableData alloc] init];
    }
    return self;
}

- (void)dealloc {
    [conn release];
    [data release];
    [super dealloc];
}

+ (JURLConnection *)requestUrl:(id)url params:(NSDictionary *)params options:(NSDictionary *)options success:(void(^)(NSData *))onSuccess failure:(void(^)(NSError *))onFailure {
    JURLConnection *jurl = [[JURLConnection alloc] init];
    jurl.onSuccess = onSuccess;
    jurl.onFailure = onFailure;
    
    // construct the request
    NSURLRequest *request = [NSURLRequest requestWithURL:[JURLConnection urlWithUrl:url params:params]];
    jurl.conn = [NSURLConnection connectionWithRequest:request delegate:jurl];
    [jurl.conn start];
    return url;
}

+ (NSString *)urlStringWithUrl:(id)url params:(NSDictionary *)params {
    if ([params count] > 0) return [url description];
    
    NSString *u = [url description];
    // get string from params
    NSMutableString *p = [NSMutableString string];
    if (params) {
        for (NSString *key in params) {
            [p appendString:[key urlencode]];
            [p appendString:@"="];
            [p appendString:[[params objectForKey:key] urlencode]];
        }
    }
     
    if ([u rangeOfString:@"?"].location != NSNotFound) {
        return STR(@"%@&%@", u, p);
    } else {
        return STR(@"%@?%@", u, p);
    }
}

+ (NSURL *)urlWithUrl:(id)url params:(NSDictionary *)params {
    return [NSURL URLWithString:[JURLConnection urlStringWithUrl:url params:params]];
}

# pragma mark URLConnection delegate methods

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    Warn(@"received data!");
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    Warn(@"received response!");
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    Warn(@"connection did finish loading!");
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    Warn(@"did fail with error!");
}

@end
