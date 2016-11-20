//
//  XGAnnotationView.m
//  地图的相关操作
//
//  Created by 小果 on 2016/11/20.
//  Copyright © 2016年 小果. All rights reserved.
//

#import "XGAnnotationView.h"

@implementation XGAnnotationView

+(instancetype)annotationWithMapView:(MKMapView *)mapView{ 
    // 实现重用
    static NSString *ID = @"annotation";
    XGAnnotationView *anV = (XGAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:ID];
    if (nil == anV) {
        // 大头针视图初始化时，如果没有设置大头针模型，系统会自动进行设置的
        anV = [[XGAnnotationView alloc] initWithAnnotation:nil reuseIdentifier:ID];
        // 设置大头针的颜色(必须使用子类MKPinAnnotationView)
        //        anV.pinTintColor = [UIColor greenColor];
        // 设置头像(MKPinAnnotationView不能设置自定义的图片和滑落的动画)
        anV.image = [UIImage imageNamed:@"pic"];
        // 设置标注
        anV.canShowCallout = YES;
        // 设置滑落的动画
        //        anV.animatesDrop = YES;
        // 设置其他的视图
        anV.leftCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeInfoLight];
        anV.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeInfoDark];
//        anV.detailCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeContactAdd];
    }
    return anV;
}

-(void)setAnnotation:(id<MKAnnotation>)annotation{
    [super setAnnotation:annotation];
}

@end
