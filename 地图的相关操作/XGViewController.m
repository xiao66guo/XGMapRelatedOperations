//
//  XGViewController.m
//  地图的相关操作
//
//  Created by 小果 on 2016/11/19.
//  Copyright © 2016年 小果. All rights reserved.
//

#import "XGViewController.h"
#import <MapKit/MapKit.h>
#import "XGAnnotation.h"
#import "XGAnnotationView.h"
#import "iflyMSC/IFlyRecognizerViewDelegate.h"
#import "iflyMSC/IFlyRecognizerView.h"
#import "iflyMSC/IFlyMSC.h"
#import "ISRDataHelper.h"
@interface XGViewController ()<MKMapViewDelegate,IFlyRecognizerViewDelegate,UITextFieldDelegate>
@property (nonatomic, strong) NSString *result;
@end
@implementation XGViewController
{
    MKMapView                          *_map;
    CLLocationManager              *_manager;
    UISegmentedControl             *_segment;
    UITextField               *_addressField;
    UIButton                       *_backBtn;
    UIButton                     *_aerialBtn;
    UIButton                        *_navBtn;
    IFlyRecognizerView  *_iflyRecognizerView;
    NSMutableArray         *_polyLineMutable;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _polyLineMutable = [NSMutableArray array];
    // 添加地图
    [self addMapView];
    // 设置地图的模式
    [self addMapViewModel];
    // 设置返回按钮
    [self addBackBtn];
    // 设置航拍模式
    [self addAerialBtn];
    // 设置地图的缩放模式
    [self addMapScale];
    // 绘制线路图
    [self addDrawControl];
    
    //初始化语音识别控件
    _iflyRecognizerView = [[IFlyRecognizerView alloc] initWithCenter:self.view.center];
    _iflyRecognizerView.delegate = self;
    [_iflyRecognizerView setParameter: @"iat" forKey: [IFlySpeechConstant IFLY_DOMAIN]];
    [_iflyRecognizerView setParameter:@"asrview.pcm " forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
    // 添加语音按钮
    [self addVoiceBtn];
    
}
-(void)viewWillAppear:(BOOL)animated{
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@",@"58315ff7"];
    [IFlySpeechUtility createUtility:initString];
}

#pragma mark - 添加语音按钮
-(void)addVoiceBtn{
    UIButton *voiceBtn = [[UIButton alloc] init];
    voiceBtn.backgroundColor = [UIColor redColor];
    [voiceBtn setImage:[UIImage imageNamed:@"chat_bottom_voice_nor"] forState:UIControlStateNormal];
    [voiceBtn setImage:[UIImage imageNamed:@"chat_bottom_voice_press"] forState:UIControlStateHighlighted];
    voiceBtn.frame = CGRectMake(CGRectGetMaxX(_navBtn.frame)+5, _navBtn.frame.origin.y, 25, 25);
    [voiceBtn addTarget:self action:@selector(clickVoiceBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:voiceBtn];
}
#pragma mark - 语音响应
-(void)clickVoiceBtn{
    if (_addressField.text.length != 0) {
        _addressField.text = nil;
        [_map removeOverlays:_polyLineMutable];
        [_polyLineMutable removeAllObjects];
    }
    //启动识别服务
    [_iflyRecognizerView start];
}
/*识别结果返回代理
 @param resultArray 识别结果
 @ param isLast 表示是否最后一次结果
 */
- (void)onResult: (NSArray *)resultArray isLast:(BOOL) isLast
{
    [_iflyRecognizerView cancel]; //取消识别
    
    NSMutableString *resultString = [[NSMutableString alloc] init];
    NSDictionary *dic = resultArray[0];
    for (NSString *key in dic) {
        [resultString appendFormat:@"%@",key];
    }
    _result =[NSString stringWithFormat:@"%@%@", _addressField.text,resultString];
    
    NSString * resultFromJson =  [ISRDataHelper stringFromJson:resultString];
    _addressField.text = [NSString stringWithFormat:@"%@%@", _addressField.text,resultFromJson];
    
    if (isLast){
    }
}
/*识别会话错误返回代理
 @ param  error 错误码
 */
- (void)onError: (IFlySpeechError *) error{}
- (void) onVolumeChanged: (int)volume{}


#pragma mark - 添加绘制控件
-(void)addDrawControl{
    UILabel *lab = [[UILabel alloc] init];
    lab.font = [UIFont systemFontOfSize:15];
    lab.text = @"请输入地址:";
    lab.textColor = [UIColor redColor];
    lab.frame = CGRectMake(10, CGRectGetMaxY(_segment.frame)+5, 90, 25);
    [self.view addSubview:lab];
    
    UITextField *addressField = [[UITextField alloc] init];
    addressField.backgroundColor = [UIColor magentaColor];
    addressField.textAlignment = NSTextAlignmentLeft;
    addressField.borderStyle = UITextBorderStyleBezel;
    addressField.clearButtonMode = UITextFieldViewModeWhileEditing;
    addressField.returnKeyType = UIReturnKeyDone;
    addressField.delegate = self;
    addressField.frame = CGRectMake(CGRectGetMaxX(lab.frame), CGRectGetMaxY(_segment.frame)+2, 120, 30);
    [self.view addSubview:addressField];
    _addressField = addressField;
    
    UIButton *navBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(addressField.frame) + 10,lab.frame.origin.y, 50, 25)];
    navBtn.backgroundColor = [UIColor greenColor];
    [navBtn setTitle:@"导航" forState:UIControlStateNormal];
    [navBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:navBtn];
    [navBtn addTarget:self action:@selector(startNav) forControlEvents:UIControlEventTouchUpInside];
    _navBtn = navBtn;
}
#pragma mark - 结束编辑
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [_addressField endEditing:YES];
    return YES;
}

