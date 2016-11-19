//
//  XGViewController.m
//  地图的相关操作
//
//  Created by 小果 on 2016/11/19.
//  Copyright © 2016年 小果. All rights reserved.
//

#import "XGViewController.h"
#import <MapKit/MapKit.h>

@interface XGViewController ()<MKMapViewDelegate>
@property (nonatomic, weak) MKMapView *map;
@property (nonatomic, strong) CLLocationManager *manager;
@property (nonatomic, weak) UISegmentedControl *segment;
@property (nonatomic, weak) UIButton *backBtn;
@end

@implementation XGViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 添加地图
    [self addMapView];
    // 设置地图的模式
    [self addMapViewMode];
    // 设置返回按钮
    [self addBackBtn];
    // 设置地图的缩放模式
    [self addMapScale];
    
}
#pragma mark - 设置地图的放大和缩小
-(void)addMapScale{
    UIButton *zoomin = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 60, self.view.bounds.size.height- 70, 50, 25)];
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
    CLLocationCoordinate2D coordinate = self.map.region.center;
    MKCoordinateSpan spn;
    if ([sender.titleLabel.text isEqualToString:@"放大"]) {
        spn = MKCoordinateSpanMake(self.map.region.span.latitudeDelta * 0.5, self.map.region.span.longitudeDelta * 0.5);
    }else{
        spn = MKCoordinateSpanMake(self.map.region.span.latitudeDelta * 2, self.map.region.span.longitudeDelta * 2);
    }
    [self.map setRegion:MKCoordinateRegionMake(coordinate, spn) animated:YES];

}
-(void)clickZoomout{
    
    // 设置范围 - 进行缩放
    // 中心点 = 当前地图的中心点
//    CLLocationCoordinate2D coordinate = self.map.region.center;
//    // 跨度 = 当前地图的跨度 * 比例的系数
//    MKCoordinateSpan spn = MKCoordinateSpanMake(self.map.region.span.latitudeDelta * 0.5, self.map.region.span.longitudeDelta * 0.5);
//    //
//    CLLocationCoordinate2D coordinate = self.map.region.center;
//    MKCoordinateSpan spn = MKCoordinateSpanMake(self.map.region.span.latitudeDelta * 2, self.map.region.span.longitudeDelta * 2);
//    [self.map setRegion:MKCoordinateRegionMake(coordinate, spn) animated:YES];
}


#pragma mark - 设置返回按钮
-(void)addBackBtn{
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, self.view.bounds.size.height- 50, 50, 30)];
    backBtn.backgroundColor = [UIColor greenColor];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:backBtn];
    self.backBtn = backBtn;
    [backBtn addTarget:self action:@selector(clickBackBtn) forControlEvents:UIControlEventTouchUpInside];

}
#pragma mark - 返回按钮的响应事件
-(void)clickBackBtn{
    // 没有动画的返回方式
//    self.map.userTrackingMode = MKUserTrackingModeFollow;
    // 有动画的返回用户的跟踪方式1：
//    [self.map setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    // 通过地图范围返回用户的跟踪方式2：中心点 = 定位点
  /*  typedef struct {
        CLLocationCoordinate2D center;  // 中心点   表示地图的位置
        MKCoordinateSpan span;          // 经纬度的跨度  1° = 111KM   表示地图的尺寸
         } MKCoordinateRegion;*/  // 地图范围
    // 设置定位点
    CLLocationCoordinate2D coordinate = self.map.userLocation.location.coordinate;
    // 设置跨度 = 当前地图的跨度
    MKCoordinateSpan spn = self.map.region.span;
    [self.map setRegion:MKCoordinateRegionMake(coordinate, spn) animated:YES];
}


#pragma mark - 添加地图的模式
-(void)addMapViewMode{
    NSArray *array = @[@"标准",@"卫星",@"混合",@"地图卫星立交桥",@"混合立交桥"];
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:array];
    segment.frame = CGRectMake(10, 100, 300, 20);
    segment.selectedSegmentIndex = 0;
    [segment addTarget:self action:@selector(clickMapViewModel:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segment];
}
#pragma mark - 地图模式响应事件
-(void)clickMapViewModel:(UISegmentedControl *)sender{
    switch (sender.selectedSegmentIndex) {
        case MKMapTypeStandard:
            self.map.mapType = MKMapTypeStandard;
            break;
        case MKMapTypeSatellite:
            self.map.mapType = MKMapTypeSatellite;
            break;
        case MKMapTypeHybrid:
            self.map.mapType = MKMapTypeHybrid;
            break;
        case MKMapTypeSatelliteFlyover:
            self.map.mapType = MKMapTypeSatelliteFlyover;
            break;
        case MKMapTypeHybridFlyover:
            self.map.mapType = MKMapTypeHybridFlyover;
            break;
        default:
            break;
    }
}

#pragma mark - 添加地图
-(void)addMapView{
    MKMapView *map = [[MKMapView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64)];
    [self.view addSubview:map];
    self.map = map;
    
    
    // 在地图上显示定位
    // 1、请求授权(在Info.plist中添加NSLocationWhenInUseUsageDescription）
    self.manager = [[CLLocationManager alloc] init];
    [self.manager requestWhenInUseAuthorization];
    
    // 2.设置地图的用户跟踪模式
    map.userTrackingMode = MKUserTrackingModeFollow;
    // 3、设置代理 通过代理来监听地图已经更新用户位置后获取地理信息
    map.delegate = self;
    
    // 其他的新属性
    // 显示指南针
    self.map.showsCompass = YES;
    // 显示感兴趣的点，默认是显示的
    self.map.showsPointsOfInterest = NO;
    // 显示标尺(单位：mi 英尺)
    self.map.showsScale = YES;
    // 显示交通情况
    self.map.showsTraffic = YES;
    // 显示定位大头针，默认是显示的
    self.map.showsUserLocation = YES;
    // 显示建筑物的3D模型，设置3D/沙盘/航拍模式(高德地图不支持)
    self.map.showsBuildings = YES;
    // 设置航拍模式
    self.map.camera = [MKMapCamera cameraLookingAtCenterCoordinate:CLLocationCoordinate2DMake(39.9, 116.4) fromDistance:100 pitch:90 heading:0];
    
    
}
#pragma mark - MKMapViewDelegate
// userLocation：定位大头针模型
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
//    NSLog(@"%f",self.map.userLocation.location.coordinate.latitude);
    // 4、通过反地理编码来获取人文信息    地理信息——>人文信息
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count == 0 || error) {
            return ;
        }
        CLPlacemark *pm = placemarks.lastObject;
        // 5、设置数据  （获取定位大头针的模型)
        // 通过反地理编码来获取人文信息    地理信息——>人文信息
        
        self.map.userLocation.title = pm.locality;
        self.map.userLocation.subtitle = [NSString stringWithFormat:@"%@%@",pm.subLocality,pm.name];

    }];
}

@end
