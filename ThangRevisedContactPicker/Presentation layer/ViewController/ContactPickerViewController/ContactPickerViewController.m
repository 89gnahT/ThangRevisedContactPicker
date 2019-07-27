//
//  ContactPickerViewController.m
//  ThangRevisedContactPicker
//
//  Created by Thang on 10/7/2019.
//  Copyright © 2019 ThangNVH. All rights reserved.
//

#import "ContactPickerViewController.h"

@interface ContactPickerViewController ()
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonSendSMS;
@property (weak, nonatomic) IBOutlet ContactTableView *contactTableView;
@property (weak, nonatomic) IBOutlet ContactCollectionView *contactCollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightCollectionView;
@property (weak, nonatomic) IBOutlet UISearchBar *contactSearchBar;

@property (nonatomic) UILabel *labelPickedContact;

@property (nonatomic) ZAContactViewModel *contactViewModel;
@property (nonatomic) NSMutableArray     *pickedContactArray;
@property (nonatomic) BOOL isInSearchMode;
@property (nonatomic) ZAContactViewModel *contactViewModelInSeachMode;

@end

@implementation ContactPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
    [self setUpData];
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self fetchData];
//    });

}
//Observer
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setUpData) name:CNContactStoreDidChangeNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CNContactStoreDidChangeNotification object:nil];
}

//Data

- (void)setUpData {
    _isInSearchMode = NO;
    _pickedContactArray = [[NSMutableArray alloc] init];
    _contactViewModel   = [[ZAContactViewModel alloc] init];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self fetchData];
    });
}

- (void)fetchData {
    ZAContactStore *store = [[ZAContactStore alloc]init];
    switch ([store authorizationStatus]){
        case ContactStatusNotDetermined:{
            [store requestPermissionWithCallBack:^(BOOL granted, NSError * _Nonnull error) {
                if(granted){
                    NSLog(@"Permission granted");
                    [self fetchViewModelWithStore:store];
                }
                if(error){
                    NSLog(@"Permisison denied: %@",error);
                    [self displayDeniedAlert];
                }
            }];
            break;
        }
        case ContactStatusDenied:{
            NSLog(@"Permission denied");
            [self displayDeniedAlert];
            break;
        }
        case ContactStatusAuthorized: {
            NSLog(@"Permission granted");
            [self fetchViewModelWithStore:store];
            break;
        }
        case ContactStatusRestricted:{
            NSLog(@"Permission restricted");
            [self displayDeniedAlert];
            break;
        }
    }
}

- (void)fetchViewModelWithStore:(ZAContactStore *)store {
    
    [store fetchContactWithCallBack:^(NSArray<ZAContactModel *> *contactArray, NSError *error) {
        if(error){
            NSLog(@"Error fetching data from store");
        } else {
            NSLog(@"fetched success");
            for (ZAContactModel *indexModel in contactArray){
                ZAContactCellViewModel *newCellViewModel = [[ZAContactCellViewModel alloc] initWithContactPickerModel:indexModel];
                [self.contactViewModel addCellViewModel:newCellViewModel];
            }
            // reload:
            
            [self.contactTableView reloadData];
        }
    }];
}

//UI
- (void)setUpUI {
    _contactTableView.dataSource = self;
    _contactTableView.delegate   = self;
    
    _contactCollectionView.dataSource = self;
    _contactCollectionView.delegate   = self;
    _heightCollectionView.constant = 0;
    
    _contactSearchBar.delegate = self;
    [_contactSearchBar setPlaceholder:@"Search"];
    
    [self setUpSubViewNavigationBar];
    
    _buttonSendSMS.enabled = NO;
}

//NavigationBar
- (void)setUpSubViewNavigationBar {
    UIView *navBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 22)];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"Contact Picker";
    title.adjustsFontSizeToFitWidth = true;
    [navBarView addSubview:title];
    _labelPickedContact = [[UILabel alloc] initWithFrame:CGRectMake(0, 22, 100, 22)];
    _labelPickedContact.text = @"Picked: 0";
    _labelPickedContact.textColor = [UIColor grayColor];
    _labelPickedContact.textAlignment = NSTextAlignmentCenter;
    _labelPickedContact.adjustsFontSizeToFitWidth = true;
    [navBarView addSubview:_labelPickedContact];
    
    _navigationBar.topItem.titleView = navBarView;
}

