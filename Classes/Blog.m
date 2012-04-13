//
//  Blog.m
//  ShangPin
//
//  Created by apple_cyy on 11-2-21.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Blog.h"


@implementation Blog

@synthesize ID;
@synthesize title;
@synthesize time;
@synthesize content;

-(void) dealloc
{
	[ID release];
	[title release];
	[time release];
	[content release];
	[super dealloc];
}

@end
