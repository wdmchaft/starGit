//
//  Catalog.m
//  ShangPin
//
//  Created by apple_cyy on 11-2-23.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Catalog.h"


@implementation Catalog

@synthesize ID;
@synthesize Name;
@synthesize itemArray;


-(void) dealloc
{
	[ID release];
	[Name release];
	[itemArray release];
	[super dealloc];
}

@end
