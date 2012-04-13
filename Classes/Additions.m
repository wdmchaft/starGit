    //
//  Additions.m
//  GroupMessageSend
//	
//  通讯录封装类
//  Created by BB-JiaFei by on 11-3-1.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Additions.h"

@implementation Contacts(ICBCAdditions)

+ (NSMutableArray *) getAllContacts 
{	
    NSMutableArray *contactsArray = [[[NSMutableArray alloc] init] autorelease];
    NSMutableArray* personArray = [[[NSMutableArray alloc] init] autorelease];
    
    ABAddressBookRef addressBook = ABAddressBookCreate();
    NSString *firstName, *lastName, *fullName;
   personArray = (NSMutableArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
	
    for (id person in personArray) 
	{
		Contacts *contact = [[Contacts alloc] init];
		
		NSMutableArray * phoneArray = [[NSMutableArray alloc]init];
        contact.contactPhoneArray = phoneArray;
        [phoneArray release];
		
        firstName = (NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
        if(firstName)
		{
			fullName = [firstName stringByAppendingFormat:@" "];
		}
		else
		{
			fullName = @"";
		}
        lastName = (NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
		if(lastName)
		{
			fullName = [fullName stringByAppendingString:lastName];
		}
        contact.contactName = fullName;
        NSLog(@" firstName ＝ %@  lastName = %@  fullName = %@",firstName,lastName,fullName);
		
        ABMultiValueRef phones = (ABMultiValueRef) ABRecordCopyValue(person, kABPersonPhoneProperty);
        for(int i = 0 ;i < ABMultiValueGetCount(phones); i++) 
		{  
            NSString *phone = (NSString *)ABMultiValueCopyValueAtIndex(phones, i);
            NSLog(@"phoneNum = %@",phone);
            [contact.contactPhoneArray addObject:phone];
        }
		[contactsArray addObject:contact];   // add contact into array
		
		[contact release];
    }  
	
    return contactsArray;
}

@end

