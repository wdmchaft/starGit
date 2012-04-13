    //
//  SelectPhoneNumberViewController.m
//  ShangPin
//
//  Created by apple_cyy on 11-3-7.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SelectPhoneNumberViewController.h"
#import "ContactListViewController.h"
#import "InviteViewController.h"
#import "TellFriendViewController.h"
#import "OnsaleGroomFriendsViewController.h"

@implementation SelectPhoneNumberViewController
@synthesize phoneArray;
@synthesize nameStr;
@synthesize nameStrArray;
@synthesize selectPhone;
@synthesize conLVC;

#pragma mark -
#pragma mark 去掉电话号码里面的 空格 - ()
-(NSString*)trim:(NSString*)string
{
	NSString* returnStr = string;
	returnStr = [returnStr stringByTrimmingCharactersInSet:([NSCharacterSet whitespaceAndNewlineCharacterSet])];
	returnStr = [returnStr stringByReplacingOccurrencesOfString: @"(" withString: @""];
	returnStr = [returnStr stringByReplacingOccurrencesOfString: @")" withString: @""];
	returnStr = [returnStr stringByReplacingOccurrencesOfString: @"-" withString: @""];
	returnStr = [returnStr stringByReplacingOccurrencesOfString:@" " withString:@""];
	return returnStr;
}

#pragma mark -
#pragma mark 返回联系人列表
- (void)returnBack
{
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark 号码选取视图控制器 初始化
- (void)loadView 
{
	self.title = @"联系电话";
	UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
	backButton.frame = CGRectMake(0, 0, 53, 29);
    backButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [backButton setTitle:@"  返回" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
	[backButton setBackgroundImage:[UIImage imageNamed:@"Back.png"] forState:UIControlStateNormal];
	[backButton addTarget:self action:@selector(returnBack) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
	self.navigationItem.leftBarButtonItem = backItem;
	[backItem release];
	
	phoneTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 367) style:UITableViewStyleGrouped];
	phoneTableView.backgroundColor = [UIColor blackColor];
	phoneTableView.delegate = self;
	phoneTableView.dataSource = self;
	self.view = phoneTableView;
	[phoneTableView release];
}

-(void) show
{
	self.title = self.nameStr;
	[phoneTableView reloadData];
}

#pragma mark -
#pragma mark UITableViewDelegate,UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.phoneArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *MyIdentifier = @"cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	if (cell == nil) 
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyIdentifier] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"1x40.png"]];
	} 
	cell.textLabel.text = [self.phoneArray objectAtIndex:indexPath.row];
	cell.textLabel.textColor = WORDCOLOR;
	cell.textLabel.backgroundColor = [UIColor clearColor];
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	//self.selectPhone = [self trim:[self.phoneArray objectAtIndex:indexPath.row]];
    NSString * selectPhone_s = [self trim:[self.phoneArray objectAtIndex:indexPath.row]];
    NSString * nameStr_s = self.nameStr;
    NSArray * nArray = [[NSArray alloc] initWithObjects:nameStr_s,selectPhone_s, nil];
    self.nameStrArray = nArray;
    [nArray release];
    //self.nameStr = [self trim:[self.phoneArray objectAtIndex:indexPath.row]];
	if(self.conLVC.inviteVC)
	{
		[self.conLVC.inviteVC.delegate didFinishChoosePhoneNumberInvite:self.nameStrArray];
		[self.conLVC.inviteVC.delegate hideMobileLabel];
        [self.navigationController popToViewController:self.conLVC.inviteVC animated:YES];
        
	}
	if(self.conLVC.tellfVC)
	{
		[self.conLVC.tellfVC.delegate didFinishChoosePhoneNumberInvite:self.nameStrArray];
		[self.navigationController popToRootViewControllerAnimated:YES];
	}
	if(self.conLVC.oGFVC)
	{
		[self.conLVC.oGFVC.delegate didFinishChoosePhoneNumberInvite:self.nameStrArray];
		[self.navigationController popToRootViewControllerAnimated:YES];
	}
}


- (void)dealloc 
{
	self.conLVC = nil;
	self.nameStr = nil;
    self.nameStrArray = nil;
	self.phoneArray = nil;
    [super dealloc];
}


@end
