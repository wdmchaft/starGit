//
//  Goods.m
//  ShangPin
//
//  Created by apple_cyy on 11-2-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Goods.h"


@implementation Goods
@synthesize ID;
@synthesize Name;
@synthesize rackrate;
@synthesize limitedprice;
@synthesize img;

-(void) dealloc
{
	[ID release];
	[Name release];
	[rackrate release];
	[limitedprice release];
	[img release];
	[super dealloc];
}


@end
