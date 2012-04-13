//
//  MessageBoardView.h
//  ShangPin
//
//  Created by apple_cyy on 11-2-25.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*
 留言板 视图
 对应界面:我的账户->留言板
 */

@protocol MessageBoardViewDelegate

-(void) didMessageBoardViewFinishLaunching;

@end


#import <UIKit/UIKit.h>


@interface MessageBoardView : UIView <UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
	id<MessageBoardViewDelegate> messageBoardDelegate;	//留言板代理
	
	UITextField *myMessageTF;					//我的留言 输入框
	
	NSURLConnection *sendMessageConnection;		//发送留言的 链接
	NSURLConnection *messageBoardConnection;	//获得留言列表的 链接
	NSMutableArray *mesaageArray;				//留言记录 存放于本数组中
	UITableView *m_tableView;					//留言记录 显示于此控件中
	NSMutableData *receivedData;				//数据接收
	LoadingView *loadingView;					//等待界面
}

@property(nonatomic,assign) id<MessageBoardViewDelegate> messageBoardDelegate;
@property(nonatomic,retain) NSMutableArray *mesaageArray;
@property(nonatomic,retain) NSMutableData *receivedData;
@property(nonatomic,retain) UITextField *myMessageTF;

-(void) loadMessage;

@end
