//
//  ContactCollectionViewCell.m
//  ThangRevisedContactPicker
//
//  Created by Thang on 11/7/2019.
//  Copyright © 2019 ThangNVH. All rights reserved.
//

#import "ContactCollectionViewCell.h"

@interface ContactCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *imageNameInitial;


@end


@implementation ContactCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(id<ZAContactCellViewModelProtocol>)model {
    _model = model;
    
    UIImage *cachedImage = [CustomCache.sharedInstance getImageWithID:_model.identifier];
    if (cachedImage){
        _imageNameInitial.image = cachedImage;
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
        _imageNameInitial.image = UIGraphicsGetImageFromCurrentImageContext();
        [CustomCache.sharedInstance setImage:_imageNameInitial.image withIdentifier:_model.identifier];
        UIGraphicsEndImageContext();
    }
}


@end
