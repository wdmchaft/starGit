//
//  MyPrompt.m
//  ShangPin
//
//  Created by cyy on 11-3-9.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyPrompt.h"


@implementation MyPrompt
@synthesize promptID;
@synthesize date;
@synthesize push;
@synthesize img;
@synthesize name;

-(void) dealloc
{
	[promptID release];
	[date release];
	[push release];
	[img release];
	[name release];
	[super dealloc];
}

@end