#pragma mark - 开始导航按钮
-(void)startNav{
    
    if (nil != _polyLineMutable) {
        [_map removeOverlays:_polyLineMutable];
        [_polyLineMutable removeAllObjects];
    }
    [_addressField resignFirstResponder];
    
    // 使用自定义地图进行导航  将起点和终点发送给服务器,由服务器返回导航结果
    // 1、创建导航请求对象
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    // 2、设置起点和终点
    request.source = [MKMapItem mapItemForCurrentLocation];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:_addressField.text completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        if (placemarks.count == 0 || error) {
            return ;
        }
        CLPlacemark *clPm = placemarks.lastObject;
        MKPlacemark *pm = [[MKPlacemark alloc] initWithPlacemark:clPm];
        request.destination = [[MKMapItem alloc] initWithPlacemark:pm];
        //3.创建导航对象
        MKDirections *direction = [[MKDirections alloc] initWithRequest:request];
        //4.计算导航路线 传递数据给服务器
        [direction calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse * _Nullable response, NSError * _Nullable error) {
            for (MKRoute *route in response.routes) {
                [_map addOverlay:route.polyline];
                
                [_polyLineMutable addObject:route.polyline];
                
            }
            
        }];
        
    }];
    
}
#pragma mark - MKMapViewDelegate
-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay{
    MKPolylineRenderer *render = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    render.lineWidth = 3;
    render.strokeColor = [UIColor purpleColor];
    
    return render;
}


#pragma mark - 添加航拍按钮
-(void)addAerialBtn{
    UIButton *aerialBtn = [[UIButton alloc] initWithFrame:CGRectMake(_backBtn.frame.origin.x, _backBtn.frame.origin.y - 30, 50, 25)];
    aerialBtn.backgroundColor = [UIColor greenColor];
    [aerialBtn setTitle:@"航拍" forState:UIControlStateNormal];
    [aerialBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [aerialBtn addTarget:self action:@selector(addAerialModel) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:aerialBtn];
    _aerialBtn = aerialBtn;
}

#pragma mark - 设置地图的航拍模式
-(void)addAerialModel{
    // 设置航拍模式
    _map.camera = [MKMapCamera cameraLookingAtCenterCoordinate:CLLocationCoordinate2DMake(39.9, 116.4) fromDistance:100 pitch:90 heading:0];
    _map.userTrackingMode = MKUserTrackingModeFollow;
}

#pragma mark - 添加大头针
// 大头针视图是有系统来添加的，但是大头针的数据是需要由开发者通过大头针模型来设置的
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    XGAnnotation *annotation = [[XGAnnotation alloc] init];
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:_map];
    CLLocationCoordinate2D coor = [_map convertPoint:point toCoordinateFromView:_map];
    annotation.coordinate = coor;
    annotation.title = @"xiao66guo";
    annotation.subtitle = @"😋呵呵呵呵呵";
    [_map addAnnotation:annotation];
    [self.view endEditing:YES];
}

