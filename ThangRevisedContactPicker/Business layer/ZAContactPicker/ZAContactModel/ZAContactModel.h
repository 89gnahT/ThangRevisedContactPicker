//
//  ZAContactModel.h
//  ThangRevisedContactPicker
//
//  Created by Thang on 9/7/2019.
//  Copyright © 2019 ThangNVH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContactModel.h"

NS_ASSUME_NONNULL_BEGIN

//@protocol ZAContactModelProtocol <NSObject>
//
//@required
//@property (nonatomic, readonly, copy) NSString *fullName;
//@property (nonatomic, readonly, copy) NSString *nameInitial;
//
//@end

@interface ZAContactModel : NSObject

@property (nonatomic, readonly) NSString *identifier;
@property (nonatomic, readonly) NSString *firstName;
@property (nonatomic, readonly) NSString *middleName;
@property (nonatomic, readonly) NSString *lastName;
@property (nonatomic, readonly) NSString *nameSuffix;
@property (nonatomic, readonly) NSString *phoneNumber;

-(instancetype)initWithContactModel:(ContactModel*)model;

@end

NS_ASSUME_NONNULL_END
