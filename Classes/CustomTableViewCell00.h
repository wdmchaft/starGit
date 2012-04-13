//
//  CustomTableViewCell.h
//  ShangPin
//
//  Created by apple_cyy on 11-2-18.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*
 自定义cell
 
 正在出售、即将出售以及预售日历 的tableviewcell
 */

#import <UIKit/UIKit.h>


@interface CustomTableViewCell00 : UITableViewCell 
{
	UIImageView *m_imageView;			//图片视图
	UIButton *leftButton;				//左边按钮
	UIButton *rightButton;				//右边按钮
}

@property(nonatomic,retain) UIImageView *m_imageView;
@property(nonatomic,retain) UIButton *leftButton;
@property(nonatomic,retain) UIButton *rightButton;

@end
