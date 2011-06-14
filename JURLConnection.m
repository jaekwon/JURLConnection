//
//  JURLConnection.m
//  iDoneThis
//
//  Created by Jae Kwon on 6/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JURLConnection.h"


@implementation JURLConnection

@synthesize conn, data, response, error, text;

- (id)init {
    if ((self = [super init])) {
        conn = nil;
        response = nil;
        data = nil;
        error = nil;
        callback = nil;
        text = nil;
    }
    return self;
}

- (void)dealloc {
    [conn release];
    [response release];
    [data release];
    [error release];
    [callback release];
    [text release];
    [super dealloc];
}

+ (JURLConnection *)requestUrl:(id)url params:(NSDictionary *)params options:(NSDictionary *)options callback:(void(^)(JURLConnection *))callback {
    JURLConnection *jurl = [[JURLConnection alloc] init];
    jurl.callback = callback;
    
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

- (NSString *)text {
    if (!text) {
        NSString *encodingName = [self.response textEncodingName];
        NSStringEncoding encoding;
        if (encodingName) {
            CFStringEncoding cfenc = CFStringConvertIANACharSetNameToEncoding((CFStringRef)encodingName);
            encoding = CFStringConvertEncodingToNSStringEncoding(cfenc);
        } else {
            encoding = NSISOLatin1StringEncoding;
        }
        text = [[NSString alloc] initWithData:self.data encoding:encoding];
    }
    return [[text retain] autorelease];
}

// overcoming typechecking issues
- (void(^)(JURLConnection*))callback {
    return (void(^)(JURLConnection*))callback;
}
- (void)setCallback:(void(^)(JURLConnection *))cb {
    callback = cb;
}

# pragma mark URLConnection delegate methods

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)newData {
    if (!self.data) {
        self.data = [NSMutableData dataWithCapacity:[newData length]];
    }
    [self.data appendData:newData];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)_response {
    self.response = _response;
    if ([self.response expectedContentLength] != -1) {
        self.data = [NSMutableData dataWithCapacity:[self.response expectedContentLength]];
    } // else, didReceiveData will create the data for us.
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // i guess we succeeded then.
    self.callback(self);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)_error {
    self.error = _error;
    self.callback(self);
}

@end
