//
//  ContactStore.h
//  ThangRevisedContactPicker
//
//  Created by Thang on 9/7/2019.
//  Copyright © 2019 ThangNVH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContactModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ContactStore : NSObject

typedef NS_ENUM(NSUInteger, ContactAuthorizationStatus) {
    ContactStatusNotDetermined = -1,
    ContactStatusDenied = 0,
    ContactStatusAuthorized = 1,
    ContactStatusRestricted = 2
};

//Singleton contactStore
+(instancetype)sharedInstance;

//check current contact authorization status of the app
-(ContactAuthorizationStatus)authorizationStatus;

//request permission to access Contacts
-(void)requestPermissionWithCallBack:(void(^)(BOOL granted,NSError *error))callBack;

//fetch contact from Contacts
//MUST check authorization status first.
//-(void)fetchContactWithCallBack:(void(^)(NSArray<ContactModel*> *contactArray,NSError *error))callBack;

//fetch contact from Contacts
//MUST check authorization status first.
-(void)fetchContactWithCallBack:(void(^)(NSArray<ContactModel*> *contactArray,NSError *error))callBack
                        onQueue:(dispatch_queue_t)currentQueue;

@end

NS_ASSUME_NONNULL_END
