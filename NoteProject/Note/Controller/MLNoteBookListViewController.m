//
//  MLNoteBookListViewController.m
//  NoteProject
//
//  Created by liby on 2018/6/12.
//  Copyright © 2018年 liby. All rights reserved.
//

#import "MLNoteBookListViewController.h"
#import "MLNoteListViewController.h"
#import "MLNoteBookListCell.h"
#import "MLNavigationController.h"


static NSString *const MLNoteBookListID = @"MLNoteBookListCell";

@interface MLNoteBookListViewController () <UITableViewDelegate, UITableViewDataSource>
/** tableview */
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation MLNoteBookListViewController

//- (NSMutableArray *)selectArr{
//    if (!_selectArr) {
//        _selectArr = [NSMutableArray array];
//    }
//    return _selectArr;
//}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableView];
    
    if (self.listType != MLNoteBookListNormal) {
        [self setupNavigationItem];
    }
}
- (void)setupTableView {
    UITableView *tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, self.view.H) style:(UITableViewStylePlain)];
    tv.delegate = self;
    tv.dataSource = self;
    tv.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tv];
    [tv registerNib:[UINib nibWithNibName:MLNoteBookListID bundle:nil] forCellReuseIdentifier:MLNoteBookListID];
    tv.tableHeaderView = [self setupTableHeaderView];
    self.tableView = tv;
}

- (UIView *)setupTableHeaderView {
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 60)];
    header.backgroundColor = [UIColor whiteColor];
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, kWidth, 60)];
    lab.text = @"笔记本";
    lab.font = [UIFont boldSystemFontOfSize:16];
    lab.textColor = MLGrayColor(40);
    [header addSubview:lab];
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btn setImage:[UIImage imageNamed:@"iosCirclePlus24"] forState:(UIControlStateNormal)];
    btn.tintColor = MLColor(44, 190, 97);
    btn.frame = CGRectMake(kWidth - 60, 0, 60, 60);
    [btn addTarget:self action:@selector(insertNoteBookClick) forControlEvents:(UIControlEventTouchUpInside)];
    [header addSubview:btn];
    
    return header;
}

