//
//  XGAnnotationView.m
//  地图的相关操作
//
//  Created by 小果 on 2016/11/20.
//  Copyright © 2016年 小果. All rights reserved.
//

#import "XGAnnotationView.h"

@implementation XGAnnotationView

+(instancetype)xg_annotationWithMapView:(MKMapView *)mapView{
    // 实现重用
    static NSString *ID = @"annotation";
    XGAnnotationView *anV = (XGAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:ID];
    if (nil == anV) {
        anV = [[XGAnnotationView alloc] initWithAnnotation:nil reuseIdentifier:ID];
        anV.image = [UIImage imageNamed:@"pic"];
        // 设置标注
        anV.canShowCallout = YES;
        anV.leftCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeInfoLight];
        anV.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeInfoDark];
    }
    return anV;
}

-(void)setAnnotation:(id<MKAnnotation>)annotation{
    [super setAnnotation:annotation];
}

@end
