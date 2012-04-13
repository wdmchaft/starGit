//
//  CustomImageView.m
//  ShangPin
//
//  Created by apple_cyy on 11-2-23.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CustomImageView.h"


@implementation CustomImageView
@synthesize delegate;
@synthesize productNO;
@synthesize catalogNO;
@synthesize Name;

- (id)initWithFrame:(CGRect)frame 
{
    
    self = [super initWithFrame:frame];
    if (self) 
	{
		self.backgroundColor = [UIColor whiteColor];
        self.userInteractionEnabled = TRUE;
    }
    return self;
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[delegate customImageViewPressed:self];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc 
{
	[Name release];
	[productNO release];
	[catalogNO release];
    [super dealloc];
}


@end
