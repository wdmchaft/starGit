//
//  CustomTabBar.h
//  ShangPin
//
//  Created by 唐彬琪 on 11-8-15.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol CustomTabBarDelegate <NSObject>;
@required
- (void)selecedTabBarAction:(NSInteger)buttonTag;
@end

@interface CustomTabBar : UITabBarController {
    NSMutableArray * buttons;
    id<CustomTabBarDelegate>customTabDelegate;
    double _width;
	double _height;

    
}
@property (nonatomic, retain) NSMutableArray * buttons;
@property (nonatomic, retain) id customTabDelegate;
@property (assign) double _width;
@property (assign) double _height;

- (void)customTabBarButton;
- (void)selectedTabBarNo:(NSInteger)tag;
- (void)changeImageBtn:(NSInteger)tag;
@end
