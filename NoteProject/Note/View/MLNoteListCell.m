//
//  MLNoteListCell.m
//  NoteProject
//
//  Created by liby on 2018/6/13.
//  Copyright © 2018年 liby. All rights reserved.
//

#import "MLNoteListCell.h"

@implementation MLNoteListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupUIWithModel:(MLNote *)model {
    // 必有
    self.titleLab.text = model.titleName;
    self.dateLab.text = model.createTime;
    // 可选
    if (model.content) {
        self.contentLab.text = model.content;
        self.titleToContent.constant = 5;
    } else {
        self.contentLab.text = nil;
        self.titleToContent.constant = 0;
    }
    if (model.picDict.count) {
        self.imgViewH.constant = (kWidth - 60) / 3 * 0.645;
        self.imgViewBottom.constant = 10;
        switch (model.picDict.count) {
            default:
            case 3: {
                self.imgV3.image = [UIImage imageWithData:model.picDict.allValues[2]];
            }
            case 2: {
                self.imgV2.image = [UIImage imageWithData:model.picDict.allValues[1]];
            }
            case 1: {
                self.imgV1.image = [UIImage imageWithData:model.picDict.allValues[0]];
            }
        }
    } else {
        self.imgViewH.constant = 0;
        self.imgViewBottom.constant = 0;
        self.imgV1.image = nil;
        self.imgV2.image = nil;
        self.imgV3.image = nil;
    }
}

@end
