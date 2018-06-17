//
//  MLNoteBookListCell.h
//  NoteProject
//
//  Created by liby on 2018/6/12.
//  Copyright © 2018年 liby. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MLNoteBookListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIButton *caretDownBtn;
@property (weak, nonatomic) IBOutlet UILabel *countLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstraint;

@property (nonatomic, strong) MLNoteBaseModel *model;

@property (nonatomic, assign) BOOL isInGroup;

@end
