//
//  ContactModel.m
//  ThangRevisedContactPicker
//
//  Created by Thang on 9/7/2019.
//  Copyright © 2019 ThangNVH. All rights reserved.
//

#import "ContactModel.h"

@implementation ContactModel

-(instancetype)initWithCNContact:(CNContact *)contact{
    self = [super init];
    if (self){
        _identifier = contact.identifier;
        _firstName  = contact.givenName;
        _middleName = contact.middleName;
        _lastName   = contact.familyName;
        _nameSuffix = contact.nameSuffix;
        _phoneNumberArray = [[NSMutableArray alloc]init];
        for (CNLabeledValue *label in contact.phoneNumbers) {
            NSString *phone = [label.value stringValue];
            if ([phone length] >0) {
                [_phoneNumberArray addObject:phone];
            }
        }
    }
    return self;
}

@end
