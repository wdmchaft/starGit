    //
//  ContactListViewController.m
//  ShangPin
//
//  Created by apple_cyy on 11-3-7.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ContactListViewController.h"
#import "SelectPhoneNumberViewController.h"
#import "InviteViewController.h"
#import "TellFriendViewController.h"

@implementation ContactListViewController
@synthesize phoneNumber;
@synthesize contactArray;
@synthesize inviteVC;
@synthesize tellfVC;
@synthesize oGFVC;

#pragma mark -
#pragma mark 通讯录列表 初始化
- (void)loadView 
{
	self.contactArray = [Contacts getAllContacts];
	contactTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 367) style:UITableViewStyleGrouped];
	contactTableView.backgroundColor = [UIColor blackColor];
	contactTableView.delegate = self;
	contactTableView.dataSource = self;
	self.view = contactTableView;
	[contactTableView release];
}

#pragma mark -
#pragma mark UITableViewDelegate,UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	return [self.contactArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *MyIdentifier = @"cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 
									   reuseIdentifier:MyIdentifier] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"1x40.png"]];
	} 
	Contacts *contact = [self.contactArray objectAtIndex:indexPath.row];
	cell.textLabel.text = contact.contactName;
	cell.textLabel.textColor = WORDCOLOR;
	cell.textLabel.backgroundColor = [UIColor clearColor];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	Contacts *contact = [self.contactArray objectAtIndex:indexPath.row];
	SelectPhoneNumberViewController *select = [[SelectPhoneNumberViewController alloc] init];
	select.nameStr = contact.contactName;
	select.conLVC = self;
	select.phoneArray = contact.contactPhoneArray;
	[self.navigationController pushViewController:select animated:YES];
	[select show];
	[select release];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 40;
}


#pragma mark -
#pragma mark 释放相关
- (void)dealloc 
{
	self.tellfVC = nil;
	self.inviteVC = nil;
	self.phoneNumber = nil;
	self.contactArray = nil;
	self.oGFVC = nil;
    [super dealloc];
}


@end
