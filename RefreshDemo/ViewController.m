//
//  ViewController.m
//  RefreshDemo
//
//  Created by Jason on 16/4/16.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

//
static NSString *cellId = @"reuseCellId";

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    [self instantiationMothed];
    //
    [self createTableView];
}
/**
 *  实例化定义的变量
 */
- (void)instantiationMothed{
    //初始化数组
    _dataSource = [[NSMutableArray alloc] init];
    //初始页数
    //_currentPageNum = 0;
    //初始化状态
    //is_Download = NO;
    //初始化加载数据状态
    //_getDataType = QQHLGetDataTypeNormal;
}
//
- (UITableView *)createTableView{
    
    if (_QQHLTableView == nil) {
        
        _QQHLTableView = [[UITableView alloc] initWithFrame:CGRectMake(VIEW_ORIGIN.x, VIEW_ORIGIN.y, VIEW_SIZE.width, VIEW_SIZE.height) style:UITableViewStylePlain];
        
        _QQHLTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _QQHLTableView.dataSource = self;
        _QQHLTableView.delegate = self;
        //
        [_QQHLTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellId];
        //
        [self.view addSubview:_QQHLTableView];
        //
        __weak typeof(self) weakSelf = self;
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            //
            [weakSelf getDataFromServece:NO];
        }];
        //
        _QQHLTableView.mj_header = header;
        //
        MJRefreshBackNormalFooter * footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [weakSelf getDataFromServece:YES];
        }];
        _QQHLTableView.mj_footer = footer;
        [_QQHLTableView.mj_header beginRefreshing];
    }
    return _QQHLTableView;
}
//
- (void)getDataFromServece:(BOOL)isLoadingMore{
    NSInteger currentPageNum = 0;
    if (isLoadingMore) {
        if (0 == _dataSource.count % 15) {
            currentPageNum = _dataSource.count / 15;
        }else{
            [_QQHLTableView.mj_footer endRefreshing];
            return;
        }
    }
    NSString *url = [NSString stringWithFormat:@"%@%ld", DOMAINNAME_URL, currentPageNum];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        GDataXMLDocument *xmlDocument = [[GDataXMLDocument alloc] initWithData:responseObject error:nil];
        
        NSArray *newsArray = [xmlDocument nodesForXPath:@"//oschina/newslist/news" error:nil];
        
        if (!isLoadingMore) {
            
            [_dataSource removeAllObjects];
            //
            [_QQHLTableView reloadData];
        }
        //
        for (GDataXMLElement *newElement in newsArray) {
            
            NewsModel *model = [[NewsModel alloc] init];
            GDataXMLElement *titleElement = [newElement elementsForName:@"title"][0];
            model.title = [titleElement stringValue];
            
            GDataXMLElement *idElement = [newElement elementsForName:@"id"][0];
            model.news_ID = [idElement stringValue];
            [_dataSource addObject:model];
        }
        //
        [_QQHLTableView reloadData];
        //
        isLoadingMore ? [_QQHLTableView.mj_footer endRefreshing] : [_QQHLTableView.mj_header endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        isLoadingMore ? [_QQHLTableView.mj_footer endRefreshing] : [_QQHLTableView.mj_header endRefreshing];
    }];

}
#pragma mark - 刷新数据 -
//刷新数据


#pragma mark - delegate Method -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}
//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    NewsModel *model = _dataSource[indexPath.row];
    
    cell.textLabel.text = model.title;
    return cell;
}
//
- (void)didReceiveMemoryWarning {
    
    // Dispose of any resources that can be recreated.
}

@end
