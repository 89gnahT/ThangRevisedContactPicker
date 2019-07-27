//
//  ContactModel.h
//  ThangRevisedContactPicker
//
//  Created by Thang on 9/7/2019.
//  Copyright © 2019 ThangNVH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Contacts/Contacts.h>

NS_ASSUME_NONNULL_BEGIN

@interface ContactModel : NSObject

@property (nonatomic, readonly) NSString *identifier;
@property (nonatomic, readonly) NSString *firstName;
@property (nonatomic, readonly) NSString *middleName;
@property (nonatomic, readonly) NSString *lastName;
@property (nonatomic, readonly) NSString *nameSuffix;
@property (nonatomic, readonly) NSMutableArray *phoneNumberArray;

-(instancetype)initWithCNContact:(CNContact*)contact;

@end

NS_ASSUME_NONNULL_END
