//
//  Additions.h
//  GroupMessageSend
//
//  通讯录封装类
//  Created by BB-JiaFei by on 11-3-1.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


/*
 通讯录 模型的分类
 
 添加了获得全部联系人的方法
 */

#import <UIKit/UIKit.h>
#import "Contacts.h"

@interface Contacts(ICBCAdditions)



//获得全部联系人
+ (NSMutableArray *) getAllContacts;

@end

