//
//  ContactTableView.h
//  ThangRevisedContactPicker
//
//  Created by Thang on 10/7/2019.
//  Copyright © 2019 ThangNVH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactTableViewCell.h"
#import "ZAContactViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@class ContactTableView;


@protocol ContactTableViewDataSource <NSObject>

@required
-(NSDictionary<NSString *,NSArray<id<ZAContactCellViewModelProtocol>> *> *)contactDictionaryForContactTableView:(ContactTableView *)contactTableView;
-(NSArray<id<ZAContactCellViewModelProtocol>> *)pickedContactArrayForContactTableView:(ContactTableView *)contactTableView;
@end


@protocol ContactTableViewDelegate <NSObject>

@optional
-(void)tableView:(ContactTableView*)contactTableView didSelectContactViewModel:(id<ZAContactCellViewModelProtocol>)model;
-(void)tableView:(ContactTableView*)contactTableView didDeSelectContactViewModel:(id<ZAContactCellViewModelProtocol>)model;
-(void)willPassLimitationTableView:(ContactTableView*)contactTableView;
@end


@interface ContactTableView : UIView<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) id<ContactTableViewDataSource> dataSource;
@property (nonatomic, weak) id<ContactTableViewDelegate>   delegate;

-(void)reloadData;
-(void)jumpToContact:(id<ZAContactCellViewModelProtocol>)model;

@end

NS_ASSUME_NONNULL_END
