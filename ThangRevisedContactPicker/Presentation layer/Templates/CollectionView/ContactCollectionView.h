//
//  ContactCollectionView.h
//  ThangRevisedContactPicker
//
//  Created by Thang on 11/7/2019.
//  Copyright © 2019 ThangNVH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactCollectionViewCell.h"
#import "ZAContactViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@class ContactCollectionView;

@protocol ContactCollectionViewDataSource <NSObject>

- (NSArray<id<ZAContactCellViewModelProtocol>> *)pickedContactArrayForCPContactCollectionView:(ContactCollectionView*)contactCollectionView;
@end

@protocol ContactCollectionViewDelegate <NSObject>

@optional
- (void)collectionView:(ContactCollectionView*)contactCollectionView didSelectContactViewModel:(id<ZAContactCellViewModelProtocol>)model;
@end


@interface ContactCollectionView : UIView<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, weak) id<ContactCollectionViewDataSource> dataSource;
@property (nonatomic, weak) id<ContactCollectionViewDelegate>   delegate;

- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
