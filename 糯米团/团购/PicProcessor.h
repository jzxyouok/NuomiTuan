//
//  PicProcessor.h
//  今日糯米团
//
//  Created by Sunny on 12/12/15.
//  Copyright © 2015 IOSDevelopeGuid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

@class FirstViewController;

@interface PicProcessor : NSObject

@property (nonatomic, strong) NSMutableDictionary *cachedImage;
@property (nonatomic, strong) NSOperationQueue *queue;

- (UIImage *)cachedImageForUrl:(NSURL *)url;

@end
