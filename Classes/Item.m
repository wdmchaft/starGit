//
//  Item.m
//  ShangPin
//
//  Created by apple_cyy on 11-2-23.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Item.h"


@implementation Item

@synthesize ID;
@synthesize Name;
@synthesize rackrate;
@synthesize Level;
@synthesize limitedprice;
@synthesize img;
@synthesize Type;
@synthesize Count;

-(void) dealloc
{
	[ID release];
	[Name release];
	[rackrate release];
	[Level release];
	[limitedprice release];
	[img release];
	[Type release];
	[Count release];	
	[super dealloc];
}


@end
