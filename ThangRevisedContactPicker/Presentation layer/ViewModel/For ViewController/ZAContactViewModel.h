//
//  ZAContactViewModel.h
//  ThangRevisedContactPicker
//
//  Created by Thang on 10/7/2019.
//  Copyright © 2019 ThangNVH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZAContactCellViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ZAContactViewModelProtocol <NSObject>

@required
- (NSDictionary *)contactDictionary;
//@property (nonatomic, readonly) NSDictionary *contactDictionary;

@end


@interface ZAContactViewModel : NSObject <ZAContactViewModelProtocol>

//@property (nonatomic, readonly) NSDictionary *contactDictionary;

- (void)addCellViewModel:(ZAContactCellViewModel *)model;
- (NSDictionary *)contactDictionary;

@end

NS_ASSUME_NONNULL_END
