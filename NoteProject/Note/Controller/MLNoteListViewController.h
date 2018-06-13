//
//  MLNoteListViewController.h
//  NoteProject
//
//  Created by liby on 2018/6/13.
//  Copyright © 2018年 liby. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLNoteListViewController : UIViewController

/** 笔记数组 */
//@property (nonatomic, strong) NSMutableArray <MLNote *>*noteArr;
/** 笔记本 */
@property (nonatomic, strong) MLNoteBook *noteBook;
@end
