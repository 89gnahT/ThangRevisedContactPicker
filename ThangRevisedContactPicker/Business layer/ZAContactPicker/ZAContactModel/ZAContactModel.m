//
//  ZAContactModel.m
//  ThangRevisedContactPicker
//
//  Created by Thang on 9/7/2019.
//  Copyright © 2019 ThangNVH. All rights reserved.
//

#import "ZAContactModel.h"

@implementation ZAContactModel

- (instancetype)initWithContactModel:(ContactModel *)model{
    self = [super init];
    if (self){
        _identifier  = model.identifier;
        _firstName   = model.firstName;
        _middleName  = model.middleName;
        _lastName    = model.lastName;
        _nameSuffix  = model.nameSuffix;
//        for (int i = 0; i< [model.phoneNumberArray count]; ++i){
//            _phoneNumber = model.phoneNumberArray[i];
//        }
        _phoneNumber = model.phoneNumberArray[0];
    }
    return self;
}

@end
