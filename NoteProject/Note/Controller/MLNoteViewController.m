//
//  MLNoteViewController.m
//  NoteProject
//
//  Created by liby on 2018/6/14.
//  Copyright © 2018年 liby. All rights reserved.
//

#import "MLNoteViewController.h"

@interface MLNoteViewController () <YYTextViewDelegate>
@property (nonatomic, strong) YYTextView *textView;

@end

@implementation MLNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = self.note.titleName;
    
    [self setupTextView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.note.AttContent = self.textView.attributedText;
    //    self.note.titleName = self.navigationItem.title;
    [[MLNotesManager sharedManager] updateNote:self.note complete:^(BOOL succeed) {
        if (succeed) {
            [[NSNotificationCenter defaultCenter] postNotificationName:MLReloadDataNotification object:nil];
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
    [self.view addSubview:textView];
    self.textView = textView;
}


@end
