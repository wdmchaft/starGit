//
//  CustomTableViewCell0.m
//  ShangPin
//
//  Created by 唐彬琪 on 11-8-7.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "CustomTableViewCell.h"


@implementation CustomTableViewCell
@synthesize brandName;
@synthesize activityName;
@synthesize activityTime;
@synthesize act_imageView;
@synthesize invButton;
@synthesize addRemindButton;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //图片
        UIImage * cellImage = [UIImage imageNamed:@"cell_BJ.png"];
        UIImage * cellBackImage = [cellImage stretchableImageWithLeftCapWidth:2 topCapHeight:0];
        UIImageView * cellBackView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 90)];
        cellBackView.image = cellBackImage;
        [self.contentView addSubview:cellBackView];
        [cellBackView release];
        
        act_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 140, 89)];
        act_imageView.backgroundColor = [UIColor clearColor];
        act_imageView.tag = 500;
        [self addSubview:act_imageView];
        [act_imageView release];
        
        activityName = [[UILabel alloc] initWithFrame:CGRectMake(150, 0, 170, 40)];
        activityName.backgroundColor = [UIColor clearColor];
        activityName.tag = 501;
        activityName.textColor = WORDCOLOR;//[UIColor whiteColor];
        activityName.font = [UIFont boldSystemFontOfSize:15.0f];
        [self addSubview:activityName];
        [activityName release];
        
        brandName = [[UILabel alloc] initWithFrame:CGRectMake(150, 40, 170, 25)];
        brandName.backgroundColor = [UIColor clearColor];
        brandName.tag = 502;
        brandName.textColor = [UIColor colorWithRed:1.0f green:0.863f blue:0.322f alpha:1.0f];//whiteColor];
        brandName.font = [UIFont systemFontOfSize:14.0f];
        [self addSubview:brandName];
        [brandName release];

        activityTime = [[UILabel alloc] initWithFrame:CGRectMake(150, 65, 200, 25)];
        activityTime.backgroundColor = [UIColor clearColor];
        activityTime.tag = 503;
        activityTime.textColor = [UIColor whiteColor];
        activityTime.font = [UIFont systemFontOfSize:13.0f];
        [self addSubview:activityTime];
        [activityTime release];
        

     }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//自定义cell的释放
- (void)dealloc
{
    [act_imageView release];
    [brandName release];
    [activityName release];
    [activityTime release];
    [super dealloc];
}

@end
