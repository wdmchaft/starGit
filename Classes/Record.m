//
//  Record.m
//  ShangPin
//
//  Created by apple_cyy on 11-3-1.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Record.h"


@implementation Record

@synthesize time;
@synthesize contactway;

-(void) dealloc
{
	[time release];
	[contactway release];
	[super dealloc];
}

@end
