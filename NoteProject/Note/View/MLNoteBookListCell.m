//
//  MLNoteBookListCell.m
//  NoteProject
//
//  Created by liby on 2018/6/12.
//  Copyright © 2018年 liby. All rights reserved.
//

#import "MLNoteBookListCell.h"

@implementation MLNoteBookListCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    UIView *cellBlack = [[UIView alloc] init];
//    cellBlack.backgroundColor = [UIColor whiteColor];
////    cellBlack.H -= 1;
//    self.selectedBackgroundView = cellBlack;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setModel:(MLNoteBaseModel *)model {
    _model = model;
    if (model.modelType == MLModelGroup) {// 笔记本组
        MLNoteBookGroup *tempModel = ((MLNoteBookGroup *)model);
        self.imgV.image = [UIImage imageNamed:@"Ios_Stack_S_24"];
        self.countLab.hidden = YES;
        self.caretDownBtn.hidden = NO;
        self.titleLab.text = tempModel.titleName;
        if (tempModel.isSelect) {
            self.caretDownBtn.transform = CGAffineTransformMakeRotation(180.1 * M_PI/180.0);
        } else {
            self.caretDownBtn.transform = CGAffineTransformIdentity;
        }
    } else if (model.modelType == MLModelBook) {// 笔记本
        MLNoteBook *tempModel = ((MLNoteBook *)model);
        if (tempModel.bookType == MLBookDele) {//废纸篓
            self.imgV.image = [UIImage imageNamed:@"Ios_Trash_S_24"];
        } else {
            self.imgV.image = [UIImage imageNamed:@"Ios_StackIcon_24"];
        }
        self.countLab.hidden = NO;
        self.countLab.text = [NSString stringWithFormat:@"(%ld)", tempModel.noteArr.count];
        self.caretDownBtn.hidden = YES;
        self.titleLab.text = tempModel.titleName;
    }
    self.imgV.tintColor = MLColor(122, 128, 131);
    [self layoutIfNeeded];
}

- (void)setIsInGroup:(BOOL)isInGroup {
    if (isInGroup) {
        self.leftConstraint.constant = 65;
    } else {
        self.leftConstraint.constant = 25;
    }
}

@end
