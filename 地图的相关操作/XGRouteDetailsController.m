//
//  XGRouteDetailsController.m
//  地图的相关操作
//
//  Created by 小果 on 2016/11/23.
//  Copyright © 2016年 小果. All rights reserved.
//

#import "XGRouteDetailsController.h"
#import "XGRouteDetailsCell.h"
@interface XGRouteDetailsController ()<UITableViewDataSource>

@end

@implementation XGRouteDetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor magentaColor];

    UITableView *table = [[UITableView alloc] initWithFrame:self.view.bounds];
    table.rowHeight = 120;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.dataSource = self;
    [self.view addSubview:table];
}
#pragma mark - tableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _details.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XGRouteDetailsCell *cell = [XGRouteDetailsCell routeDetailsCellWithTableView:tableView];
    NSDictionary *dict = _details[indexPath.row];
    CGFloat dis = [dict[@"distance"] doubleValue];
    cell.distanceLab.text = [NSString stringWithFormat:@"%.1lf\nKM",dis/1000];
    cell.detailLab.text = dict[@"details"];
    return cell;
}
@end
