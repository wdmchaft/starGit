//
//  LoadingView.m
//  ShangPin
//
//  Created by apple_cyy on 11-2-21.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LoadingView.h"


@implementation LoadingView
@synthesize activityV;
//等待界面初始化方法
- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) 
	{
        CGRect aFrame = CGRectMake(0, 0, frame.size.width, frame.size.height);
		UIView *aView = [[UIView alloc] initWithFrame:aFrame];
		aView.backgroundColor = [UIColor blackColor];
		aView.alpha = 0.8;
		[self addSubview:aView];
		[aView release];
		
		CGFloat centerY = self.frame.size.height / 2;
		UIView * bottmView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
        bottmView.backgroundColor = [UIColor colorWithRed:0.29f green:0.29f blue:0.29f alpha:1];
        bottmView.layer.masksToBounds = YES;
        bottmView.layer.cornerRadius = 10.0f;
        bottmView.center = CGPointMake(160, centerY);
        [self addSubview:bottmView];
        [bottmView release];
        
        activityV = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		activityV.frame = CGRectMake(0, 0, 30, 30);
		activityV.center = CGPointMake(160, centerY-10.0f);
//        activityV.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.4f];
//        activityV.layer.masksToBounds = YES;
//        activityV.layer.cornerRadius = 5.0f;
		[activityV startAnimating];
		[self addSubview:activityV];
		
		waitLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
		CGPoint labelCenter = CGPointMake(160, centerY + 20);
		waitLabel.center = labelCenter;
        waitLabel.font = [UIFont systemFontOfSize:13.0f];
		waitLabel.textColor = [UIColor whiteColor];//WORDCOLOR;
		waitLabel.textAlignment = UITextAlignmentCenter;
		waitLabel.backgroundColor = [UIColor clearColor];
        waitLabel.text = @"正在加载";
		[self addSubview:waitLabel];
    }
    return self;
}

//移除上面的控键
-(void) finishLoading
{
	[activityV stopAnimating];
	[activityV removeFromSuperview];
	[waitLabel removeFromSuperview];
}

//释放相关
- (void)dealloc
{
	[waitLabel release];
	[activityV release];
    [super dealloc];
}


@end
