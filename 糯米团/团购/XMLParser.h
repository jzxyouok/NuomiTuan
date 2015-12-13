//
//  XMLParser.h
//  今日糯米团
//
//  Created by Sunny on 12/12/15.
//  Copyright © 2015 IOSDevelopeGuid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBXML.h"

@interface XMLParser : NSObject

@property (nonatomic, strong) NSMutableArray *arrays;

@property (nonatomic, readonly) NSString *urlChildOfRootElement;
@property (nonatomic, readonly) NSString *dataChildOfUrlElement;
@property (nonatomic, readonly) NSString *displayChildOfDataElement;

@property (nonatomic, readonly) NSString *tb_siteUrl;
@property (nonatomic, readonly) NSString *tb_title;
@property (nonatomic, readonly) NSString *tb_image;
@property (nonatomic, readonly) NSString *tb_price;

@property (nonatomic, readonly) NSString *tb_shops;
@property (nonatomic, readonly) NSString *tb_shop;
@property (nonatomic, readonly) NSString *tb_shopName;
@property (nonatomic, readonly) NSString *tb_address;
@property (nonatomic, readonly) NSString *tb_longitude;
@property (nonatomic, readonly) NSString *tb_latitude;

- (NSMutableArray *)xmlParser:(NSData *)data;

@end
