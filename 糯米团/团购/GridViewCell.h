//
//  GridViewCell.h
//  团购
//
//  Created by Sunny on 12/9/15.
//  Copyright © 2015 IOSDevelopeGuid. All rights reserved.
//

#import "AQGridViewCell.h"

@interface GridViewCell : AQGridViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *captionLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIButton *imageButton;

@end
