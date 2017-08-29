//
//  SCJDropDownMultiSelectMenu.m
//  messageManager
//
//  Created by desunire on 2017/8/29.
//  Copyright © 2017年 desunire. All rights reserved.
//

#import "SCJDropDownMultiSelectMenu.h"


#define VIEW_CENTER(aView)       ((aView).center)
#define VIEW_CENTER_X(aView)     ((aView).center.x)
#define VIEW_CENTER_Y(aView)     ((aView).center.y)

#define FRAME_ORIGIN(aFrame)     ((aFrame).origin)
#define FRAME_X(aFrame)          ((aFrame).origin.x)
#define FRAME_Y(aFrame)          ((aFrame).origin.y)

#define FRAME_SIZE(aFrame)       ((aFrame).size)
#define FRAME_HEIGHT(aFrame)     ((aFrame).size.height)
#define FRAME_WIDTH(aFrame)      ((aFrame).size.width)



#define VIEW_BOUNDS(aView)       ((aView).bounds)

#define VIEW_FRAME(aView)        ((aView).frame)

#define VIEW_ORIGIN(aView)       ((aView).frame.origin)
#define VIEW_X(aView)            ((aView).frame.origin.x)
#define VIEW_Y(aView)            ((aView).frame.origin.y)

#define VIEW_SIZE(aView)         ((aView).frame.size)
#define VIEW_HEIGHT(aView)       ((aView).frame.size.height)
#define VIEW_WIDTH(aView)        ((aView).frame.size.width)


#define VIEW_X_Right(aView)      ((aView).frame.origin.x + (aView).frame.size.width)
#define VIEW_Y_Bottom(aView)     ((aView).frame.origin.y + (aView).frame.size.height)






#define AnimateTime 1.00f   // 下拉动画时间

@implementation SCJDropDownMultiSelectMenu

{
    UIImageView * _arrowMark;   // 尖头图标
    UIView      * _listView;    // 下拉列表背景View
    UITableView * _tableView;   // 下拉列表
    
    NSArray     * _titleArr;    // 选项数组
    NSMutableDictionary     * _titleDic;    // 选项字典
    CGFloat       _rowHeight;   // 下拉列表行高
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self createMainBtnWithFrame:frame];
    }
    return self;
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    
    [self createMainBtnWithFrame:frame];
}


//创建下拉按钮
- (void)createMainBtnWithFrame:(CGRect)frame{
    
    [_mainBtn removeFromSuperview];
    _mainBtn = nil;
    
    // 主按钮 显示在界面上的点击按钮
    // 样式可以自定义
    _mainBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_mainBtn setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    [_mainBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_mainBtn setTitle:@"" forState:UIControlStateNormal];
    [_mainBtn addTarget:self action:@selector(clickMainBtn:) forControlEvents:UIControlEventTouchUpInside];
    _mainBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _mainBtn.titleLabel.font    = [UIFont systemFontOfSize:14.f];
    _mainBtn.titleEdgeInsets    = UIEdgeInsetsMake(0, 15, 0, 0);
    _mainBtn.selected           = NO;
    _mainBtn.backgroundColor    = [UIColor whiteColor];
    _mainBtn.layer.borderColor  = [UIColor lightGrayColor].CGColor;
    _mainBtn.layer.borderWidth  = 1;
    
    [self addSubview:_mainBtn];
    
    
    // 旋转尖头
    _arrowMark = [[UIImageView alloc] initWithFrame:CGRectMake(_mainBtn.frame.size.width - 15, 0, 9, 9)];
    _arrowMark.center = CGPointMake(VIEW_CENTER_X(_arrowMark), VIEW_HEIGHT(_mainBtn)/2);
    _arrowMark.image  = [UIImage imageNamed:@"dropdownMenu_cornerIcon.png"];
    [_mainBtn addSubview:_arrowMark];
    
}


//设置标题按钮的标题
- (void)setmainBtnTitle:(NSString *)title{
    [_mainBtn setTitle:title forState:UIControlStateNormal];
}

- (void)setMenuTitles:(NSArray *)titlesArr rowHeight:(CGFloat)rowHeight{
    
    if (self == nil) {
        return;
    }
    
    _titleArr  = [NSArray arrayWithArray:titlesArr];
    _rowHeight = rowHeight;
    
    _titleDic = [NSMutableDictionary dictionary];
    
    for (int i =0; i<_titleArr.count; i++) {
        [_titleDic setObject:@"unChoose" forKey:[NSString stringWithFormat:@"%d",i]];
    }
    
    
    
    // 下拉列表背景View
    _listView = [[UIView alloc] init];
    _listView.frame = CGRectMake(VIEW_X(self) , VIEW_Y_Bottom(self), VIEW_WIDTH(self),[UIScreen mainScreen].bounds.size.height-VIEW_Y_Bottom(self));
    _listView.clipsToBounds       = YES;
    _listView.layer.masksToBounds = NO;
    _listView.backgroundColor=[UIColor clearColor];
    _listView.layer.borderColor   = [UIColor whiteColor].CGColor;
    _listView.layer.borderWidth   = 1.0f;
    
    
    //剩下的添加一个灰色的View
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, VIEW_WIDTH(_listView), (titlesArr.count*rowHeight+80))];
    topView.backgroundColor = [UIColor whiteColor];
    [_listView addSubview:topView];
    
    // 下拉列表TableView
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,VIEW_WIDTH(_listView), titlesArr.count*rowHeight)];
    _tableView.delegate        = self;
    _tableView.dataSource      = self;
    _tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    _tableView.bounces         = NO;
    [topView addSubview:_tableView];
    
    //下拉显示的确定按钮
    _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_sureBtn setFrame:CGRectMake((VIEW_WIDTH(_listView)-200)/2, titlesArr.count*rowHeight+20, 200, 40)];
    [_sureBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_sureBtn addTarget:self action:@selector(sureMainBtn:) forControlEvents:UIControlEventTouchUpInside];
    _sureBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    _sureBtn.layer.masksToBounds = YES;
    _sureBtn.layer.cornerRadius = 5;
    _sureBtn.backgroundColor    = [UIColor lightGrayColor];
    [topView addSubview:_sureBtn];
    
    //剩下的添加一个灰色的View
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, titlesArr.count*rowHeight+80, VIEW_WIDTH(_listView), VIEW_HEIGHT(_listView)-(titlesArr.count*rowHeight+80))];
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha=0.3;
    [_listView addSubview:backView];
    
}

