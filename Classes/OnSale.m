//
//  OnSale.m
//  ShangPin
//
//  Created by apple_cyy on 11-2-21.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "OnSale.h"

//@implementation OnSale
//@synthesize ID;
//@synthesize Name;
//@synthesize img;
//
//
//-(void) dealloc
//{
//	[ID release];
//	[Name release];
//	[img release];
//	[super dealloc];
//}
//
//@end
//



@implementation OnSale
@synthesize ID;
@synthesize title;
@synthesize date;
@synthesize Name;
@synthesize img;
@synthesize text;


-(void) dealloc
{
	[ID release];
    [title release];
    [date release];
	[Name release];
	[img release];
    [text release];
	[super dealloc];
}

@end
