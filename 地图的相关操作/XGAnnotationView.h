//
//  XGAnnotationView.h
//  地图的相关操作
//
//  Created by 小果 on 2016/11/20.
//  Copyright © 2016年 小果. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface XGAnnotationView : MKAnnotationView
+(instancetype)annotationWithMapView:(MKMapView *)mapView;
@end
