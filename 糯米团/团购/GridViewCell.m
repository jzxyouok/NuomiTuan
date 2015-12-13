//
//  GridViewCell.m
//  团购
//
//  Created by Sunny on 12/9/15.
//  Copyright © 2015 IOSDevelopeGuid. All rights reserved.
//

#import "GridViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation GridViewCell

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier];
    if (self) {
        //初始化cell
        UIView *mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 187.5, 175)];
        //背景无色
        [mainView setBackgroundColor:[UIColor clearColor]];
        //图片框架
        UIImageView *frameImageView = [[UIImageView alloc] initWithFrame:CGRectMake(23, 4, 142, 163)];
        [frameImageView setImage:[UIImage imageNamed:@"tab-mask.png"]];
        [mainView addSubview:frameImageView];
        //图片和标题属性
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(26, 42, 135, 84)];
        self.captionLabel = [[UILabel alloc] initWithFrame:CGRectMake(26, 4, 136, 36)];
        [_captionLabel setFont:[UIFont systemFontOfSize:12]];
        _captionLabel.numberOfLines = 2;
        [mainView addSubview:_imageView];
        [mainView addSubview:_captionLabel];
        //价格
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(28, 128, 70, 30)];
        _priceLabel.font = [UIFont boldSystemFontOfSize:16];
        _priceLabel.textColor = [UIColor orangeColor];
        [mainView addSubview:_priceLabel];
        //底部按钮
        _imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _imageButton.frame = CGRectMake(98, 131, 60, 22);
        [_imageButton setBackgroundImage:[UIImage imageNamed:@"goToMap.jpg"] forState:UIControlStateNormal];
        //如果想底层view和imageButton相接洽，或者类似于融合了视图，就设置为NO。这样设置YES底层视图和button执行的操作可以互不干扰，当然默认是YES的，kangkangz4 添加了看似多余的按钮真的给了我一个很好的启发 :)
        _imageButton.userInteractionEnabled = YES;
        [mainView addSubview:_imageButton];
        
        [self.contentView addSubview:mainView];
    }
    return self;
}

@end
