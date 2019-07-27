//
//  ContactTableViewCell.h
//  ThangRevisedContactPicker
//
//  Created by Thang on 10/7/2019.
//  Copyright © 2019 ThangNVH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZAContactCellViewModel.h"
#import "CustomCache.h"

NS_ASSUME_NONNULL_BEGIN

@interface ContactTableViewCell : UITableViewCell

@property (nonatomic) id<ZAContactCellViewModelProtocol> model;

@end

NS_ASSUME_NONNULL_END
