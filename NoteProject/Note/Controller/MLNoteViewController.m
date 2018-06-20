//
//  MLNoteViewController.m
//  NoteProject
//
//  Created by liby on 2018/6/14.
//  Copyright © 2018年 liby. All rights reserved.
//

#import "MLNoteViewController.h"
#import "MLNoteBookListViewController.h"
#import "MLNavigationController.h"

@interface MLNoteViewController () <YYTextViewDelegate>
@property (nonatomic, strong) YYTextView *textView;

@end

@implementation MLNoteViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.textView resignFirstResponder];
    if (self.bookType == MLBookNormal) {
        self.note.AttContent = self.textView.attributedText;
        self.note.titleName = self.navigationItem.title;
//        [self.manager updateNoteModel:self.note fFloor:self.fFloor sFloor:self.sFloor tFloor:self.tFloor complete:^(BOOL succeed) {
//            if (succeed) {
//                [[NSNotificationCenter defaultCenter] postNotificationName:MLReloadDataNotification object:nil];
//            }
//        }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setDefinesPresentationContext:YES];
    self.navigationItem.title = self.note.titleName;
    [self setupTextView];
    [self setupNavigationItem];
    
}

- (void)setupNavigationItem {
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btn setImage:[UIImage imageNamed:@"iosActionOverflow24"] forState:(UIControlStateNormal)];
    [btn sizeToFit];
    [btn addTarget:self action:@selector(clickRightItem) forControlEvents:(UIControlEventTouchUpInside)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

- (void)clickRightItem {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    [alert addAction:cancelAction];
    if (self.bookType == MLBookDele) {
        UIAlertAction *renameAction = [UIAlertAction actionWithTitle:@"恢复笔记" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [self regainNote];
        }];
        [alert addAction:renameAction];
    } else {
        UIAlertAction *moveAction = [UIAlertAction actionWithTitle:@"移动笔记" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [self moveNoteToOtherBook:MLNoteBookListChooseFromNormal];
        }];
        [alert addAction:moveAction];
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"移到废纸篓" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
            [self deleteNote];
        }];
        [alert addAction:deleteAction];
    }
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)regainNote {
    BOOL succe = [self.manager canRegainNoteToNoteBook:self.note];
    if (succe) {
        [SVProgressHUD showSuccessWithStatus:@"恢复笔记成功"];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self moveNoteToOtherBook:MLNoteBookListChooseFromDelete];
    }
}
- (void)moveNoteToOtherBook:(MLNoteBookListType) type {
    
    MLNoteBookListViewController *nblVC = [[MLNoteBookListViewController alloc] init];
    nblVC.listType = type;
    nblVC.note = self.note;
    nblVC.tFloor = self.tFloor;
    nblVC.title = @"移动至...";
    if (self.bookType == MLBookNormal) {
        nblVC.selectIndexPath = [NSIndexPath indexPathForRow:(self.sFloor ? self.sFloor.integerValue + 1 : 0) inSection:self.fFloor.integerValue];
    }
    MLNavigationController *nvc = [[MLNavigationController alloc] initWithRootViewController:nblVC];
    [nvc setModalPresentationStyle:UIModalPresentationCurrentContext];
    [self presentViewController:nvc animated:YES completion:nil];
}
- (void)deleteNote {
    [self.manager moveToWasteNote:self.note fFloor:self.fFloor sFloor:self.sFloor tFloor:self.tFloor complete:^(BOOL succeed) {
        if (succeed) {
            [SVProgressHUD showSuccessWithStatus:@"已移到废纸篓"];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [SVProgressHUD showErrorWithStatus:@"操作失败"];
        }
    }];
}
- (void)setupTextView {
    YYTextView *textView = [YYTextView new];
    textView.attributedText = self.note.AttContent;
    textView.font = [UIFont systemFontOfSize:16];
    textView.frame = self.view.bounds;
    textView.delegate = self;
    textView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
    textView.placeholderText = @"请输入";
    textView.selectedRange = NSMakeRange(self.note.AttContent.length, 0);
    [self.view addSubview:textView];
    self.textView = textView;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [textView becomeFirstResponder];
    });
}
- (void)dealloc {
    self.manager.tFloor = nil;
}


@end