- (void)setupNavigationItem {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:(UIBarButtonItemStyleDone) target:self action:@selector(clickRightItem)];
}
- (void)clickRightItem {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger sections = self.manager.noteListArr.count;
    if (self.manager.deleNoteBook.isContainNote && self.listType == MLNoteBookListNormal) {
        sections++;
    }
    return sections;
}
#pragma mark - 行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == self.manager.noteListArr.count) {
        return 1;
    }
    if ([self.manager.noteListArr[section] modelType] == MLModelGroup && [self.manager.noteListArr[section] isSelect]) {
        return [self.manager.noteListArr[section] noteBookArr].count + 1;
    }
    return 1;
}
#pragma mark - cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MLNoteBookListCell *cell = [tableView dequeueReusableCellWithIdentifier:MLNoteBookListID forIndexPath:indexPath];
    if (self.manager.deleNoteBook.isContainNote && indexPath.section == self.manager.noteListArr.count) {
        cell.model = self.manager.deleNoteBook;
    } else if ([self.manager.noteListArr[indexPath.section] modelType] == MLModelGroup && [self.manager.noteListArr[indexPath.section] isSelect] && indexPath.row) {
        cell.model = [self.manager.noteListArr[indexPath.section] noteBookArr][indexPath.row - 1];
    } else {
        cell.model = self.manager.noteListArr[indexPath.section];
    }
    if ([indexPath isEqual:self.selectIndexPath]) {
        cell.imgV.image = [UIImage imageNamed:@"reminder_set"];
    }
    cell.isInGroup = indexPath.row;
    return cell;
}
#pragma mark - 行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
#pragma mark - 点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MLNoteBookListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSInteger index = indexPath.section;
    if (cell.caretDownBtn.isHidden) {       // 笔记本
        self.fFloor = [self getFFloor:indexPath];
        self.sFloor = [self getSFloor:indexPath];
        if (self.listType == MLNoteBookListNormal) {
            MLNoteListViewController *noteListVC = [[MLNoteListViewController alloc] init];
            noteListVC.noteBook = (MLNoteBook *)cell.model;
            noteListVC.fFloor = self.fFloor;
            noteListVC.sFloor = self.sFloor;
            [self.navigationController pushViewController:noteListVC animated:YES];
        } else if (self.listType == MLNoteBookListChooseFromDelete) {
            [self regainNoteAlert:cell.model];
        } else if (self.listType == MLNoteBookListChooseFromNormal) {
            if ([indexPath isEqual:self.selectIndexPath]) {
                return;
            }
            [self moveNoteAlert:cell.model];
        }
    } else {                                // 笔记本组
        NSInteger count = ((MLNoteBookGroup *)cell.model).noteBookArr.count;
        ((MLNoteBookGroup *)self.manager.noteListArr[index]).isSelect = ![self.manager.noteListArr[index] isSelect];
        if ([self.manager.noteListArr[index] isSelect]) {
            [UIView animateWithDuration:0.25 animations:^{
                cell.caretDownBtn.transform = CGAffineTransformMakeRotation(180.1 * M_PI/180.0);
            }];
            [tableView insertRowsAtIndexPaths:[self reloadRowsWithIndex:index count:count] withRowAnimation:(UITableViewRowAnimationBottom)];
        } else {
            [UIView animateWithDuration:0.25 animations:^{
                cell.caretDownBtn.transform = CGAffineTransformIdentity;
            }];
            [tableView deleteRowsAtIndexPaths:[self reloadRowsWithIndex:index count:count] withRowAnimation:(UITableViewRowAnimationTop)];
        }
    }
}
- (NSNumber *)getFFloor:(NSIndexPath *)indexPath {
    return @(indexPath.section);
}
- (NSNumber *)getSFloor:(NSIndexPath *)indexPath {
    if (indexPath.row) {
        return @(indexPath.row - 1);    // 组中书
    }
    return nil;                         // 组外书 组
}
// 获取展开收起的row
- (NSArray *)reloadRowsWithIndex:(NSInteger)index count:(NSInteger)count {
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 1; i < count + 1; i++) {
        [arr addObject:[NSIndexPath indexPathForRow:i inSection:index]];
    }
    return [arr copy];
}
#pragma mark - 编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.listType != MLNoteBookListNormal) {
        return NO;
    }
    if (self.manager.deleNoteBook.isContainNote && indexPath.section == self.manager.noteListArr.count) {
        return NO;
    }
    return YES;
}
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *editRowAction = [UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleNormal) title:nil handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        MLNoteBookListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        self.fFloor = [self getFFloor:indexPath];
        self.sFloor = [self getSFloor:indexPath];
        [self showSheet:cell.model];
    }];
    editRowAction.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"gearSwipe"]];
    return @[editRowAction];
}
#pragma mark - 编辑Alert
- (void)showSheet:(MLNoteBaseModel *)model {
    NSString *title;
    if (model.modelType == MLModelGroup) {
        title = @"笔记本组设置";
    } else {
        title = @"笔记本设置";
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    [alert addAction:cancelAction];
    UIAlertAction *renameAction = [UIAlertAction actionWithTitle:@"重命名" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self renameAlert:model];
    }];
    [alert addAction:renameAction];
    if (model.modelType == MLModelBook) {
        UIAlertAction *moveAction = [UIAlertAction actionWithTitle:@"移动到 . . ." style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [self moveAlert:model];
        }];
        [alert addAction:moveAction];
        if ([self.manager canDeleNoteBook]) {
            UIAlertAction *deleAction = [UIAlertAction actionWithTitle:@"删除笔记本" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
                [self deleAlert:model];
            }];
            [alert addAction:deleAction];
        }
    }
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark - 重命名Alert
- (void)renameAlert:(MLNoteBaseModel *)model {
    __weak MLNoteBookListViewController *weakSelf = self;
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"重命名" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    [alert addAction:cancelAction];
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        //重命名
        UITextField *tf = alert.textFields.firstObject;
        NSString *title = [self judgeTitle:tf.text];
        if (!title) return;
        if (![title isEqualToString:model.titleName]) {
            model.titleName = title;
//            [self.manager updateNoteModel:model fFloor:self.fFloor sFloor:self.sFloor tFloor:self.tFloor complete:^(BOOL succeed) {
//                if (succeed) [weakSelf.tableView reloadData];
//            }];
            [self.tableView reloadData];
        }
    }];
    [alert addAction:okAction];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.text = model.titleName;
    }];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark - 移动Alert
