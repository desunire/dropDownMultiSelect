//
//  ViewController.m
//  dropDownMultiSelect
//
//  Created by desunire on 2017/8/29.
//  Copyright © 2017年 desunire. All rights reserved.
//

#import "ViewController.h"
#import "SCJDropDownMultiSelectMenu.h"
@interface ViewController ()<SCJDropDownMultiSelectMenuDelegate>

@property(strong,nonatomic)NSArray *data;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.data=@[@"全部",@"严重",@"重大",@"轻微",@"警告",@"正常",@"未知"];    
    SCJDropDownMultiSelectMenu * dropdownMenu = [[SCJDropDownMultiSelectMenu alloc] init];
    [dropdownMenu setFrame:CGRectMake(0, 64, self.view.bounds.size.width, 60)];
    [dropdownMenu setMenuTitles:self.data rowHeight:40];
    [dropdownMenu setmainBtnTitle:@"选择告警级别"];
    dropdownMenu.delegate = self;
    [self.view addSubview:dropdownMenu];
    
    
    
}
#pragma mark - SCJDropDownMultiSelectMenuDelegate

- (void)dropdownMenu:(SCJDropDownMultiSelectMenu *)menu selectedCellIndex:(NSMutableArray *)indexArr{
    
    NSLog(@"你选中的是:");
    for (NSString *index in indexArr) {
        NSLog(@"%@",[self.data objectAtIndex:[index integerValue]]);
    }
    
}

- (void)dropdownMenuWillShow:(SCJDropDownMultiSelectMenu *)menu{
    
}
- (void)dropdownMenuDidShow:(SCJDropDownMultiSelectMenu *)menu{
    
}

- (void)dropdownMenuWillHidden:(SCJDropDownMultiSelectMenu *)menu{
    
}
- (void)dropdownMenuDidHidden:(SCJDropDownMultiSelectMenu *)menu{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
