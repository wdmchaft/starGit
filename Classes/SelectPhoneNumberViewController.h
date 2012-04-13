//
//  SelectPhoneNumberViewController.h
//  ShangPin
//
//  Created by apple_cyy on 11-3-7.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*
 号码选取 视图控制器
 
 从联系人列表进入本类
 某联系人的全部电话号码
 */

#import <UIKit/UIKit.h>
@class ContactListViewController;

@interface SelectPhoneNumberViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>
{
	ContactListViewController *conLVC;		//联系人列表 视图控制器
	NSString *nameStr;						//姓名
	NSArray * nameStrArray;                //姓名+手机号
    NSString * selectPhone;                  //选择的手机号码
    NSMutableArray *phoneArray;				//手机号码列表数组
	UITableView *phoneTableView;			//手机号码列表
}

@property(nonatomic,copy) NSString *nameStr;
@property(nonatomic,retain) NSArray * nameStrArray;
@property(nonatomic,retain) NSString * selectPhone;
@property(nonatomic,retain) NSMutableArray *phoneArray;
@property(nonatomic,retain) ContactListViewController *conLVC;

-(void) show;

@end