- (void)moveAlert:(MLNoteBaseModel *)model {
    __weak MLNoteBookListViewController *weakSelf = self;
    NSString *title, *message;
    if (self.sFloor) {
        title = @"当前组:";
        message = [self.manager.noteListArr[self.fFloor.integerValue] titleName];
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    if (self.sFloor) {
        UIAlertAction *removeGroupAction = [UIAlertAction actionWithTitle:@"移出当前组" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
            [self.manager.noteListArr addObject:model];
            [self.manager deleteNoteModel:model fFloor:self.fFloor sFloor:self.sFloor tFloor:self.tFloor complete:^(BOOL succeed) {
                if (succeed) [weakSelf.tableView reloadData];
            }];
        }];
        [alert addAction:removeGroupAction];
    }
    UIAlertAction *newGroupAction = [UIAlertAction actionWithTitle:@"新建笔记本组" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
        [self newGroupAlert:model];
    }];
    [alert addAction:newGroupAction];
    [[self.manager.noteListArr copy] enumerateObjectsUsingBlock:^(MLNoteBaseModel  * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.modelType == MLModelGroup && ![obj.titleName isEqualToString:message]) {
            UIAlertAction *newGroupAction = [UIAlertAction actionWithTitle:obj.titleName style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                NSLog(@"%@", alert.actions);
                NSLog(@"%ld", idx);
                [weakSelf.manager insertNoteModel:model fFloor:@(idx) sFloor:nil complete:^(BOOL succeed) {
                    if (succeed) {
                        [weakSelf.manager deleteNoteModel:model fFloor:weakSelf.fFloor sFloor:weakSelf.sFloor tFloor:weakSelf.tFloor complete:^(BOOL succeed) {
                            if (succeed) [weakSelf.tableView reloadData];
                        }];
                    }
                }];
            }];
            [alert addAction:newGroupAction];
        }
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark - 创建笔记本组Alert
- (void)newGroupAlert:(MLNoteBaseModel *)model {
    __weak MLNoteBookListViewController *weakSelf = self;
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"新建笔记本组:" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    [alert addAction:cancelAction];
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"创建" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        UITextField *tf = alert.textFields.firstObject;
        NSString *title = [self judgeTitle:tf.text];
        if (!title) return;
        // 重名判断
        for (MLNoteBaseModel *obj in self.manager.noteListArr) {
            if (obj.modelType == MLModelGroup) {
                if ([obj.titleName isEqualToString:title]) {
                    [SVProgressHUD showErrorWithStatus:@"该组已存在"];
                    return;
                }
            }
        }
        // 新建
        MLNoteBookGroup *newModel = [[MLNoteBookGroup alloc] initWithTitle:title];
        [newModel.noteBookArr addObject:model];
        [self.manager.noteListArr addObject:newModel];
        [self.manager deleteNoteModel:model fFloor:self.fFloor sFloor:self.sFloor tFloor:self.tFloor complete:^(BOOL succeed) {
            if (succeed) [weakSelf.tableView reloadData];
        }];
    }];
    [alert addAction:okAction];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"笔记本组名称";
    }];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark - 创建笔记本Alert