- (void)clickMainBtn:(UIButton *)button{
    
    [self.superview addSubview:_listView]; // 将下拉视图添加到控件的俯视图上
    
    if(button.selected == NO) {
        [self showDropDown];
    }
    else {
        [self hideDropDown];
    }
}

-(void)sureMainBtn:(UIButton *)button{

    NSMutableArray *chooseIndexs=[NSMutableArray array];
    for (int i =0; i<_titleArr.count; i++) {
        if ([[_titleDic valueForKey:[NSString stringWithFormat:@"%d",i]] isEqualToString:@"choose"]) {
            [chooseIndexs addObject:[NSString stringWithFormat:@"%d",i]];
        }
    }
    if (chooseIndexs.count>0) {
        if ([self.delegate respondsToSelector:@selector(dropdownMenu:selectedCellIndex:)]) {
            [self.delegate dropdownMenu:self selectedCellIndex:chooseIndexs];
        }
    }
    
    [self hideDropDown];
    
}

- (void)showDropDown{   // 显示下拉列表
    
    [_listView.superview bringSubviewToFront:_listView]; // 将下拉列表置于最上层
    
    if ([self.delegate respondsToSelector:@selector(dropdownMenuWillShow:)]) {
        [self.delegate dropdownMenuWillShow:self]; // 将要显示回调代理
    }
    
    
    [UIView animateWithDuration:AnimateTime animations:^{
        _arrowMark.transform = CGAffineTransformMakeRotation(M_PI);
        _listView.hidden=NO;
        _tableView.hidden=NO;
        _sureBtn.hidden=NO;
    }completion:^(BOOL finished) {
        
        if ([self.delegate respondsToSelector:@selector(dropdownMenuDidShow:)]) {
            [self.delegate dropdownMenuDidShow:self]; // 已经显示回调代理
        }
    }];
    
    
    
    _mainBtn.selected = YES;
}
- (void)hideDropDown{  // 隐藏下拉列表
    
    
    if ([self.delegate respondsToSelector:@selector(dropdownMenuWillHidden:)]) {
        [self.delegate dropdownMenuWillHidden:self]; // 将要隐藏回调代理
    }
    
    
    [UIView animateWithDuration:AnimateTime animations:^{
        _arrowMark.transform = CGAffineTransformIdentity;
        _listView.hidden=YES;
        _tableView.hidden=YES;
        _sureBtn.hidden=YES;
        
    }completion:^(BOOL finished) {
        
        if ([self.delegate respondsToSelector:@selector(dropdownMenuDidHidden:)]) {
            [self.delegate dropdownMenuDidHidden:self]; // 已经隐藏回调代理
        }
    }];
    
    
    
    _mainBtn.selected = NO;
}

#pragma mark - UITableView Delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _rowHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_titleArr count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell;
    //---------------------------下拉选项样式，可在此处自定义-------------------------
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        UILabel *title = [[UILabel alloc]init];
        title.text = [_titleArr objectAtIndex:indexPath.row];
        title.frame          = CGRectMake(40, 0, VIEW_WIDTH(_listView)-50, VIEW_HEIGHT(cell));
        title.font          = [UIFont systemFontOfSize:14.f];
        title.textColor     = [UIColor blackColor];
        cell.selectionStyle          = UITableViewCellSelectionStyleNone;
        
        [cell.contentView addSubview:title];
        
        UIImageView *image = [[UIImageView alloc] init];
        
        if ([[_titleDic valueForKey:[NSString stringWithFormat:@"%ld",indexPath.row]] isEqualToString:@"choose"]) {
            image.image=[UIImage imageNamed:@"icon9"];
        }else{
            image.image=[UIImage imageNamed:@"icon10"];
        }
        
        image.frame = CGRectMake(10, 10, 20, 20);
        
        [cell.contentView addSubview:image];
        
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, _rowHeight -0.5, VIEW_WIDTH(_listView), 0.5)];
        line.backgroundColor = [UIColor lightGrayColor];
        [cell addSubview:line];
     return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //选中和是否选中
    if ([[_titleDic valueForKey:[NSString stringWithFormat:@"%ld",indexPath.row]] isEqualToString:@"choose"]) {
        [_titleDic setObject:@"unChoose" forKey:[NSString stringWithFormat:@"%ld",indexPath.row]];
    }else{
        [_titleDic setObject:@"choose" forKey:[NSString stringWithFormat:@"%ld",indexPath.row]];
    }
    
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section], nil] withRowAnimation:UITableViewRowAnimationNone];
    //[_tableView reloadData];
    
}

@end
