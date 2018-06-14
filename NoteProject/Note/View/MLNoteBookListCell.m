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
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupUIWithModel:(MLBaseNoteModel *)model {
    self.leftConstraint.constant = 25;
    if ([model isKindOfClass:[MLNoteBookGroup class]]) {// 笔记本组
        MLNoteBookGroup *tempModel = ((MLNoteBookGroup *)model);
        self.imgV.image = [UIImage imageNamed:@"Ios_Stack_S_24"];
        self.countLab.hidden = YES;
        self.caretDownBtn.hidden = NO;
        self.titleLab.text = tempModel.titleName;
    } else if ([model isKindOfClass:[MLNoteBook class]]) {// 笔记本
        MLNoteBook *tempModel = ((MLNoteBook *)model);
        if (tempModel.parentUUID) {
            self.leftConstraint.constant = 65;
        }
        self.imgV.image = [UIImage imageNamed:@"Ios_StackIcon_24"];
        
        self.countLab.hidden = NO;
        self.countLab.text = [NSString stringWithFormat:@"(%ld)", tempModel.noteDict.count];
        self.caretDownBtn.hidden = YES;
        self.titleLab.text = tempModel.titleName;
    }
    self.imgV.tintColor = MLColor(122, 128, 131);
    [self layoutIfNeeded];
}

@end
