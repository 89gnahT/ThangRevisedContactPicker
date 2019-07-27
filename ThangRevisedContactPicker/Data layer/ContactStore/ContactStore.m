//
//  ContactStore.m
//  ThangRevisedContactPicker
//
//  Created by Thang on 9/7/2019.
//  Copyright © 2019 ThangNVH. All rights reserved.
//

#import "ContactStore.h"

@interface ContactStore()

@property (nonatomic) NSMutableDictionary *callBackDictionary;
@property (nonatomic) NSMutableArray<dispatch_queue_t> *queueArray;
@property (nonatomic) BOOL busyFetching;
@property (nonatomic) dispatch_queue_t serialQueue;

@end

@implementation ContactStore

+ (instancetype)sharedInstance{
    static ContactStore *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init{
    if (self == [super init]){
        _callBackDictionary = [[NSMutableDictionary alloc]init];
        _queueArray         = [[NSMutableArray alloc]init];
        _serialQueue        = dispatch_queue_create("Outer serial fetching queue", DISPATCH_QUEUE_SERIAL);
        _busyFetching       = NO;
    }
    return self;
}


-(ContactAuthorizationStatus)authorizationStatus{
    switch([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts]){
        case CNAuthorizationStatusNotDetermined:
            return ContactStatusNotDetermined;
        case CNAuthorizationStatusRestricted:
            return ContactStatusRestricted;
        case CNAuthorizationStatusDenied:
            return ContactStatusDenied;
        case CNAuthorizationStatusAuthorized:
            return ContactStatusAuthorized;
    }
}

-(void)requestPermissionWithCallBack:(void (^)(BOOL, NSError * _Nullable))callBack{
    CNContactStore *store = [[CNContactStore alloc] init];
    [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        callBack(granted, error);
    }];
}

- (void)fetchContactWithCallBack:(void (^)(NSArray<ContactModel *> * _Nullable, NSError * _Nullable))callback
                        onQueue:(nonnull dispatch_queue_t)currentQueue {
    
    if ((callback)&&(currentQueue)){
        dispatch_async(_serialQueue, ^{
            const char *labelQueue = dispatch_queue_get_label(currentQueue);
            NSString* queueName    = [[NSString alloc]initWithFormat:@"%s",labelQueue];
            if([self.queueArray containsObject:currentQueue]){
                [self.callBackDictionary[queueName] addObject:callback];
            } else{
                [self.queueArray addObject:currentQueue];
                [self.callBackDictionary  setObject:[[NSMutableArray alloc]init] forKey:queueName];
                [self.callBackDictionary[queueName] addObject:callback];
            }
            if(!self.busyFetching){
                self.busyFetching = YES;
                dispatch_async(dispatch_queue_create("Concurrent fetching contact queue", DISPATCH_QUEUE_CONCURRENT), ^{
                    if([CNContactStore class]) {
                        CNContactStore *store =  [[CNContactStore alloc]init];
                        NSArray* keys = [self arrayKey];
                        NSPredicate *predicate = [CNContact predicateForContactsInContainerWithIdentifier:store.defaultContainerIdentifier];
                        NSError *error;
                        NSArray *cnContacts = [store unifiedContactsMatchingPredicate:predicate keysToFetch:keys error:&error];
                        NSLog(@"HIT DB");
                        if (error){
                            [self forwardAllWithContactArray:nil error:error];
                        } else {
                            NSMutableArray *contactArray = [[NSMutableArray alloc] init];
                            for (CNContact *contact in cnContacts) {
                                if([contact.phoneNumbers count]!=0){
                                    ContactModel *newContactModel = [[ContactModel alloc] initWithCNContact:contact];
                                    [contactArray addObject:newContactModel];
                                }
                            }
                            [self forwardAllWithContactArray:contactArray error:nil];
                        }
                    }
                });
                //NSLog(@"fetch for 1 times");
            }
        });
    } else {
        NSLog(@"Can't pass nil queue and callBack");
    }
}

-(void)forwardAllWithContactArray:(NSArray*)contactArray error:(NSError*)error{
    
    for (int i =0; i< _queueArray.count; ++i){
        dispatch_queue_t indexQueue = _queueArray[i];
        const char *labelQueue   = dispatch_queue_get_label(indexQueue);
        NSString* indexQueueName = [[NSString alloc]initWithFormat:@"%s",labelQueue];
        NSArray *arrayCallback = _callBackDictionary[indexQueueName];
//        for (id(^callback)(NSArray<ContactModel *> *contactArray, NSError *error) in _callBackDictionary[indexQueueName]){
        for(int j = 0; j < [arrayCallback count]; ++j){
            dispatch_async(indexQueue, ^{
                //
                id(^callback)(NSArray<ContactModel *> *,NSError *) = arrayCallback[j];
                callback(contactArray,error);
            });
        }
        //reset state
        self.busyFetching = NO;
        [self.queueArray removeAllObjects];
        [self.callBackDictionary removeAllObjects];
    }
}

//OLD method
//- (void)fetchContactWithCallBack:(void (^)(NSArray<ContactModel *> * _Nullable, NSError * _Nullable))callBack{
//    dispatch_async(dispatch_queue_create("Concurrent fetching contact queue", DISPATCH_QUEUE_CONCURRENT), ^{
//        if([CNContactStore class]) {
//            CNContactStore *store =  [[CNContactStore alloc]init];
//            NSArray* keys = [self arrayKey];
//            NSPredicate *predicate = [CNContact predicateForContactsInContainerWithIdentifier:store.defaultContainerIdentifier];
//            NSError *error;
//            NSArray *cnContacts = [store unifiedContactsMatchingPredicate:predicate keysToFetch:keys error:&error];
//            if (error){
//                callBack(nil, error);
//            } else {
//                NSMutableArray *contactArray = [[NSMutableArray alloc] init];
//                for (CNContact *contact in cnContacts) {
//                    ContactModel *newContactModel = [[ContactModel alloc] initWithCNContact:contact];
//                    [contactArray addObject:newContactModel];
//                }
//                callBack(contactArray, nil);
//            }
//        }
//    });
//    
//}

//Helper functions

-(NSArray*)arrayKey{
    return @[CNContactIdentifierKey,
             CNContactFamilyNameKey,
             CNContactMiddleNameKey,
             CNContactGivenNameKey,
             CNContactNameSuffixKey,
             CNContactPhoneNumbersKey];
}


@end
