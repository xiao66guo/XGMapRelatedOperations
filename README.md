# XGMapRelatedOperations
高德地图显示模式,放大,缩小,集成讯飞语音输入并绘制路线


项目的功能：

1️⃣对用户的位置进行跟踪定位；

2️⃣实现了高德地图的几种展示 ；

3️⃣通过地图中的经纬度和比例的系数来实现对地图的放大和缩小；

4️⃣实现对地图中的大头针的自定义；

5️⃣以动画的方式来返回到用户原来定位的位置；

6️⃣点击“航拍”按钮可以使地图进入航拍的模式；

7️⃣集成“讯飞语音”的中的语音听写功能来实现用户的输入（也可支持手动输入哦）；

8️⃣通过点击“导航”按钮来实现用户的定位和输入的位置之间的路线绘制功能；
     当再次点击“导航”或者“语音输入”按钮时会对以前的路线进行清除；
     
  2016/11/23
  
9️⃣增加路线详情查看及距离展示页面

  2016/12/5
  
🔟修复点击地图缩小按钮时出现的bug；
 
  
实现导航路线绘制代码：
```
-(void)startNav{
    if (nil != _polyLineMutable) {
        [_map removeOverlays:_polyLineMutable];
        [_polyLineMutable removeAllObjects];
    }
    [_addressField resignFirstResponder];
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    request.source = [MKMapItem mapItemForCurrentLocation];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:_addressField.text completionHandler:^(NSArray<clplacemark *=""> * _Nullable placemarks, NSError * _Nullable error) {
         
        if (placemarks.count == 0 || error) {
            return ;
        }
        CLPlacemark *clPm = placemarks.lastObject;
        MKPlacemark *pm = [[MKPlacemark alloc] initWithPlacemark:clPm];
        request.destination = [[MKMapItem alloc] initWithPlacemark:pm];
        MKDirections *direction = [[MKDirections alloc] initWithRequest:request];
        [direction calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse * _Nullable response, NSError * _Nullable error) {
            for (MKRoute *route in response.routes) {
                for (MKRouteStep *step in route.steps) {
                    NSLog(@"%@", step.instructions);
                }
                [_map addOverlay:route.polyline];
                [_polyLineMutable addObject:route.polyline];
            }
        }];
    }];
    }
```
