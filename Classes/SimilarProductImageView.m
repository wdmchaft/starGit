//
//  SimilarProductImageView.m
//  ShangPin
//
//  Created by cyy on 11-3-9.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SimilarProductImageView.h"


@implementation SimilarProductImageView
@synthesize catNo,productNo,img;
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
	[delegate didTouchEndSimilarProduct:self];
}

- (void)dealloc 
{
	[catNo release];
	[productNo release];
	[img release];
    [super dealloc];
}


@end