- (void)insertNoteBookClick{
    __weak MLNoteBookListViewController *weakSelf = self;
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"新建笔记本:" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    [alert addAction:cancelAction];
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"创建" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        UITextField *tf = alert.textFields.firstObject;
        NSString *title = [self judgeTitle:tf.text];
        if (!title) return;
        // 重名判断
        for (MLNoteBaseModel *obj in self.manager.noteListArr) {
            if (obj.modelType == MLModelGroup) {
                for (MLNoteBaseModel *objc in [(MLNoteBookGroup *)obj noteBookArr]) {
                    if ([objc.titleName isEqualToString:title]) {
                        [SVProgressHUD showErrorWithStatus:@"该笔记本已存在"];
                        return;
                    }
                }
            } else {
                if ([obj.titleName isEqualToString:title]) {
                    [SVProgressHUD showErrorWithStatus:@"该笔记本已存在"];
                    return;
                }
            }
        }
        // 新建
        MLNoteBook *newModel = [[MLNoteBook alloc] initWithTitle:title];
        [self.manager.noteListArr addObject:newModel];
        [self.tableView reloadData];
    }];
    [alert addAction:okAction];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"笔记本名称";
    }];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark - 删除笔记本Alert
- (void)deleAlert:(MLNoteBaseModel *)model {
    __weak MLNoteBookListViewController *weakSelf = self;
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"删除笔记本" message:@"此操作不可恢复\n笔记本中笔记将移至废纸篓" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    [alert addAction:cancelAction];
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
        [self.manager moveToWasteNoteBook:(MLNoteBook *)model fFloor:self.fFloor sFloor:self.sFloor complete:^(BOOL succeed) {
            if (succeed) [weakSelf.tableView reloadData];
        }];
    }];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark - 恢复笔记Alert
- (void)regainNoteAlert:(MLNoteBaseModel *)model {
    __weak MLNoteBookListViewController *weakSelf = self;
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"恢复笔记至:" message:model.titleName preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    [alert addAction:cancelAction];
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self.manager.deleNoteBook.noteArr removeObject:self.note];
        [self.manager insertNoteModel:self.note fFloor:self.fFloor sFloor:self.sFloor complete:^(BOOL succeed) {
            if (succeed) {
                [SVProgressHUD showSuccessWithStatus:@"恢复笔记成功"];
            }
            MLNavigationController *nvc = (MLNavigationController *)weakSelf.presentingViewController;
            [weakSelf.presentingViewController dismissViewControllerAnimated:YES completion:^{
                if (succeed) {
                    [nvc popViewControllerAnimated:YES];
                }
            }];
        }];
    }];
    [alert addAction:okAction];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alert animated:YES completion:nil];
    });
}
#pragma mark - 移动笔记Alert
- (void)moveNoteAlert:(MLNoteBaseModel *)model {
    __weak MLNoteBookListViewController *weakSelf = self;
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"移动笔记至:" message:model.titleName preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    [alert addAction:cancelAction];
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self.manager deleteNoteModel:self.note fFloor:@(self.selectIndexPath.section) sFloor:(self.selectIndexPath.row == 0 ? nil : @(self.selectIndexPath.row - 1)) tFloor:self.tFloor complete:^(BOOL succeed) {
            if (succeed) {
                [weakSelf.manager insertNoteModel:weakSelf.note fFloor:weakSelf.fFloor sFloor:weakSelf.sFloor complete:^(BOOL succeed) {
                    if (succeed) {
                        [SVProgressHUD showSuccessWithStatus:@"移动笔记成功"];
                    }
                }];
            }
        }];
        [weakSelf.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:okAction];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alert animated:YES completion:nil];
    });
}
#pragma mark - 空标题判断
- (NSString *)judgeTitle:(NSString *)title {
    title = KWhitespaceString(title);
    if (!title.length) {
        [SVProgressHUD showErrorWithStatus:@"标题不能为空"];
        return nil;
    }
    return title;
}
- (void)dealloc {
}
@end


