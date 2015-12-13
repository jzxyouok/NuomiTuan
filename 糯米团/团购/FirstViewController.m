//
//  FirstViewController.m
//  团购
//
//  Created by Sunny on 12/8/15.
//  Copyright © 2015 IOSDevelopeGuid. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController () {
    MBProgressHUD *hud;
    NSMutableArray *arrays;
    NSString *urlString;
}
//查看商品详情的网址
@property (nonatomic, strong) NSString *goURL;
@property (nonatomic, strong) NSString *shopName;
@property (nonatomic, strong) NSString *shopAddress;
@property (nonatomic, strong) NSString *shopLongitude;
@property (nonatomic, strong) NSString *shopLatitude;

@property (nonatomic, strong) PopTableViewController *tableViewController;
@property (nonatomic, strong) TSPopoverController *popoverController;

@property (nonatomic, strong) XMLParser *tbXMLParser;
@property (nonatomic, strong) PicProcessor *picProcessor;

- (IBAction)showMap:(id)sender;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //导航栏
    self.navigationItem.title = @"糯米团";
    //城市选择按钮初始化
    UIBarButtonItem * topRightButton = [[UIBarButtonItem alloc] initWithTitle:@"南京" style:UIBarButtonItemStyleBordered target:self action:@selector(showPopover:forEvent:)];
    self.navigationItem.rightBarButtonItem = topRightButton;
    //设置背景图片
    UIImage *bgImage = [UIImage imageNamed:@"bkgd.jpg"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:bgImage];
    
    //初始化一定要有，NND编译器并不会给我报空指针异常！！！
    //初始化聚集地
    _tbXMLParser = [XMLParser new];
    _picProcessor = [PicProcessor new];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gridReload) name:@"gridReload" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popoverDismiss) name:@"PopoverDismiss" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeHUD) name:@"HUDRemove" object:nil];
    
    //HUD提示框
    [self showHUD];
    [self.navigationController.view addSubview:hud];
    
    //***************模拟网络读取****************
    @autoreleasepool {
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(xmlParser:) userInfo:nil repeats:NO];
        timer = nil;
    }
    //*****************************************
    
    //AQGridView
    self.gridView = [[AQGridView alloc] initWithFrame:CGRectMake(0, 0, 375, 647)]; //初始化用iPhone6的点阵
    self.gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.gridView.autoresizesSubviews = YES;
    self.gridView.dataSource = self;
    self.gridView.delegate = self;
    [self.view addSubview:_gridView];

}

//HUD提示框
- (void)showHUD {
    hud = [[MBProgressHUD alloc] init];
    hud.labelText = @"载入数据...";
    [hud show:YES];
}

//移除HUD专用
-(void)removeHUD {
    [hud removeFromSuperview];
}

//gridView刷新图片专用
- (void)gridReload {
    [_gridView reloadData];
}

//支持全部方向旋转
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

#pragma mark - Popover
//弹出第三方popover
-(void)showPopover:(id)sender forEvent:(UIEvent*)event {
    _tableViewController = [PopTableViewController new];
    _tableViewController.view.frame = CGRectMake(0,0, 150, 130);
    _popoverController = [[TSPopoverController alloc] initWithContentViewController:_tableViewController];
    
    _popoverController.cornerRadius = 5;
    _popoverController.titleText = @"选择城市";
    _popoverController.popoverBaseColor = [UIColor colorWithRed:135.0/255 green:138.0/255 blue:80.0/255 alpha:1.0];
    _popoverController.popoverGradient= NO;
    //    popoverController.arrowPosition = TSPopoverArrowPositionHorizontal;
    [_popoverController showPopoverWithTouch:event];
}

//popover消失以及功能的实现
//糯米api，取回南京市当天销售的商品
//API生成地址: http://www.nuomi.com/help/api#footer
- (void)popoverDismiss {
    [_popoverController dismissPopoverAnimatd:YES];
    if (self.navigationItem.rightBarButtonItem.title != _tableViewController.city) {
        //设置UIBarButton名称
        self.navigationItem.rightBarButtonItem.title = _tableViewController.city;
        //数据请求
        if ([_tableViewController.city isEqualToString:@"香港"]) {
            [self startHttpRequest:@"http://api.nuomi.com/api/dailydeal?version=v1&city=xianggang"];
        }
        if ([_tableViewController.city isEqualToString:@"澳门"]) {
            [self startHttpRequest:@"http://api.nuomi.com/api/dailydeal?version=v1&city=aomen"];
        }
        if ([_tableViewController.city isEqualToString:@"南京"]) {
            [self xmlParser:nil];
        }
    }
}

#pragma mark - web request processing
//执行URL请求
- (void)startHttpRequest:(NSString *)url {
    ASIHTTPRequest *httpRequest = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:url]];
    httpRequest.delegate = self;
    //这里我用异步，在请求的时候界面可以进行操作
    [httpRequest startAsynchronous];
}

