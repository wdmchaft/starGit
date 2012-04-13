//
//  Message.m
//  ShangPin
//
//  Created by apple_cyy on 11-3-1.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Message.h"


@implementation Message

@synthesize Date;
@synthesize message;
@synthesize reply;


-(void) dealloc
{
	[Date release];
	[message release];
	[reply release];
	[super dealloc];
}

@end