#pragma mark - 设置地图的放大和缩小
-(void)addMapScale{
    UIButton *zoomin = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 60, _aerialBtn.frame.origin.y, 50, 25)];
    zoomin.backgroundColor = [UIColor greenColor];
    [zoomin setTitle:@"放大" forState:UIControlStateNormal];
    [zoomin setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:zoomin];
    [zoomin addTarget:self action:@selector(clickZoom:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *zoomout = [[UIButton alloc] initWithFrame:CGRectMake(zoomin.frame.origin.x, zoomin.frame.origin.y + 30, 50, 25)];
    zoomout.backgroundColor = [UIColor greenColor];
    [zoomout setTitle:@"缩小" forState:UIControlStateNormal];
    [zoomout setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:zoomout];
    [zoomout addTarget:self action:@selector(clickZoom:) forControlEvents:UIControlEventTouchUpInside];
    
}
#pragma mark - 地图的缩放
-(void)clickZoom:(UIButton *)sender{
    CLLocationCoordinate2D coordinate = _map.region.center;
    MKCoordinateSpan spn;
    if ([sender.titleLabel.text isEqualToString:@"放大"]) {
        spn = MKCoordinateSpanMake(_map.region.span.latitudeDelta * 0.5, _map.region.span.longitudeDelta * 0.5);
    }else{
        spn = MKCoordinateSpanMake(_map.region.span.latitudeDelta * 2, _map.region.span.longitudeDelta * 2);
    }
    [_map setRegion:MKCoordinateRegionMake(coordinate, spn) animated:YES];

}

#pragma mark - 设置返回按钮
-(void)addBackBtn{
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, self.view.bounds.size.height- 50, 50, 25)];
    backBtn.backgroundColor = [UIColor greenColor];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(clickBackBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    _backBtn = backBtn;
}
#pragma mark - 返回按钮的响应事件
-(void)clickBackBtn{
    CLLocationCoordinate2D coordinate = _map.userLocation.location.coordinate;
    // 设置跨度 = 当前地图的跨度
    MKCoordinateSpan spn = _map.region.span;
    [_map setRegion:MKCoordinateRegionMake(coordinate, spn) animated:YES];
}

#pragma mark - 添加地图的模式
-(void)addMapViewModel{
    NSArray *array = @[@"标准",@"卫星",@"混合",@"地图卫星立交桥",@"混合立交桥"];
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:array];
    segment.frame = CGRectMake(10, 100, 300, 20);
    segment.selectedSegmentIndex = 0;
    [segment addTarget:self action:@selector(clickMapViewModel:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segment];
    _segment = segment;
}
#pragma mark - 地图模式响应事件
-(void)clickMapViewModel:(UISegmentedControl *)sender{
    switch (sender.selectedSegmentIndex) {
        case MKMapTypeStandard:
            _map.mapType = MKMapTypeStandard;
            break;
        case MKMapTypeSatellite:
            _map.mapType = MKMapTypeSatellite;
            break;
        case MKMapTypeHybrid:
            _map.mapType = MKMapTypeHybrid;
            break;
        case MKMapTypeSatelliteFlyover:
            _map.mapType = MKMapTypeSatelliteFlyover;
            break;
        case MKMapTypeHybridFlyover:
            _map.mapType = MKMapTypeHybridFlyover;
            break;
        default:
            break;
    }
}

#pragma mark - 添加地图
-(void)addMapView{
    MKMapView *map = [[MKMapView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64)];
    [self.view addSubview:map];
    _map = map;
    

    // 在地图上显示定位
    // 1、请求授权(在Info.plist中添加NSLocationWhenInUseUsageDescription）
    _manager = [[CLLocationManager alloc] init];
    [_manager requestWhenInUseAuthorization];
    
    // 2.设置地图的用户跟踪模式
    map.userTrackingMode = MKUserTrackingModeFollow;
    map.delegate = self;
    
    // 其他的新属性
    // 显示指南针
    _map.showsCompass = YES;
    // 显示感兴趣的点，默认是显示的
    _map.showsPointsOfInterest = YES;
    // 显示标尺(单位：mi 英尺)
    _map.showsScale = YES;
    // 显示交通情况
    _map.showsTraffic = YES;
    // 显示定位大头针，默认是显示的
    _map.showsUserLocation = YES;
    // 显示建筑物的3D模型，设置3D/沙盘/航拍模式(高德地图不支持)
    _map.showsBuildings = YES;
    
}
#pragma mark - MKMapViewDelegate
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count == 0 || error) {
            return ;
        }
        CLPlacemark *pm = placemarks.lastObject;
        _map.userLocation.title = [NSString stringWithFormat:@"%@-%@-%@",pm.administrativeArea,pm.locality,pm.subLocality];
        _map.userLocation.subtitle = pm.name;

    }];
}
#pragma mark - 大头针的重用
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    // 排除已经定位的大头针
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    XGAnnotationView *anV = [XGAnnotationView xg_annotationWithMapView:_map];
    
    return anV;
}
#pragma mark - 当已经添加大头针视图后调用(还没有显示在地图上)该方法可以用来设置自定义动画
-(void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray<MKAnnotationView *> *)views{
    for (MKAnnotationView *anv in views) {
        // 排除定位的大头针
        if ([anv.annotation isKindOfClass:[MKUserLocation class]]) {
            return;
        }
        CGRect targetRect = anv.frame;
        // 修改位置
        anv.frame = CGRectMake(targetRect.origin.x, 0, targetRect.size.width, targetRect.size.height);
        [UIView animateWithDuration:0.3 animations:^{
            anv.frame = targetRect;
        }];
    }
}

@end
