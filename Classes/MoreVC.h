//
//  MoreVC.h
//  ShangPin
//
//  Created by 唐彬琪 on 11-7-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HootLineVC,WeiBoVC,ServiceVC,SuggestVC,AboutShangpinVC;
@interface MoreVC : UIViewController <UIScrollViewDelegate>{
    HootLineVC * hootLineVC;
    WeiBoVC * weiBoVC;
    ServiceVC * serviceVC;
    SuggestVC * suggestVC;
    AboutShangpinVC * aboutShangpinVC;
    
}

@end
