//
//  XGRouteDetailsCell.m
//  地图的相关操作
//
//  Created by 小果 on 2016/11/23.
//  Copyright © 2016年 小果. All rights reserved.
//

#import "XGRouteDetailsCell.h"

@implementation XGRouteDetailsCell

+(instancetype)routeDetailsCellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"cell";
    XGRouteDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil){
        cell = [[XGRouteDetailsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    return cell;
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self setupCellWithSubViews];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

#pragma mark - 设置cell中的控件
-(void)setupCellWithSubViews{
    UILabel *upLab = [[UILabel alloc] init];
    upLab.backgroundColor = [UIColor greenColor];
    [self.contentView addSubview:upLab];
    self.upLab = upLab;
    
    UILabel *distanceLab = [[UILabel alloc] init];
    distanceLab.backgroundColor = [UIColor magentaColor];
    distanceLab.textColor = [UIColor blueColor];
    distanceLab.font = [UIFont boldSystemFontOfSize:15];
    distanceLab.layer.cornerRadius = 25;
    distanceLab.layer.masksToBounds = YES;
    distanceLab.textAlignment = NSTextAlignmentCenter;
    distanceLab.numberOfLines = 0;
    [self.contentView addSubview:distanceLab];
    _distanceLab = distanceLab;
    
    UILabel *downLab = [[UILabel alloc] init];
    downLab.backgroundColor = [UIColor greenColor];
    [self.contentView addSubview:downLab];
    _downLab = downLab;
    
    UILabel *detailLab = [[UILabel alloc] init];
    detailLab.numberOfLines = 0;
    detailLab.font = [UIFont boldSystemFontOfSize:20];
    [self.contentView addSubview:detailLab];
    _detailLab = detailLab;
    
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat distanceX = 5;
    CGFloat distanceW = 50;
    CGFloat distanceH = 50;
    CGFloat distanceY = 35;
    _distanceLab.frame = CGRectMake(distanceX, distanceY, distanceW, distanceH);
    
    CGFloat upLabX = distanceW * 0.5 + 5;
    CGFloat upLabY = 0;
    CGFloat upLabW = 2;
    CGFloat upLabH = CGRectGetMinY(_distanceLab.frame);
    _upLab.frame = CGRectMake(upLabX, upLabY, upLabW, upLabH);
    
    CGFloat downLabX = upLabX;
    CGFloat downLabY = CGRectGetMaxY(_distanceLab.frame);
    CGFloat downLabW = upLabW;
    CGFloat downLabH = self.frame.size.height - CGRectGetMaxY(_distanceLab.frame);
    _downLab.frame = CGRectMake(downLabX, downLabY, downLabW, downLabH);
    
    CGFloat detailX = CGRectGetMaxX(_distanceLab.frame) +20;
    CGFloat detailH = 50;
    CGFloat detailY = (self.frame.size.height - detailH) * 0.5;
    CGFloat detailW = self.frame.size.width - detailX - 20;
    _detailLab.frame = CGRectMake(detailX, detailY, detailW, detailH);
    
}


@end
