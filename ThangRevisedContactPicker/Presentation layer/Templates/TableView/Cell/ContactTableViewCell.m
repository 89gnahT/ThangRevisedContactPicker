//
//  ContactTableViewCell.m
//  ThangRevisedContactPicker
//
//  Created by Thang on 10/7/2019.
//  Copyright © 2019 ThangNVH. All rights reserved.
//

#import "ContactTableViewCell.h"

@interface ContactTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *labelFullName;
@property (weak, nonatomic) IBOutlet UIImageView *imageInitial;

@end

@implementation ContactTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setModel:(id<ZAContactCellViewModelProtocol>)model{
    _model = model;
    
    _labelFullName.text    = _model.fullName;
    
    // cachedLabel = myCache getLableWithId: _model.id
    // if(cachedLabel) { labelNameInitial = cachedLabel}
    // else{ //1.create label //2. myCache storeLabel:_init.. withId:_model.id}
    //NSLog(@"%@",_model.identifier);
    UIImage *cachedImage = [CustomCache.sharedInstance getImageWithID:_model.identifier];
    if (cachedImage){
        //NSLog(@"load cached");
        _imageInitial.image = cachedImage;
    } else {
        CGRect frame = CGRectMake(0, 0, 60, 60);
        UILabel *labelNameInitial = [[UILabel alloc] initWithFrame:frame];
        labelNameInitial.text          = _model.nameInitial;
        labelNameInitial.textAlignment = NSTextAlignmentCenter;
        labelNameInitial.textColor     = [UIColor whiteColor];
        labelNameInitial.backgroundColor     = _model.labelColor;
        labelNameInitial.layer.shadowColor   = [[UIColor blackColor] CGColor];
        labelNameInitial.layer.shadowOffset  = CGSizeMake(0.0f, 0.0f);
        labelNameInitial.layer.shadowOpacity = 0.5f;
        labelNameInitial.layer.shadowRadius  = 1.0f;
        labelNameInitial.layer.cornerRadius  = labelNameInitial.layer.frame.size.width/2;
        labelNameInitial.clipsToBounds = YES;
        UIGraphicsBeginImageContextWithOptions(labelNameInitial.bounds.size, false, 0.0);
        [[labelNameInitial layer] renderInContext:UIGraphicsGetCurrentContext()];
        _imageInitial.image = UIGraphicsGetImageFromCurrentImageContext();
        [CustomCache.sharedInstance setImage:_imageInitial.image withIdentifier:_model.identifier];
        UIGraphicsEndImageContext();
    }
    
    
}

@end
