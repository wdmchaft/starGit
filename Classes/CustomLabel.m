//
//  CustomLabel.m
//  PingAn
//
//  Created by apple_cyy on 10-12-14.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CustomLabel.h"

@implementation CustomLabel

-(id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if(!self) return nil;
	
	_verticalAlignment = VerticalAlignmentTop;
	return self;
}

-(void)dealloc
{
	[super dealloc];
}

-(VerticalAlignment)verticalAlignment
{
	return _verticalAlignment;
}

-(void) setVerticalAlignment:(VerticalAlignment)value
{
	_verticalAlignment = value;
	[self setNeedsDisplay];
}

-(CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines
{
	CGRect rect = [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
	CGRect result;
	switch(_verticalAlignment)
	{
		case VerticalAlignmentTop:
		{
			result = CGRectMake(bounds.origin.x, bounds.origin.y, rect.size.width, rect.size.height);
			break;
		}
		case VerticalAlignmentMiddle:
		{
			result = CGRectMake(bounds.origin.x, bounds.origin.y + (bounds.size.height -rect.size.height)/2, rect.size.width, rect.size.height);
			break;
		}
		case VerticalAlignmentBottom:
		{
			result = CGRectMake(bounds.origin.x, bounds.origin.y + (bounds.size.height - rect.size.height), rect.size.width, rect.size.height);
			break;
		}
		default:
		{
			result = bounds;
			break;
		}
	}
	return result;
}

-(void)drawTextInRect:(CGRect)rect
{
	CGRect r = [self textRectForBounds:rect limitedToNumberOfLines:self.numberOfLines];
	[super drawTextInRect:r];
}

@end
