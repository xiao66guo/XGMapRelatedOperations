//
//  XGRouteDetailsController.m
//  地图的相关操作
//
//  Created by 小果 on 2016/11/23.
//  Copyright © 2016年 小果. All rights reserved.
//

#import "XGRouteDetailsController.h"

@interface XGRouteDetailsController ()<UITableViewDataSource>

@end

@implementation XGRouteDetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor magentaColor];

    UITableView *table = [[UITableView alloc] initWithFrame:self.view.bounds];
    table.dataSource = self;
    [self.view addSubview:table];
}
#pragma mark - tableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _details.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"routeDetails";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@",_details[indexPath.row]];
    
    return cell;
}
@end
