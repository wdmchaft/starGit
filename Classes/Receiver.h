//
//  Receiver.h
//  ShangPin
//
//  Created by ch_int_beam on 11-3-9.
//  Copyright 2011 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Address.h"


@interface Receiver : Address 
{
	NSString *isdefault;
}

@property (nonatomic, retain) NSString *isdefault;

@end
