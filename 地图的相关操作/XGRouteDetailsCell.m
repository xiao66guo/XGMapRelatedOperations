//
//  XGRouteDetailsCell.m
//  地图的相关操作
//
//  Created by 小果 on 2016/11/23.
//  Copyright © 2016年 小果. All rights reserved.
//

#import "XGRouteDetailsCell.h"
@interface XGRouteDetailsCell()

@end
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
        
    }
    return self;
}

#pragma mark - 设置cell中的控件
-(void)setupCellWithSubViews{
    
}



@end
