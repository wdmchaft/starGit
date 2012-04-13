//
//  TouchImageView_star.m
//  ShangPin
//
//  Created by binqi tang on 11-11-13.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "TouchImageView_star.h"

@implementation TouchImageView_star
@synthesize delegate;

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
    }
    return self;

}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [delegate TouchStopAnimation];
}

-(void)dealloc
{
    [super dealloc];
}

@end
