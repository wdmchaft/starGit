//
//  OneMessage.h
//  ShangPin
//
//  Created by 唐彬琪 on 11-8-3.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface OneMessage : NSObject {
 
    NSString *Date;			//建议时间
	NSString *message;		//建议内容
    BOOL isme;              //建议还是回复
}

@property(nonatomic, copy) NSString *Date;
@property(nonatomic, copy) NSString *message;
@property(assign) BOOL isme;


@end
