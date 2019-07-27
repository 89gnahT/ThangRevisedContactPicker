//
//  ContactCollectionViewCell.h
//  ThangRevisedContactPicker
//
//  Created by Thang on 11/7/2019.
//  Copyright © 2019 ThangNVH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZAContactCellViewModel.h"
#import "CustomCache.h"

NS_ASSUME_NONNULL_BEGIN

@interface ContactCollectionViewCell : UICollectionViewCell

@property (nonatomic) id<ZAContactCellViewModelProtocol> model;

@end

NS_ASSUME_NONNULL_END
