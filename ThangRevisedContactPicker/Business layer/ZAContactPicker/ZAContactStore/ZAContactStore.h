//
//  ZAContactStore.h
//  ThangRevisedContactPicker
//
//  Created by Thang on 9/7/2019.
//  Copyright © 2019 ThangNVH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContactStore.h"
#import "ZAContactModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZAContactStore : NSObject

//check current contact authorization status of the app
-(ContactAuthorizationStatus)authorizationStatus;

//request permission to access Contacts
-(void)requestPermissionWithCallBack:(void(^)(BOOL granted,NSError *error))callBack;

//fetch contact from Contacts
//MUST check authorization status first.
-(void)fetchContactWithCallBack:(void(^)(NSArray<ZAContactModel*> *contactArray, NSError *error))callBack;

//-(void)fetchContactWithCallBack:(void(^)(NSDictionary<NSString *,NSArray<ContactModel*> *> *contactDictionary,NSError *error))callBack;

@end

NS_ASSUME_NONNULL_END
