//
//  ViewController.h
//  RefreshDemo
//
//  Created by Jason on 16/4/16.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
/********************/
#import <MJRefresh/MJRefresh.h>
#import <AFNetworking/AFNetworking.h>
#import <GDataXML-HTML/GDataXMLNode.h>

#import "NewsModel.h"
#import "UrlHeader.h"
//
#define VIEW_ORIGIN  self.view.frame.origin
#define VIEW_SIZE    self.view.frame.size
//定义状态枚举
typedef NS_ENUM(NSInteger, QQHLGetDataType){
    //
    QQHLGetDataTypeNormal = 0,
    //
    QQHLGetDataTypeHeaderRefresh = 1,
    //
    QQHLGetDataTypeFooterRefresh = 2
};

@interface ViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    //定义全局变量数据源
//    NSMutableArray * _dataSource;
//    //
//    NSInteger _currentPageNum;
    //
    BOOL is_Download;
    //
    QQHLGetDataType _getDataType;
}
//定义属性
@property (nonatomic, strong) UITableView *QQHLTableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
//@property (nonatomic, assign) NSInteger currentPageNum;

@end




















