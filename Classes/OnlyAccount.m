//
//  OnlyAccount.m
//  ShangPin
//
//  Created by apple_cyy on 11-2-23.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "OnlyAccount.h"


@implementation OnlyAccount
@synthesize account,realName,password,gender;

static OnlyAccount *myAccount = nil;

+(id) defaultAccount
{
	if(myAccount == nil)
	{
		myAccount = [[OnlyAccount alloc] init];
	}
	return myAccount;
}

-(void) dealloc
{
	[password release];
	[account release];
	[realName release];
    [gender release];
	[super dealloc];
}

@end
