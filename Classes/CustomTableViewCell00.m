//
//  CustomTableViewCell.m
//  ShangPin
//
//  Created by apple_cyy on 11-2-18.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CustomTableViewCell00.h"


@implementation CustomTableViewCell00
@synthesize m_imageView,leftButton,rightButton;


//cell初始化方法
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) 
	{
		//图片
		m_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 95)];
		m_imageView.backgroundColor = [UIColor blackColor];
		[self addSubview:m_imageView];
        [m_imageView release];
		
		//横条
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 75, 320, 20)];
		bottomView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"1x20.png"]];
		[self addSubview:bottomView];
		[bottomView release];
		
		leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
		leftButton.frame = CGRectMake(10, 75, 68, 20);
		[self addSubview:leftButton];
		
		rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
		rightButton.frame = CGRectMake(79, 75, 68, 20);
		[self addSubview:rightButton];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    
    [super setSelected:selected animated:animated];
}

//自定义cell的释放
- (void)dealloc 
{
	[m_imageView release];
    [super dealloc];
}


@end
