//
//  MDHTTPComunication.m
//  Converter2GIS
//
//  Created by Dmitry on 01.06.16.
//  Copyright © 2016 MakarovDmitry. All rights reserved.
//

#import "MDHTTPComunication.h"

@interface MDHTTPComunication ()

@property(nonatomic, copy) void(^successBlock)(NSData *);

@end

@implementation MDHTTPComunication

- (void)retrieveURL:(NSURL *)url successBlock:(void(^)(NSData *))successBlock
{
    self.successBlock = successBlock;
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSURLSessionConfiguration *conf = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:conf
                                                          delegate:self
                                                     delegateQueue:nil];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request];
    
    [task resume];
}

- (void) URLSession:(NSURLSession *)session
       downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location
{
    NSData *data = [NSData dataWithContentsOfURL:location];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.successBlock(data);
    });
}

@end
