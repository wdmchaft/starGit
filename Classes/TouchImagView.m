//
//  untitled.m
//  ShangPin
//
//  Created by ibokan on 11-3-8.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TouchImagView.h"


@implementation TouchImagView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) 
	{
		self.backgroundColor = [UIColor grayColor];
        self.userInteractionEnabled = YES;
    }
    return self;
}


//处理触摸事件
-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[delegate didTouchEndImagViewWithIndex:self.tag];
}

- (void)dealloc 
{
    [super dealloc];
}


@end
