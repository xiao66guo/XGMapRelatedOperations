//
//  XGRouteDetailsCell.h
//  地图的相关操作
//
//  Created by 小果 on 2016/11/23.
//  Copyright © 2016年 小果. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XGRouteDetailsCell : UITableViewCell

@property (nonatomic, weak) UILabel *distanceLab;
@property (nonatomic, weak) UILabel *upLab;
@property (nonatomic, weak) UILabel *downLab;
@property (nonatomic, weak) UILabel *detailLab;

+(instancetype)routeDetailsCellWithTableView:(UITableView *)tableView;
@end
