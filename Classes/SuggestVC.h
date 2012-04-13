//
//  SuggestVC.h
//  ShangPin
//
//  Created by 唐彬琪 on 11-7-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

@protocol MessageBoardViewDelegate

-(void) didMessageBoardViewFinishLaunching;

@end


#import <UIKit/UIKit.h>


@interface SuggestVC : UIViewController <UITextViewDelegate,UITableViewDelegate,UITableViewDataSource> {
    id<MessageBoardViewDelegate> messageBoardDelegate;	//建议栏代理
    
    UITextView * bottomTextView;                  //建议输入框
    UITableView * suggestTableView;                //建议记录 显示于此控件中
    NSURLConnection *sendMessageConnection;		//发送建议的 链接
	NSURLConnection *messageBoardConnection;	//获得建议列表的 链接
	NSMutableArray *mesaageArray;				//建议记录 存放于本数组中
						
	NSMutableData *receivedData;				//数据接收
	LoadingView *loadingView;					//等待界面

}
@property(nonatomic, retain) NSMutableArray *mesaageArray;
@property(nonatomic, retain) NSMutableData *receivedData;


-(void) loadMessage;
@end
