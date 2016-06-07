//
//  MDHTTPComunication.h
//  Converter2GIS
//
//  Created by Dmitry on 01.06.16.
//  Copyright © 2016 MakarovDmitry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDHTTPComunication : NSObject <NSURLSessionDownloadDelegate>

- (void)retrieveURL:(NSURL *)url
       successBlock:(void(^)(NSData *))successBlock;

@end
