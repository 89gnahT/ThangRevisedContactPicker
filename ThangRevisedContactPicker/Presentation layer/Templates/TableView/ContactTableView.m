//
//  ContactTableView.m
//  ThangRevisedContactPicker
//
//  Created by Thang on 10/7/2019.
//  Copyright © 2019 ThangNVH. All rights reserved.
//

#import "ContactTableView.h"

@interface ContactTableView()

@property (weak, nonatomic) UITableView *contactTableView;

@property (nonatomic) NSDictionary<NSString *, NSArray<id<ZAContactCellViewModelProtocol>> *> *contactDictionary;
@property (nonatomic) BOOL isLoaded;
@property (nonatomic) NSArray<NSString *> *sectionArray;

@property (nonatomic) NSArray<id<ZAContactCellViewModelProtocol>> *pickedContactArray;

@end

@implementation ContactTableView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUpCommon];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpCommon];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setUpCommon];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setUpCommon];
}

-(void)setUpCommon {
    UITableView *tmpTableView = [[UITableView alloc]initWithFrame:self.bounds];
    [self addSubview:tmpTableView];
    [tmpTableView setEditing:YES];
    tmpTableView.dataSource = self;
    tmpTableView.delegate = self;
    
    tmpTableView.rowHeight = 80;
    tmpTableView.clipsToBounds = YES;
    tmpTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    tmpTableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    UINib *nib = [UINib nibWithNibName:@"ContactTableViewCell" bundle:nil];
    [tmpTableView registerNib:nib forCellReuseIdentifier:@"ContactTableViewCell"];
    [tmpTableView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];

    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[tmpTableView]|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(tmpTableView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tmpTableView]|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(tmpTableView)]];
    _contactTableView = tmpTableView;
}

- (void)didMoveToWindow{
    if (self.window)
    {
        if (!self.isLoaded)
        {
            [self reloadData];
            self.isLoaded = YES;
        }
    }
}

-(void)reloadData{
    if ([_dataSource respondsToSelector:@selector(contactDictionaryForContactTableView:)]){
        _contactDictionary = [_dataSource contactDictionaryForContactTableView:self];
        NSMutableArray *tmpSectionArray = [[NSMutableArray alloc] initWithArray:[_contactDictionary allKeys]];
        _sectionArray = [tmpSectionArray sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    }
    if ([_dataSource respondsToSelector:@selector(pickedContactArrayForContactTableView:)]){
        _pickedContactArray = [_dataSource pickedContactArrayForContactTableView:self];
    }
    [self.contactTableView reloadData];
}

-(void)jumpToContact:(id<ZAContactCellViewModelProtocol>)model {
    for (int i = 0; i < [_sectionArray count];++i){
        NSArray *contactArray = _contactDictionary[_sectionArray[i]];
        for(int row = 0; row < [contactArray count]; row++) {
            if ([model isEqual:contactArray[row]]) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:i];
                [_contactTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
                return;
            }
        }
    }
}

//Table DataSource
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return _sectionArray;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return _sectionArray[section];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([_sectionArray count]==0) {
        [self displayEmptyView];
        return 0;
    } else {
        [self hideEmptyView];
        return [_sectionArray count];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[_contactDictionary valueForKey:_sectionArray[section]] count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactTableViewCell" forIndexPath:indexPath];
    ZAContactCellViewModel *model = [_contactDictionary objectForKey:_sectionArray[indexPath.section]][indexPath.row];
    [cell setModel:model];
    
    if ([_pickedContactArray containsObject:model]){
        [_contactTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    return cell;
}

//Table Delegate

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return 3;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZAContactCellViewModel *pickedContact =[_contactDictionary valueForKey:_sectionArray[indexPath.section]][indexPath.row];
    if ([self.delegate respondsToSelector:@selector(tableView:didSelectContactViewModel:)]) {
        [self.delegate tableView:self didSelectContactViewModel:pickedContact];
        NSLog(@"select %lu",(unsigned long)[_pickedContactArray count]);
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZAContactCellViewModel *pickedContact =[_contactDictionary valueForKey:_sectionArray[indexPath.section]][indexPath.row];
    if ([self.delegate respondsToSelector:@selector(tableView:didDeSelectContactViewModel:)]) {
        [self.delegate tableView:self didDeSelectContactViewModel:pickedContact];
        NSLog(@"deselect %lu",(unsigned long)[_pickedContactArray count]);
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([_pickedContactArray count]==5){
        [self.delegate willPassLimitationTableView:self];
        return nil;
    }
    return indexPath;
}

//TableView EmptyView

- (void)displayEmptyView {
    CGRect rect = CGRectMake(0, 0, _contactTableView.bounds.size.width, _contactTableView.bounds.size.height);
    UILabel *messageLabel = [[UILabel alloc]initWithFrame:rect];
    messageLabel.text = @"No contacts found";
    messageLabel.textColor = [UIColor blackColor];
    messageLabel.numberOfLines = 0;
    messageLabel.textAlignment = NSTextAlignmentCenter;
    [messageLabel sizeToFit];
    _contactTableView.backgroundView = messageLabel;
    _contactTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)hideEmptyView {
    _contactTableView.backgroundView = nil;
}

@end
