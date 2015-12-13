//
//  PicProcessor.m
//  今日糯米团
//
//  Created by Sunny on 12/12/15.
//  Copyright © 2015 IOSDevelopeGuid. All rights reserved.
//

#import "PicProcessor.h"

@implementation PicProcessor

//需要在这里进行初始化
- (id)init {
    if (self = [super init]) {
        _queue = [[NSOperationQueue alloc] init];
        _cachedImage = [NSMutableDictionary dictionary];
    }
    return self;
}

//下载缓存图片处理
- (UIImage *)cachedImageForUrl:(NSURL *)url {
    id cachedObject = [self.cachedImage objectForKey:url];
    if (!cachedObject) {
        [self.cachedImage setObject:@"Loading..." forKey:url]; //添加占位符
        ASIHTTPRequest *picRequest = [ASIHTTPRequest requestWithURL:url];
        picRequest.delegate = self;
        picRequest.didFinishSelector = @selector(didFinishRequestImage:);
        picRequest.didFailSelector = @selector(didFailRequestImage:);
        //加入多线程进行处理
        [_queue addOperation:picRequest];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    } else if (![cachedObject isKindOfClass:[UIImage class]]) {
        cachedObject = nil;
    }
    return cachedObject;
}

//下载图片成功
- (void)didFinishRequestImage:(ASIHTTPRequest *)request {
    NSData *imageData = [request responseData];
    UIImage *image = [UIImage imageWithData:imageData];
    if (image) {
        [_cachedImage setObject:image forKey:request.url];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"gridReload" object:nil];
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

//下载图片失败
- (void)didFailRequestImage:(ASIHTTPRequest *)request {
    //从当前缓存中移除
    [_cachedImage removeObjectForKey:request.url];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

@end
