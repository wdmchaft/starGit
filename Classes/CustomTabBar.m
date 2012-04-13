//
//  CustomTabBar.m
//  ShangPin
//
//  Created by 唐彬琪 on 11-8-15.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "CustomTabBar.h"

@implementation CustomTabBar
@synthesize buttons;
@synthesize customTabDelegate;
@synthesize _width,_height;

- (void)customTabBarButton{
   //skhdfks
    //kasndklfnda 
    int viewCount = self.viewControllers.count > 5 ? 5 : self.viewControllers.count;
	self.buttons = [NSMutableArray arrayWithCapacity:viewCount];
	_width = 320 / viewCount;
	_height = self.tabBar.frame.size.height;
    for (int i = 0; i < viewCount; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i*_width,self.tabBar.frame.origin.y, _width, _height);
        //[btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"light%d",i]] forState:UIControlStateHighlighted];
        btn.backgroundColor = [UIColor clearColor];
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"dark%d",i]] forState:UIControlStateNormal];
		[btn addTarget:self action:@selector(sentDelegate:) forControlEvents:UIControlEventTouchUpInside];
		btn.showsTouchWhenHighlighted = YES;
        btn.tag = i;
		[self.buttons addObject:btn];
		[self.view addSubview:btn];
        self.view.backgroundColor = [UIColor clearColor];
	}
    //self.selectedIndex = 4;
    //[self selectedTabBarNo:0];

}
/*
//隐藏原有tabBar
- (void)hideRealTabBar{
	for(UIView *view in self.view.subviews){
		if([view isKindOfClass:[UITabBar class]]){
			view.hidden = YES;
			break;
		}
	}
}
*/


- (void)sentDelegate:(UIButton *)button{
    NSLog(@"%s",__FUNCTION__);
    [customTabDelegate selecedTabBarAction:button.tag];
}


- (void)selectedTabBarNo:(NSInteger)tag
{
    //NSLog(@"%s",__FUNCTION__);
    UIButton * button = [buttons objectAtIndex:tag];
    if (self.selectedIndex != button.tag) 
    {
    	 NSLog(@"%s",__FUNCTION__);
        self.selectedIndex = button.tag;
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"light%d",button.tag]] forState:UIControlStateNormal];
        for (NSInteger tagx = 0; tagx<[buttons count];tagx++) 
        {
            if (tagx != button.tag) 
            {
                UIButton * button = [buttons objectAtIndex:tagx];
                [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"dark%d",tagx]] forState:UIControlStateNormal];
                
            }
        }
    }
 }

//确保第一次初始化view显示的时候，第一个uitabitem上面的图片是发亮的
- (void)changeImageBtn:(NSInteger)tag
{
    UIButton * button = [buttons objectAtIndex:tag];

    self.selectedIndex = button.tag;
    [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"light%d",button.tag]] forState:UIControlStateNormal];
    for (NSInteger tagx = 0; tagx<[buttons count];tagx++) 
    {
        if (tagx != button.tag) 
        {
            UIButton * button = [buttons objectAtIndex:tagx];
            [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"dark%d",tagx]] forState:UIControlStateNormal];
            
        }
    }

}


- (void) dealloc{
	[buttons release];
	[super dealloc];
}


@end
