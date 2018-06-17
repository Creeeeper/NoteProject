//
//  MLNoteListCell.h
//  NoteProject
//
//  Created by liby on 2018/6/13.
//  Copyright © 2018年 liby. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLNoteListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UIImageView *imgV1;
@property (weak, nonatomic) IBOutlet UIImageView *imgV2;
@property (weak, nonatomic) IBOutlet UIImageView *imgV3;
@property (weak, nonatomic) IBOutlet UIView *imgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgViewH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleToContent;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgViewBottom;

@property (nonatomic, strong) MLNote *model;


@end
