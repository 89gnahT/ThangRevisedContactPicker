//
//  ZAContactStore.m
//  ThangRevisedContactPicker
//
//  Created by Thang on 9/7/2019.
//  Copyright © 2019 ThangNVH. All rights reserved.
//

#import "ZAContactStore.h"

@interface ZAContactStore()

@property (nonatomic) dispatch_queue_t serialBusinessContactPickerQueue;

@end


@implementation ZAContactStore

- (instancetype)init{
    self = [super init];
    if(self){
        _serialBusinessContactPickerQueue = dispatch_queue_create("Serial business contact picker queue", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (ContactAuthorizationStatus)authorizationStatus{
    return [ContactStore.sharedInstance authorizationStatus];
}

- (void)requestPermissionWithCallBack:(void (^)(BOOL, NSError * _Nullable))callBack{
    [ContactStore.sharedInstance requestPermissionWithCallBack:^(BOOL granted, NSError * _Nullable error) {
        callBack(granted, error);
    }];
}

-(void)fetchContactWithCallBack:(void (^)(NSArray<ZAContactModel *> * _Nullable, NSError * _Nullable))callBack{
    dispatch_async(_serialBusinessContactPickerQueue, ^{
        [ContactStore.sharedInstance fetchContactWithCallBack:^(NSArray<ContactModel *> * _Nullable contactArray, NSError * _Nullable error) {
            if(error){
                dispatch_async(dispatch_get_main_queue(), ^{
                    callBack(nil,error);
                });
            } else {
                NSMutableArray *businessContactArray = [[NSMutableArray alloc] init];
                for(ContactModel *indexModel in contactArray){
                    ZAContactModel *newContact = [[ZAContactModel alloc]initWithContactModel:indexModel];
                    [businessContactArray addObject:newContact];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    callBack(businessContactArray,nil);
                });
            }
        } onQueue:self.serialBusinessContactPickerQueue];
        
    });
}

//- (void)fetchContactWithCallBack:(void (^)(NSDictionary<NSString *,NSArray<ContactModel *> *> * _Nullable, NSError * _Nullable))callBack{
//    [ContactStore.sharedInstance fetchContactWithCallBack:^(NSArray<ContactModel *> * _Nonnull contactArray, NSError * _Nonnull error) {
//        if(error){
//            callBack(nil,error);
//        } else {
//            NSMutableDictionary *contactDictionary = [[NSMutableDictionary alloc]init];
//            for (ContactModel *indexContact in contactArray){
//                ZAContactModel *newContact = [[ZAContactModel alloc]initWithContactModel:indexContact];
//                //TODO fix logic sectionKey
//                NSString *sectionKey;
//                NSString *nameInitial = newContact.firstName;
//                switch ([nameInitial length]){
//                    case 2:
//                        sectionKey = [nameInitial substringWithRange:NSMakeRange(1, 1)];
//                        break;
//                    case 1:
//                        sectionKey = nameInitial;
//                        break;
//                }
//                if([contactDictionary valueForKey:sectionKey]){
//                    [[contactDictionary valueForKey:sectionKey] addObject:newContact];
//                } else {
//                    NSMutableArray *newSectionArray = [[NSMutableArray alloc] init];
//                    [contactDictionary setObject:newSectionArray forKey:sectionKey];
//                    [[contactDictionary valueForKey:sectionKey]addObject:newContact];
//                }
//            }
//            callBack(contactDictionary,nil);
//        }
//    }];
//}

@end
