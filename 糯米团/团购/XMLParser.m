//
//  XMLParser.m
//  今日糯米团
//
//  Created by Sunny on 12/12/15.
//  Copyright © 2015 IOSDevelopeGuid. All rights reserved.
//

#import "XMLParser.h"

@interface XMLParser () {
    TBXML *tbxml;
}

@end

@implementation XMLParser

- (id)init {
    if (self = [super init]) {
        _urlChildOfRootElement = @"url";
        _dataChildOfUrlElement = @"data";
        _displayChildOfDataElement = @"display";
        
        _tb_siteUrl = @"wapGoodsURL";
        _tb_title = @"title";
        _tb_image = @"image";
        _tb_price = @"price";
        
        _tb_shops = @"shops";
        _tb_shop = @"shop";
        _tb_shopName = @"name";
        _tb_address = @"addr";
        _tb_longitude = @"longitude";
        _tb_latitude = @"latitude";
    }
    return self;
}

- (NSMutableArray *)xmlParser:(NSData *)data {
    
    NSError *err;
    _arrays = [NSMutableArray array];
    //载入XML
    if (data) {
        tbxml = [[TBXML alloc] initWithXMLData:data error:&err];
    } else {
        tbxml = [[TBXML alloc] initWithXMLFile:@"dailydeal.xml" error:&err];
    }
    
    //读取根点播洋葱
    TBXMLElement *root = tbxml.rootXMLElement;
    if (root) {
        TBXMLElement *url = [TBXML childElementNamed:_urlChildOfRootElement parentElement:root error:&err];
        while (url != nil) {
            TBXMLElement *data = [TBXML childElementNamed:_dataChildOfUrlElement parentElement:url error:&err];
            if (data) {
                TBXMLElement *display = [TBXML childElementNamed:_displayChildOfDataElement parentElement:data error:&err];
                if (display) {
                    NSMutableDictionary *dict = [NSMutableDictionary new];
                    TBXMLElement *siteurl = [TBXML childElementNamed:_tb_siteUrl parentElement:display];
                    if (siteurl) {
                        NSString *siteurlString = [TBXML textForElement:siteurl];
                        [dict setValue:siteurlString forKey:_tb_siteUrl];
                    }
                    TBXMLElement *title = [TBXML childElementNamed:_tb_title parentElement:display];
                    if (title) {
                        NSString *titleString = [TBXML textForElement:title];
                        [dict setValue:titleString forKey:_tb_title];
                    }
                    TBXMLElement *image = [TBXML childElementNamed:_tb_image parentElement:display];
                    if (image) {
                        //此时得到的URL并不能直接解析成图片，需要截取
                        NSString *imageUrl = [TBXML textForElement:image];
                        NSString *tempStr = @"http://e.hiphotos.baidu.com/";
                        NSRange range = [imageUrl rangeOfString:tempStr];
                        NSUInteger location = range.location;
                        //warning 这段代码太冗余了
                        if (location > 1000) {
                            tempStr = @"http://S1.nuomi.bdimg.com/";
                            range = [imageUrl rangeOfString:tempStr];
                            location = range.location;
                            if (location > 1000) {
                                tempStr = @"http://S2.nuomi.bdimg.com/";
                                range = [imageUrl rangeOfString:tempStr];
                                location = range.location;
                                if (location > 1000) {
                                    tempStr = @"http://S0.nuomi.bdimg.com/";
                                    range = [imageUrl rangeOfString:tempStr];
                                    location = range.location;
                                }
                            }
                        }
                        imageUrl = [imageUrl substringFromIndex:location];
                        [dict setValue:imageUrl forKey:_tb_image];
                    }
                    TBXMLElement *price = [TBXML childElementNamed:_tb_price parentElement:display];
                    if (price) {
                        NSString *priceString = @"¥";
                        priceString = [priceString stringByAppendingString:[TBXML textForElement:price]];
                        [dict setValue:priceString forKey:_tb_price];
                    }
                    //店铺字典
                    NSMutableDictionary *dictOfShops = [NSMutableDictionary new];
                    TBXMLElement *shops = [TBXML childElementNamed:_tb_shops parentElement:display];
                    if (shops) {
                        TBXMLElement *shop = [TBXML childElementNamed:_tb_shop parentElement:shops];
                        if (shop) {
                            TBXMLElement *shopName = [TBXML childElementNamed:_tb_shopName parentElement:shop];
                            if (shopName) {
                                NSString *shopNameStr = [TBXML textForElement:shopName];
                                [dictOfShops setValue:shopNameStr forKey:_tb_shopName];
                            }
                            TBXMLElement *shopAddress = [TBXML childElementNamed:_tb_address parentElement:shop];
                            if (shopAddress) {
                                NSString *addressStr = [TBXML textForElement:shopAddress];
                                [dictOfShops setValue:addressStr forKey:_tb_address];
                            }
                            TBXMLElement *shopLongitude = [TBXML childElementNamed:_tb_longitude parentElement:shop];
                            if (shopLongitude) {
                                NSString *longitudeStr = [TBXML textForElement:shopLongitude];
                                [dictOfShops setValue:longitudeStr forKey:_tb_longitude];
                            }
                            TBXMLElement *shopLatitude = [TBXML childElementNamed:_tb_latitude parentElement:shop];
                            if (shopLatitude) {
                                NSString *latitudeStr = [TBXML textForElement:shopLatitude];
                                [dictOfShops setValue:latitudeStr forKey:_tb_latitude];
                            }
                        }
                    }
                    
                    [dict setValue:dictOfShops forKey:_tb_shop];
                    
                    //数据添加到数组
                    [_arrays addObject:dict];
                    //移动到下一个节点开始解析
                    url = [TBXML nextSiblingNamed:_urlChildOfRootElement searchFromElement:url];
                }
            }
        }
    }
    
    return _arrays;
}

@end
