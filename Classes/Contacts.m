//
//  Contacts.m
//  Message Send
//
//  通讯录类
//  Created by BB-JiaFei by on 11-2-23.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Contacts.h"


@implementation Contacts

@synthesize contactName;
@synthesize contactPhoneArray;


- (void)dealloc 
{
	[contactPhoneArray release];
	[contactName release];
    [super dealloc];
}


@end
