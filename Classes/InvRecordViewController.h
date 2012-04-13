//
//  InvRecordViewController.h
//  ShangPin
//
//  Created by 唐彬琪 on 11-8-4.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface InvRecordViewController : UIViewController <UITableViewDataSource,UITableViewDelegate> {
 
    NSMutableArray * recordArray;                 //邀请记录 存放于本数组
    UITableView * recordTableView;                //邀请记录列表 显示于此控件
    
    NSMutableData * receivedData;                 //数据接收 
    NSURLConnection * recordConnection;           //获得邀请记录的链接
    
    LoadingView * loadingView;                    //等待界面
 }

@property(nonatomic, retain)NSMutableData * receivedData;
@property(nonatomic, retain)NSMutableArray * recordArray;


- (void)loadRecordList;                             //加载邀请列表数据

@end
