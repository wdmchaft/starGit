//
//  Item2.m
//  ShangPin
//
//  Created by cyy on 11-3-9.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Item2.h"


@implementation Item2
@synthesize productNo;
@synthesize catNo;
@synthesize img;

-(void) dealloc
{
	[productNo release];
	[catNo release];
	[img release];
	[super dealloc];
}

@end
