//
//  DateButton.m
//  TestCalender
//
//  Created by cyy on 11-3-12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DateButton.h"


@implementation DateButton
@synthesize dateStr;
@synthesize flag;

-(id) initWithFrame:(CGRect)theFrame dateStr:(NSString *)theDateStr andFlag:(NSString *)theFlag
{
	if((self = [super init]))
	{
		self.frame = theFrame;
		//self.backgroundColor = [UIColor clearColor];
		self.dateStr = theDateStr;
		self.titleLabel.font = [UIFont systemFontOfSize:14];
		[self setTitle:[self.dateStr substringFromIndex:5] forState:UIControlStateNormal];
		self.flag = theFlag;
		//if([self.flag isEqualToString:@"1"])
//		{
//			pointImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 6, 6)];
//			[pointImgV setContentMode:UIViewContentModeScaleAspectFit];
//			[pointImgV setImage:[UIImage imageNamed:@"point0.png"]];
//			[pointImgV setContentMode:UIViewContentModeCenter];
//			[self addSubview:pointImgV];
//			[pointImgV setCenter:CGPointMake(20, 30)];
//		}
	}
	return self;
}

- (void)dealloc 
{
	self.dateStr = nil;
	self.flag = nil;
	if(pointImgV)
	{
		[pointImgV release];
	}
    [super dealloc];
}


@end