//请求结束
- (void)requestFinished:(ASIHTTPRequest *)request {
    //移除提示框
    [hud removeFromSuperview];
    //解析请求到的数据
    [self xmlParser:[request responseData]];
    [_gridView reloadData];
}

//请求出错
- (void)requestFailed:(ASIHTTPRequest *)request {
    [hud removeFromSuperview];
    NSError *err = [request error];
    NSLog(@"http请求出错：%@", [err description]);
    //出现提示框
    UIAlertView *requestError = [[UIAlertView alloc] initWithTitle:@"错误！" message:@"网络请求出错！" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [requestError show];
}

#pragma mark - 解析XML调用
- (void)xmlParser:(NSData *)data {
    //嗯，这里是我的解决办法，当遇到调用带参数selector出错的解决方法，data乱了就置nil嘛～
    if (![data isKindOfClass:[NSData class]]) {
        data = nil;
    }
    arrays = [_tbXMLParser xmlParser:data];
    [hud removeFromSuperview];
    [_gridView reloadData];
}


#pragma mark - AQGridViewDataSource
- (NSUInteger)numberOfItemsInGridView:(AQGridView *)gridView {
    return arrays.count;
}

- (AQGridViewCell *)gridView:(AQGridView *)gridView cellForItemAtIndex:(NSUInteger)index {
    static NSString *identifier = @"PlainCell";
    GridViewCell *cell = (GridViewCell *)[gridView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[GridViewCell alloc] initWithFrame:CGRectMake(0, 0, 187.5, 175) reuseIdentifier:identifier];
    }
    //取得每一个字典
    NSDictionary *dict = [arrays objectAtIndex:index];
    //上标题图片
    [cell.captionLabel setText:[dict objectForKey:_tbXMLParser.tb_title]];
    [cell.imageView setImage:[self picProcess:[NSURL URLWithString:[dict objectForKey:_tbXMLParser.tb_image]]]];
    [cell.priceLabel setText:[dict objectForKey:_tbXMLParser.tb_price]];
    //按钮添加事件
    //这里设置tag标示是第几个button
    cell.imageButton.tag = index;
    [cell.imageButton addTarget:self action:@selector(showMap:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

//每个显示框大小，和cell大小一样
- (CGSize)portraitGridCellSizeForGridView:(AQGridView *)gridView {
    return CGSizeMake(187.5, 175);
}

#pragma mark - image processing
- (UIImage *)picProcess:(NSURL *)url {
    return [_picProcessor cachedImageForUrl:url];
}

#pragma mark - AQGridViewDelegate implements
//点击商品查看详情
- (void)gridView:(AQGridView *)gridView didSelectItemAtIndex:(NSUInteger)index {
    _goURL = [arrays[index] objectForKey:_tbXMLParser.tb_siteUrl];
    _shopName = [[arrays[index] objectForKey:_tbXMLParser.tb_shop] objectForKey:_tbXMLParser.tb_shopName];
    [self performSegueWithIdentifier:@"showDetail" sender:self];
    [_gridView deselectItemAtIndex:index animated:YES];
}

#pragma mark - Go map
//跳转MapViewController视图
- (IBAction)showMap:(id)sender {
    //little trap here, how do you know to deliver button id which on the cell?
    //If you know it, see http://stackoverflow.com/questions/16621030/how-to-know-the-indexpath-row-on-button-click-of-tableview-cell-in-a-uitableview else ignore it.
    UIButton *senderBtn = (UIButton *)sender;
    _shopName = [[arrays[senderBtn.tag] objectForKey:_tbXMLParser.tb_shop] objectForKey:_tbXMLParser.tb_shopName];
    _shopAddress = [[arrays[senderBtn.tag] objectForKey:_tbXMLParser.tb_shop] objectForKey:_tbXMLParser.tb_address];
    _shopLongitude = [[arrays[senderBtn.tag] objectForKey:_tbXMLParser.tb_shop] objectForKey:_tbXMLParser.tb_longitude];
    _shopLatitude = [[arrays[senderBtn.tag] objectForKey:_tbXMLParser.tb_shop] objectForKey:_tbXMLParser.tb_latitude];
    [self performSegueWithIdentifier:@"showMap" sender:self];
}

#pragma mark - segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showDetail"]) {
        WebViewController *wvc = (WebViewController *)[[segue destinationViewController] topViewController];
        wvc.stringURL = _goURL;
        wvc.shopName = _shopName;
    }
    if ([segue.identifier isEqualToString:@"showMap"]) {
        MapViewController *mvc = (MapViewController *)[[segue destinationViewController] topViewController];
        mvc.shopName = _shopName;
        mvc.shopAddress = _shopAddress;
        mvc.longtitudeStr = _shopLongitude;
        mvc.latitudeStr = _shopLatitude;
    }
}

@end
