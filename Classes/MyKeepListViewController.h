//
//  MyKeepListViewController.h
//  ShangPin
//
//  Created by tang binqi on 12-2-12.
//  Copyright (c) 2012年 shangpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnsaleDetailViewController.h"

@class LoadingView;
@interface MyKeepListViewController : UITableViewController
{
    NSMutableArray * keepListArray;                   //添加收藏的商品列表数组
    NSURLConnection * KeepListConnection;             //获取收藏商品 链接
    NSURLConnection * cancleKeepConnection;     //修改收藏  链接
    NSMutableData * receivedData;                            //接口返回数据
    LoadingView * loadingView;
    NSString * keepID;                                                 //收藏ID
    OnsaleDetailViewController *buyDetailVC;          //产品详情
    NSMutableArray *onsaleCatalogArray;			//产品数据
    NSInteger cellNum;
}
@property(nonatomic , retain)NSMutableData * receivedData;  
@property(nonatomic, retain)	NSMutableArray *onsaleCatalogArray;			//产品数据

-(float)contentWidth: (NSString *)string;
-(void) getMyKeepList;

@end
