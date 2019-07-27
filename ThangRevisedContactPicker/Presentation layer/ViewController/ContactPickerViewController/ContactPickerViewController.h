//
//  ContactPickerViewController.h
//  ThangRevisedContactPicker
//
//  Created by Thang on 10/7/2019.
//  Copyright © 2019 ThangNVH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZAContactStore.h"
#import "ContactTableView.h"
#import "ContactCollectionView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ContactPickerViewController : UIViewController<UIAlertViewDelegate,ContactTableViewDataSource,ContactTableViewDelegate,ContactCollectionViewDelegate,ContactCollectionViewDataSource,UISearchBarDelegate>


@end

NS_ASSUME_NONNULL_END
