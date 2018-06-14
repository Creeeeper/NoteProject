//
//  MLNote.h
//  NoteProject
//
//  Created by liby on 2018/6/12.
//  Copyright © 2018年 liby. All rights reserved.
//

#import <Foundation/Foundation.h>

// 基础笔记模型
@interface MLBaseNoteModel : MLBaseModel
/** 标题 */
@property (nonatomic, strong) NSString *titleName;
/** 唯一标识 */
@property (nonatomic, strong, readonly) NSString *UUID;
/** 创建时间 */
@property (nonatomic, strong, readonly) NSDate *date;
/** 显示时间 */
@property (nonatomic, strong) NSString *createTime;

/** 构造方法 */
- (instancetype)initWithTitle:(NSString *)title;
@end


// 笔记
@interface MLNote : MLBaseNoteModel
/** 父标识 */
@property (nonatomic, strong) NSString *parentUUID;
/** 正文 */
@property (nonatomic, strong, readonly) NSString *content;
/** 正文(富文本) */
@property (nonatomic, strong) NSAttributedString *AttContent;
/** 图片字典 */
@property (nonatomic, strong) NSMutableDictionary *picDict;

@end


// 笔记本
@interface MLNoteBook : MLBaseNoteModel
/** 父标识 */
@property (nonatomic, strong) NSString *parentUUID;
/** 笔记数组 */
//@property (nonatomic, strong) NSMutableArray <MLNote *>*noteArr;
/** 笔记字典 */
@property (nonatomic, strong) NSMutableDictionary *noteDict;

/** 添加笔记 */
- (MLNote *)addNote:(MLNote *)model;
/** 添加笔记 */
- (MLNote *)removeNote:(MLNote *)model;
@end


// 笔记本组
@interface MLNoteBookGroup : MLBaseNoteModel
/** 笔记本数组 */
//@property (nonatomic, strong) NSMutableArray <MLNoteBook *>*noteBookArr;
/** 笔记本字典 */
@property (nonatomic, strong) NSMutableDictionary *noteBookDict;

/** 添加笔记本 */
- (MLNoteBook *)addNoteBook:(MLNoteBook *)model;
/** 移除笔记本 */
- (MLNoteBook *)removeNoteBook:(MLNoteBook *)model;
@end






