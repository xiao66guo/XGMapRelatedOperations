//
//  XGAnnotation.h
//  地图的相关操作
//
//  Created by 小果 on 2016/11/19.
//  Copyright © 2016年 小果. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface XGAnnotation : NSObject<MKAnnotation>
// 自动声明&实现coordinate的get方法，并且生成_coordinate这个成员变量
// 经度
@property (nonatomic) CLLocationCoordinate2D coordinate;
// 标题
@property (nonatomic, copy, nullable) NSString *title;
// 子标题
@property (nonatomic, copy, nullable) NSString *subtitle;

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;

@end
