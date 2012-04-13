//
//  ContactListViewController.h
//  ShangPin
//
//  Created by apple_cyy on 11-3-7.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*
 通讯录列表
 
 告诉朋友，推荐给好友以及邀请好友都会用到这个类
 */

#import <UIKit/UIKit.h>
@class InviteViewController;
@class TellFriendViewController;
@class OnsaleGroomFriendsViewController;

@interface ContactListViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>
{
	OnsaleGroomFriendsViewController *oGFVC;	//推荐给好友
	TellFriendViewController *tellfVC;	//告诉好友
	InviteViewController *inviteVC;		//邀请视图控制器
	NSString *phoneNumber;				//选中的各个电话号码
	NSMutableArray *contactArray;		//联系人
	UITableView *contactTableView;		//所有联系人 存于本列表中
}

@property(nonatomic,copy) NSString *phoneNumber;
@property(nonatomic,retain) NSMutableArray *contactArray;
@property(nonatomic,retain) InviteViewController *inviteVC;
@property(nonatomic,retain) TellFriendViewController *tellfVC;
@property(nonatomic,retain) OnsaleGroomFriendsViewController *oGFVC;

@end
