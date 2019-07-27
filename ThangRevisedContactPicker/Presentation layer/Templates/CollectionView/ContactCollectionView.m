//
//  ContactCollectionView.m
//  ThangRevisedContactPicker
//
//  Created by Thang on 11/7/2019.
//  Copyright © 2019 ThangNVH. All rights reserved.
//

#import "ContactCollectionView.h"

@interface ContactCollectionView()

@property (weak, nonatomic) UICollectionView *contactCollectionView;

@property (nonatomic) NSArray<id<ZAContactCellViewModelProtocol>> *pickedContactArray;
@property (nonatomic) BOOL isLoaded;

@end


@implementation ContactCollectionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setUpCommon];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpCommon];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setUpCommon];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setUpCommon];
}

- (void)didMoveToWindow {
    if (self.window)
    {
        if (!self.isLoaded)
        {
            [self reloadData];
            self.isLoaded = YES;
        }
    }
}

-(void)setUpCommon{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 1;
    layout.sectionInset = UIEdgeInsetsMake(5, 10, 5, 0);
    layout.itemSize = CGSizeMake(60, 60);
    //    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    collectionView.dataSource = self;
    collectionView.delegate   = self;
    
    collectionView.allowsSelection = YES;
    collectionView.backgroundColor = [UIColor whiteColor];
    UINib *nib = [UINib nibWithNibName:@"ContactCollectionViewCell" bundle:nil];
    [collectionView registerNib:nib forCellWithReuseIdentifier:@"ContactCollectionViewCell"];
    collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [collectionView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self addSubview:collectionView];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[collectionView]|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(collectionView)]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[collectionView]|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(collectionView)]];
    _contactCollectionView = collectionView;
}

- (void)reloadData
{
    if ([_dataSource respondsToSelector:@selector(pickedContactArrayForCPContactCollectionView:)])
    {
        _pickedContactArray = [_dataSource pickedContactArrayForCPContactCollectionView:self];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.contactCollectionView reloadData];
    });
}

//CollectionView
//dataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [_pickedContactArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ContactCollectionViewCell *contactCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ContactCollectionViewCell" forIndexPath:indexPath];
    
    ZAContactCellViewModel *model = [_pickedContactArray objectAtIndex:indexPath.row];
    if (!contactCell){
        return [[ContactCollectionViewCell alloc]init];
    }
    [contactCell setModel:model];
    return contactCell;
}

//delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([_delegate respondsToSelector:@selector(collectionView:didSelectContactViewModel:)]){
        [_delegate collectionView:self didSelectContactViewModel:_pickedContactArray[indexPath.item]];
    }
}

@end
