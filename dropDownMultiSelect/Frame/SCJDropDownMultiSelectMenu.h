//
//  SCJDropDownMultiSelectMenu.h
//  messageManager
//
//  Created by desunire on 2017/8/29.
//  Copyright © 2017年 desunire. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SCJDropDownMultiSelectMenu;

@protocol SCJDropDownMultiSelectMenuDelegate <NSObject>

@optional

- (void)dropdownMenuWillShow:(SCJDropDownMultiSelectMenu *)menu;    // 当下拉菜单将要显示时调用
- (void)dropdownMenuDidShow:(SCJDropDownMultiSelectMenu *)menu;     // 当下拉菜单已经显示时调用
- (void)dropdownMenuWillHidden:(SCJDropDownMultiSelectMenu *)menu;  // 当下拉菜单将要收起时调用
- (void)dropdownMenuDidHidden:(SCJDropDownMultiSelectMenu *)menu;   // 当下拉菜单已经收起时调用

- (void)dropdownMenu:(SCJDropDownMultiSelectMenu *)menu selectedCellIndex:(NSMutableArray *)indexArr; // 当选择多个选项后点击确定

@end

@interface SCJDropDownMultiSelectMenu : UIView <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UIButton * mainBtn;  // 主按钮 可以自定义样式 可在.m文件中修改默认的一些属性

@property (nonatomic,strong) UIButton * sureBtn;  // 确定按钮 可以自定义样式 可在.m文件中修改默认的一些属性

@property (nonatomic, assign) id <SCJDropDownMultiSelectMenuDelegate>delegate;


- (void)setMenuTitles:(NSArray *)titlesArr rowHeight:(CGFloat)rowHeight;  // 设置下拉菜单控件样式

- (void)showDropDown; // 显示下拉菜单
- (void)hideDropDown; // 隐藏下拉菜单

//设置主按钮的标题
- (void)setmainBtnTitle:(NSString *)title;

@end


