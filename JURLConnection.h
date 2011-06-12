//
//  JURLConnection.h
//  iDoneThis
//
//  Created by Jae Kwon on 6/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^onSuccessType)(NSData *data);
typedef void (^onFailureType)(NSError *error);

@interface JURLConnection : NSObject {
    NSURLConnection *conn;
    NSMutableData *data;
    onSuccessType onSuccess;
    onFailureType onFailure;
}

@property(nonatomic, retain)NSURLConnection *conn;
@property(nonatomic, retain)NSMutableData *data;
@property(nonatomic, copy)onSuccessType onSuccess;
@property(nonatomic, copy)onFailureType onFailure;

+ (JURLConnection *)requestUrl:(id)url params:(NSDictionary *)params options:(NSDictionary *)options success:(void(^)(NSData *))onSuccess failure:(void(^)(NSError *))onFailure;

+ (NSString *)urlStringWithUrl:(id)url params:(NSDictionary *)params;
+ (NSURL *)urlWithUrl:(id)url params:(NSDictionary *)params;

@end
