//
//  ZAContactViewModel.m
//  ThangRevisedContactPicker
//
//  Created by Thang on 10/7/2019.
//  Copyright © 2019 ThangNVH. All rights reserved.
//

#import "ZAContactViewModel.h"

@interface ZAContactViewModel()

@property (nonatomic) NSMutableDictionary *contactDictionary;

@end

@implementation ZAContactViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _contactDictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)addCellViewModel:(ZAContactCellViewModel *)model{
    NSString *sectionKey;
    NSString *nameInitial = model.nameInitial;
    switch ([nameInitial length]){
        case 2:
            sectionKey = [nameInitial substringWithRange:NSMakeRange(1, 1)];
            break;
        case 1:
            sectionKey = nameInitial;
            break;
    }
    if([_contactDictionary valueForKey:sectionKey]){
        [[_contactDictionary valueForKey:sectionKey] addObject:model];
    } else {
        NSMutableArray *newSectionArray = [[NSMutableArray alloc] init];
        [newSectionArray addObject:model];
        [_contactDictionary setObject:newSectionArray forKey:sectionKey];
//        [[_contactDictionary valueForKey:sectionKey]addObject:model];
        
    }}

- (NSDictionary *)contactDictionary {
    return _contactDictionary;
}

@end