- (void)updateLabelPickedContact {
    [UIView animateWithDuration:0.1 delay:0.02 options:UIViewAnimationOptionAutoreverse animations:^{
        self.labelPickedContact.transform = CGAffineTransformScale(self.labelPickedContact.transform, 1.2, 1.2);
        self.labelPickedContact.text = [[NSString alloc] initWithFormat:@"Picked: %lu", self.pickedContactArray.count];
    } completion:^(BOOL finished) {
        self.labelPickedContact.transform = CGAffineTransformIdentity;
    }];
}

- (IBAction)onButtonBackClicked:(id)sender {
    [_pickedContactArray removeAllObjects];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onButtonSendSMSClicked:(id)sender {
    NSMutableString *message = [[NSMutableString alloc] initWithString:@"Send invitation to "];
    NSUInteger count = [_pickedContactArray count];
    for (ZAContactCellViewModel *indexContact in _pickedContactArray){
        if(count == 1) {
            [message appendFormat:@"%@.",indexContact.fullName];
            break;
        } else{
            [message appendFormat:@"%@, ",indexContact.fullName];
        }
        count--;
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Send messages"
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];
    [alertController addAction:actionOk];
    [self presentViewController:alertController animated:YES completion:nil];
}

//TableView

//DataSource
- (NSDictionary<NSString *,NSArray<id<ZAContactCellViewModelProtocol>> *> *)contactDictionaryForContactTableView:(nonnull ContactTableView *)contactTableView {
    if (_isInSearchMode){
        return [_contactViewModelInSeachMode contactDictionary];
    }
    return [_contactViewModel contactDictionary];
}

- (NSArray<id<ZAContactCellViewModelProtocol>> *)pickedContactArrayForContactTableView:(nonnull ContactTableView *)contactTableView {
    return _pickedContactArray;
}

//Delegate
- (void)tableView:(ContactTableView *)contactTableView didSelectContactViewModel:(id<ZAContactCellViewModelProtocol>)model {
    [_pickedContactArray addObject:model];
    //[self setUpSubViewNavigationBar];
    [self updateLabelPickedContact];
    _buttonSendSMS.enabled = YES;
    _heightCollectionView.constant = 70;
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    }];
    [_contactCollectionView reloadData];
}

- (void)tableView:(ContactTableView *)contactTableView didDeSelectContactViewModel:(id<ZAContactCellViewModelProtocol>)model {
    [_pickedContactArray removeObject:model];
    [self updateLabelPickedContact];
    //[self setUpSubViewNavigationBar];
    if ([_pickedContactArray count]==0){
        _buttonSendSMS.enabled = NO;
        _heightCollectionView.constant = 0;
        [self.view endEditing:YES];
        [UIView animateWithDuration:0.2 animations:^{
            [self.view layoutIfNeeded];
        }];
    }
    [_contactCollectionView reloadData];
}

- (void)willPassLimitationTableView:(ContactTableView *)contactTableView {
    if ([_pickedContactArray count]== 5){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Limitation reach"
                                                                                 message:@"Can't invite more than 5 people at a time"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil];
        [alertController addAction:actionOk];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

//CollectionView

//DataSource
- (NSArray<id<ZAContactCellViewModelProtocol>> *)pickedContactArrayForCPContactCollectionView:(ContactCollectionView *)contactCollectionView {
    return _pickedContactArray;
}

//Delegate
- (void)collectionView:(ContactCollectionView *)contactCollectionView didSelectContactViewModel:(id<ZAContactCellViewModelProtocol>)model {
    if(_isInSearchMode){
        _isInSearchMode = NO;
        _contactSearchBar.text = nil;
        [_contactTableView reloadData];
    }
    [_contactTableView jumpToContact:model];
    [self.view endEditing:YES];
}

//SearchBar
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if ([searchText length] == 0) {
        _isInSearchMode = NO;
        //[self.view endEditing:YES];
    } else {
        _isInSearchMode = YES;
        _contactViewModelInSeachMode = [[ZAContactViewModel alloc] init];
        NSDictionary *contactDictionary = [_contactViewModel contactDictionary];
        for (NSString *sectionKey in  [contactDictionary allKeys]){
            for (ZAContactCellViewModel *contact in [contactDictionary objectForKey:sectionKey]) {
                NSString* currentName = contact.fullName;
                NSRange nameRange = [currentName rangeOfString:searchText options:NSCaseInsensitiveSearch];
                if (nameRange.location != NSNotFound){
                    [_contactViewModelInSeachMode addCellViewModel:contact];
                }
            }
        }
    }
    [_contactTableView reloadData];
}

//Denied Alert
-(void)displayDeniedAlert{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Warning!!"
                                                                             message:@"This app needs permission to access Contacts.\nPlease enable it in Settings."
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];
    [alertController addAction:actionOk];
    [self presentViewController:alertController animated:YES completion:nil];
}


@end
