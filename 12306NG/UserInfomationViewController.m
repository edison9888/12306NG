//
//  UserInfomationViewController.m
//  12306NG
//
//  Created by Zhao Yang on 12/13/12.
//  Copyright (c) 2012 12306NG. All rights reserved.
//

#import "UserInfomationViewController.h"
#import "NGUserService.h"
#import <QuartzCore/QuartzCore.h>

#import "AddTravelCompanionViewController.h"
#import "TravelCompanionInfoViewController.h"
#import "RegisterViewController.h"

@interface UserInfomationViewController ()
@property(nonatomic,retain)NSMutableArray* tableArray;
@property(nonatomic,retain)UITableView* mainTableView;
@property(nonatomic,retain)NSMutableDictionary* dataDict;

@property(nonatomic,retain)NSMutableArray* userListArray;
@property(nonatomic,retain)UITableView* userListTableView;

@property(nonatomic,retain)UIView* loadingView;

@end

@implementation UserInfomationViewController

@synthesize isNeedsToReLoadWhileViewWillAppear;
@synthesize userInfoKey;

@synthesize tableArray,mainTableView;

@synthesize dataDict;

@synthesize userListArray,userListTableView;

@synthesize loadingView;

-(id)initWithUserInfoKey:(UserInfoKey)userInfoKey_
{
    
    self=[super init];
    if (self) {
        // Custom initialization
        self.userInfoKey=userInfoKey_;
    }
    return self;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tableArray=[NSMutableArray arrayWithObjects:
                         [NSMutableArray arrayWithObjects:
                          [NSMutableDictionary dictionaryWithObjectsAndKeys:@"姓    名",@"title",@"idName",@"id",@"",@"value",@"",@"mask",nil],
                          [NSMutableDictionary dictionaryWithObjectsAndKeys:@"性    别",@"title",@"sex",@"id",@"",@"value",@"",@"mask", nil],
                          [NSMutableDictionary dictionaryWithObjectsAndKeys:@"出生日期",@"title",@"birthday",@"id",@"",@"value",@"",@"mask", nil],
                          [NSMutableDictionary dictionaryWithObjectsAndKeys:@"证件类型",@"title",@"idType",@"id",@"",@"value",@"",@"mask", nil],
                          [NSMutableDictionary dictionaryWithObjectsAndKeys:@"证件号码",@"title",@"idNumber",@"id",@"",@"value",@"",@"mask", nil],
                          [NSMutableDictionary dictionaryWithObjectsAndKeys:@"手机号码",@"title",@"phone",@"id",@"",@"value",@"",@"mask", nil],
                          [NSMutableDictionary dictionaryWithObjectsAndKeys:@"电子邮箱",@"title",@"email",@"id",@"",@"value",@"",@"mask", nil],
                          [NSMutableDictionary dictionaryWithObjectsAndKeys:@"旅客类型",@"title",@"userType",@"id",@"",@"value",@"",@"mask", nil],
                          
                          nil],nil];
        
        
        self.dataDict=[NSMutableDictionary dictionaryWithObjectsAndKeys:
                       @"张三",@"idName",
                       @"M",@"sex",
                       @"1980-11-11",@"birthday",
                       @"1",@"idType",
                       @"123456789012345678",@"idNumber",
                       @"110",@"phone",
                       @"110@1.com",@"email",
                       @"0",@"userType",
                       nil];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title=@"个人资料管理";
    
    [self showCustomBackButton];
    
    
    
    segControlTop=[[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"我的资料",@"同行旅客", nil]];
    segControlTop.frame=CGRectMake(10, 15, 300, 30);
    segControlTop.segmentedControlStyle=UISegmentedControlStylePlain;
    segControlTop.selectedSegmentIndex=self.userInfoKey;
    
    [segControlTop addTarget:self action:@selector(changUserInfoKey:) forControlEvents:UIControlEventValueChanged];
    
    
    [self.view addSubview:segControlTop];
    
    
    CGRect rect=CGRectMake(0, 50, self.view.bounds.size.width,self.view.bounds.size.height-44-50);
    
    self.mainTableView=[[[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped] autorelease]  ;
    //[self.view addSubview:self.mainTableView];
    mainTableView.backgroundColor=[UIColor clearColor];
    mainTableView.backgroundView=nil;
    mainTableView.dataSource=(id<UITableViewDataSource>)self;
    mainTableView.delegate=(id<UITableViewDelegate>)self;
    mainTableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    
    [self registerForKeyboardNotifications];
    //    self.userListTableView=[[[UITableView alloc] initWithFrame:CGRectMake(rect.size.width, 0, rect.size.width, rect.size.height) style:UITableViewStyleGrouped] autorelease]  ;
    //    //[self.view addSubview:self.mainTableView];
    //    userListTableView.backgroundColor=[UIColor clearColor];
    //    userListTableView.backgroundView=nil;
    //    userListTableView.dataSource=(id<UITableViewDataSource>)self;
    //    userListTableView.delegate=(id<UITableViewDelegate>)self;
    //    userListTableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    //
    //
    //
    //    mainScrollView=[[UIScrollView alloc] initWithFrame:rect];
    //    mainScrollView.contentSize=CGSizeMake(rect.size.width*2, rect.size.height);
    //    mainScrollView.pagingEnabled=YES;
    //    [self.view addSubview:mainScrollView];
    
    
    self.loadingView=[[UIView alloc] initWithFrame:CGRectInset(rect, 10, 10)];
    loadingView.backgroundColor=[UIColor whiteColor];
    loadingView.layer.cornerRadius=8;
    
    
    isNeedsToReLoadWhileViewWillAppear=YES;
    
    //    UIActivityIndicatorView* activity=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    //    activity.center=CGPointMake(loadingView.frame.size.width/2, loadingView.frame.size.height/2);
    //    [loadingView addSubview:activity];
    //    [activity startAnimating];
    
    
}
-(void)changUserInfoKey:(UISegmentedControl*)seg
{
    
    [mainTableView setEditing:NO animated:YES];
    
//    [UIView transitionWithView:mainTableView duration:0.6 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:nil];
//    
    if (seg.selectedSegmentIndex==0) {
        
        userInfoKey=UserInfoMe;
        
        
        if (!isMainTableLoaded) {
            
            [mainTableView removeFromSuperview];
            [self.view addSubview:loadingView];
            loadingView.layer.opacity=1;
            for (UIView* v in [loadingView subviews]) {
                [v removeFromSuperview];
            }
            UIActivityIndicatorView* activity=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            activity.center=CGPointMake(loadingView.frame.size.width/2, loadingView.frame.size.height/2);
            [loadingView addSubview:activity];
            [activity startAnimating];
            
            [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(loadMainTableView) userInfo:nil repeats:NO];
            
            //[self loadMainTableView];
        }else if(self.dataDict) {
            
            self.navigationItem.rightBarButtonItem=[self myEditButtonItem];
            
            
            
            [loadingView removeFromSuperview];
            [self.view addSubview:mainTableView];
            [mainTableView reloadData];
        }else {
            
            self.navigationItem.rightBarButtonItem=nil;
            
            
            [mainTableView removeFromSuperview];
            [self.view addSubview:loadingView];
            loadingView.layer.opacity=1;
            for (UIView* v in [loadingView subviews]) {
                [v removeFromSuperview];
            }
            UILabel* lable=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
            lable.center=CGPointMake(loadingView.frame.size.width/2, loadingView.frame.size.height/2);
            lable.text=@"暂无数据";
            lable.textAlignment=UITextAlignmentCenter;
            [loadingView addSubview:lable];
        }
        
        
        //[mainScrollView scrollRectToVisible:mainTableView.frame animated:YES];
    }else {
        userInfoKey=UserInfoOther;
        
        if (!isUserListTableLoaded) {
            self.navigationItem.rightBarButtonItem=nil;
            [mainTableView removeFromSuperview];
            [self.view addSubview:loadingView];
            loadingView.layer.opacity=1;
            for (UIView* v in [loadingView subviews]) {
                [v removeFromSuperview];
            }
            UIActivityIndicatorView* activity=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            activity.center=CGPointMake(loadingView.frame.size.width/2, loadingView.frame.size.height/2);
            [loadingView addSubview:activity];
            [activity startAnimating];
            
            [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(loadUserListTableView) userInfo:nil repeats:NO];
            
            //[self loadUserListTableView];
        }
        else
            
            
            if(self.userListArray){
                
                
                if ([self.userListArray count]>0) {
                    self.navigationItem.rightBarButtonItem=[self myEditButtonItem];
                }else
                {
                    self.navigationItem.rightBarButtonItem=nil;
                }
                
                
                [loadingView removeFromSuperview];
                [self.view addSubview:mainTableView];
                [mainTableView reloadData];
            }
            else {
                
                self.navigationItem.rightBarButtonItem=nil;
                [mainTableView removeFromSuperview];
                [self.view addSubview:loadingView];
                loadingView.layer.opacity=1;
                for (UIView* v in [loadingView subviews]) {
                    [v removeFromSuperview];
                }
                UILabel* lable=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
                lable.center=CGPointMake(loadingView.frame.size.width/2, loadingView.frame.size.height/2);
                lable.text=@"暂无数据";
                lable.textAlignment=UITextAlignmentCenter;
                [loadingView addSubview:lable];
            }
        //[mainScrollView scrollRectToVisible:userListTableView.frame animated:YES];
    }
    //
    //[self.view setNeedsLayout];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    if (isNeedsToReLoadWhileViewWillAppear) {
        
        
        [mainTableView removeFromSuperview];
        [mainTableView setContentOffset:CGPointMake(0, 0)];
        
        for (UIView* v in [loadingView subviews]) {
            [v removeFromSuperview];
        }
        UIActivityIndicatorView* activity=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activity.center=CGPointMake(loadingView.frame.size.width/2, loadingView.frame.size.height/2);
        [loadingView addSubview:activity];
        [activity startAnimating];
        
        [self.view addSubview:loadingView];
        loadingView.layer.opacity=1;
        
        self.navigationItem.rightBarButtonItem=nil;
    }
    
    //    if (self.userInfoKey==UserInfoMe) {
    //        self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editContent)] autorelease];
    //    }
    
    
    
    //    if (self.userInfoKey==UserInfoMe) {
    //        [self.view addSubview:loadingView];
    //        [self loadMainTableView];
    //
    //    }else if(self.userInfoKey==UserInfoOther){
    //        [self.view addSubview:loadingView];
    //        loadingView.layer.opacity=1;
    //        [self loadUserListTableView];
    //
    //    }
    
}
-(void)viewDidAppear:(BOOL)animated
{
    
    if (isNeedsToReLoadWhileViewWillAppear) {
        
        isNeedsToReLoadWhileViewWillAppear=NO;
        if (self.userInfoKey==UserInfoMe) {
            [self.view addSubview:loadingView];
            [self loadMainTableView];
            
        }else if(self.userInfoKey==UserInfoOther){
            [self.view addSubview:loadingView];
            loadingView.layer.opacity=1;
            [self loadUserListTableView];
            
        }
    }
    
}
-(void)loadUserListTableView
{
    dispatch_async(dispatch_queue_create("loadUserListTableView", nil), ^{
        self.userListArray=[[NGUserService sharedService] getListWithUsers];
        dispatch_async(dispatch_get_main_queue(),^{
            
            
            isUserListTableLoaded=YES;
            if (userInfoKey==UserInfoMe) {
                return ;
            }
            
            
            if (self.userListArray) {
                
                if ([self.userListArray count]>0) {
                    self.navigationItem.rightBarButtonItem=[self myEditButtonItem];
                }
                
                loadingView.layer.opacity=1;
                mainTableView.layer.opacity=0;
                [mainTableView reloadData];
                [self.view addSubview:mainTableView];
                
                [UIView animateWithDuration:0.5 animations:^{
                    loadingView.layer.opacity=0;
                    mainTableView.layer.opacity=1;
                } completion:^(BOOL finished) {
                    [loadingView removeFromSuperview];
                }];
                
            }else {
                
                for (UIView* v in [loadingView subviews]) {
                    [v removeFromSuperview];
                }
                UILabel* lable=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
                lable.center=CGPointMake(loadingView.frame.size.width/2, loadingView.frame.size.height/2);
                lable.text=@"暂无数据";
                lable.textAlignment=UITextAlignmentCenter;
                [loadingView addSubview:lable];
            }
        });
    });
    
    
}


-(void)loadMainTableView
{
    dispatch_async(dispatch_queue_create("getListWithUsers", nil), ^{
        self.dataDict=[[NGUserService sharedService] getUserInfo];
        dispatch_async(dispatch_get_main_queue(),^{
            
            
            isMainTableLoaded=YES;
            if (userInfoKey==UserInfoOther) {
                return ;
            }
            
            
            
            if (self.dataDict) {
                
                self.navigationItem.rightBarButtonItem=[self myEditButtonItem];
                loadingView.layer.opacity=1;
                mainTableView.layer.opacity=0;
                [mainTableView reloadData];
                [self.view addSubview:mainTableView];
                
                [UIView animateWithDuration:0.5 animations:^{
                    loadingView.layer.opacity=0;
                    mainTableView.layer.opacity=1;
                } completion:^(BOOL finished) {
                    [loadingView removeFromSuperview];
                }];
                
            }else {
                
                for (UIView* v in [loadingView subviews]) {
                    [v removeFromSuperview];
                }
                UILabel* lable=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
                lable.center=CGPointMake(loadingView.frame.size.width/2, loadingView.frame.size.height/2);
                lable.text=@"暂无数据";
                lable.textAlignment=UITextAlignmentCenter;
                [loadingView addSubview:lable];
            }
        });
    });
    
}


-(void)editContent
{
    
    [mainTableView setEditing:!mainTableView.isEditing animated:userInfoKey==UserInfoOther ];
    //selectedSegmentIndex
    if (mainTableView.isEditing) {
        //[segControlTop setEnabled:NO];
        self.navigationItem.rightBarButtonItem=[self myEditButtonItem];
        
        
        
        if (userInfoKey==UserInfoMe) {
            
            segControlTop.hidden=YES;
            
           
            
            NGCustomButton* subButton=[[NGCustomButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
            [subButton addTarget:self action:@selector(editCancle) forControlEvents:UIControlEventTouchUpInside];
            subButton.titleLabel.text=@"取消";
             self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:subButton];
            [subButton release];
            [UIView transitionWithView:self.view duration:0.6 options:UIViewAnimationOptionTransitionFlipFromRight animations:^
             {
                 
             }completion:nil];
            mainTableView.frame=CGRectMake(0, 0, mainTableView.frame.size.width, mainTableView.frame.size.height+50);
        }
        else {
            [UIView animateWithDuration:0.3 animations:^{
                segControlTop.hidden=YES;
                mainTableView.frame=CGRectMake(0, 0, mainTableView.frame.size.width, mainTableView.frame.size.height+50);
            }];
        }
        
    }else {
        //[segControlTop setEnabled:YES];
        
        
        self.navigationItem.rightBarButtonItem=[self myEditButtonItem];
        if (userInfoKey==UserInfoMe) {
            segControlTop.hidden=NO;
            
            [self showCustomBackButton];
            
            
            [self.view endEditing:YES];
            [mainTableView reloadData];
            
            
            [UIView transitionWithView:self.view duration:0.6 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^
             {
                 
             }completion:nil];
            mainTableView.frame=CGRectMake(0, 50, mainTableView.frame.size.width, mainTableView.frame.size.height-50);
        }else {
            [UIView animateWithDuration:0.3 animations:^{
                segControlTop.hidden=NO;
                mainTableView.frame=CGRectMake(0, 50, mainTableView.frame.size.width, mainTableView.frame.size.height-50);
            }];
        }
        
    }
    //
}
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}

// Moving/reordering

// Allows the reorder accessory view to optionally be shown for a particular row. By default, the reorder control will be shown only if the datasource implements -tableView:moveRowAtIndexPath:toIndexPath:
//- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (userInfoKey==UserInfoOther&&indexPath.section==0) {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}
//- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
//{
//
//}

// Controls whether the background is indented while editing.  If not implemented, the default is YES.  This is unrelated to the indentation level below.  This method only applies to grouped style table views.
- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return NO;
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (userInfoKey==UserInfoMe) {
        return [tableArray count];
    }else {
        return 2;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (userInfoKey==UserInfoMe) {
        return [[tableArray objectAtIndex:section]  count];
    }else {
        if (section==1) {
            return 1;
        }
        return [userListArray count];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell_ABC";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier] ;
    if (cell==nil) {
        cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle=UITableViewCellSelectionStyleGray;
    }
    if (userInfoKey==UserInfoMe) {
        
        
        NSMutableDictionary* cellDict=[[self.tableArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        cell.textLabel.text=[cellDict objectForKey:@"title"];
        cell.textLabel.backgroundColor=[UIColor clearColor];
        //cell.detailTextLabel.text=[self.dataDict objectForKey:[cellDict objectForKey:@"id"]];;
        
        UILabel* labelValue=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 180, 30)];
        //labelName.textAlignment=UITextAlignmentCenter;
        labelValue.text=[self.dataDict objectForKey:[cellDict objectForKey:@"id"]];
        labelValue.backgroundColor=[UIColor clearColor];
        cell.accessoryView=labelValue;
        [labelValue release];
        
        
        NSString* itemID=[cellDict objectForKey:@"id"];
        if ([itemID isEqualToString:@"sex"]) {
            
            
            UISegmentedControl* segSexControl=[[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"男",@"女", nil]];
            segSexControl.frame=CGRectMake(10, 15, 180, 30);
            segSexControl.segmentedControlStyle=UISegmentedControlStylePlain;
            [segSexControl addTarget:self action:@selector(changeSex:) forControlEvents:UIControlEventValueChanged];
            segSexControl.selectedSegmentIndex=[[self.dataDict objectForKey:[cellDict objectForKey:@"id"]] isEqualToString:@"男"]?0:1;
            cell.editingAccessoryView=segSexControl;
            //[segControl release];
            
            
        }
        else if ([itemID isEqualToString:@"birthday"]||[itemID isEqualToString:@"idType"]||[itemID isEqualToString:@"userType"])  {
            
            
            
            UIView* v=[[UIView alloc] initWithFrame:CGRectMake(0, 0,200, 30)];
            
            UILabel* labelValue=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 30)];
            labelValue.textAlignment=UITextAlignmentRight;
            labelValue.textColor=[UIColor greenColor];
            labelValue.text=[self.dataDict objectForKey:[cellDict objectForKey:@"id"]];
            labelValue.backgroundColor=[UIColor clearColor];
            [v addSubview:labelValue];
            [labelValue release];
            
            UIButton* btn=[UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            btn.frame=CGRectMake(170, 0, 30, 30);
            [v addSubview:btn];
            
            
            
            cell.editingAccessoryView=v;
            [v release];
            
        }
        
        else {
            
            
            
            UITextField* textName=[[UITextField alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
            //textName.borderStyle=UITextBorderStyleLine;
            textName.borderStyle=UITextBorderStyleBezel;
            textName.textColor=[UIColor greenColor];
            textName.accessibilityLabel=[cellDict objectForKey:@"id"];
            textName.text=[self.dataDict objectForKey:[cellDict objectForKey:@"id"]];
            textName.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
            cell.editingAccessoryView=textName;
            textName.delegate=self;
            [textName release];
        }
    }
    else {
        
        if (indexPath.section==1&&indexPath.row==0) {
            
            
            
            
            cell.accessoryType=UITableViewCellAccessoryNone;
            cell.textLabel.text=@"";
            //cell.backgroundColor=[UIColor whiteColor];
            //cell.backgroundView=nil;
            
            UIButton* labelValue=[UIButton buttonWithType:UIButtonTypeRoundedRect];
            [labelValue addTarget:self action:@selector(onAddNewCustomClick) forControlEvents:UIControlEventTouchUpInside];
            labelValue.frame=CGRectMake(0, 0, cell.frame.size.width-20, 44);
            labelValue.backgroundColor=[UIColor clearColor];
            [labelValue setTitle:@"✚添加同行旅客" forState:UIControlStateNormal];
            //                     labelValue sett=@"";
            //            labelValue.backgroundColor=[UIColor clearColor];
            cell.accessoryView=labelValue;
            cell.editingAccessoryView=labelValue;
            //[labelValue release];
            
        }else {
            
            cell.textLabel.text=[[userListArray objectAtIndex:indexPath.row] objectForKey:@"passenger_name"];
            cell.textLabel.backgroundColor=[UIColor clearColor];
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            cell.accessoryView=nil;
            cell.editingAccessoryView=nil;
        }
        
        
        
    }
    
    return cell ;
}


-(void)changeSex:(UISegmentedControl*)segControl
{
    if(segControl.selectedSegmentIndex==0)
    {
        [self.dataDict setObject:@"男" forKey:@"sex"];
        
    }else {
        [self.dataDict setObject:@"女" forKey:@"sex"];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidUnload
{
    [super viewDidUnload];
    [segControlTop release];
}
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    //    [[NSNotificationCenter defaultCenter] addObserver:self
    //                                             selector:@selector(keyboardWasShown:)
    //                                                 name:UIKeyboardDidChangeFrameNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    
    isKeyBoardShow=YES;
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    mainTableView.contentInset = contentInsets;
    mainTableView.scrollIndicatorInsets = contentInsets;
    
    NSIndexPath* indexPath=   [mainTableView indexPathForRowAtPoint:[activeField convertPoint:CGPointMake(10, 10) toView:self.mainTableView]];
    [self.mainTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    
    isKeyBoardShow=NO;
    
    [UIView animateWithDuration:0.3 animations:^{
        UIEdgeInsets contentInsets = UIEdgeInsetsZero;
        mainTableView.contentInset = contentInsets;
        mainTableView.scrollIndicatorInsets = contentInsets;
    }];
    
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeField = textField;
    if (isKeyBoardShow) {
        
        NSIndexPath* indexPath=   [mainTableView indexPathForRowAtPoint:[activeField convertPoint:CGPointMake(10, 10) toView:self.mainTableView]];
        [self.mainTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeField = nil;
    if ([[UIDevice currentDevice].systemVersion floatValue]<5.0) {
        
        NSIndexPath* indexPath=   [mainTableView indexPathForRowAtPoint:[textField convertPoint:CGPointMake(10, 10) toView:self.mainTableView]];
        [self.dataDict setValue:textField.text forKey: [[[self.tableArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"id"]];
        
    }
    else {
        
        if (textField.accessibilityLabel&& ![textField.accessibilityLabel isEqualToString:@""]) {
            [self.dataDict setValue:textField.text forKey:textField.accessibilityLabel];
        }
        
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (userInfoKey==UserInfoOther) {
        TravelCompanionInfoViewController* controller=[[TravelCompanionInfoViewController alloc] init];
        controller.userDataDict=[self.userListArray objectAtIndex:indexPath.row];
       // controller.title=[self.userListArray
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
    }
}

-(void)onAddNewCustomClick
{
    
    if (mainTableView.isEditing) {
        [self editContent];
    }
    
    
    AddTravelCompanionViewController* controller=[[AddTravelCompanionViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

-(UIBarButtonItem*)myEditButtonItem
{
    NGCustomButton* subButton=[[NGCustomButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [subButton addTarget:self action:@selector(editContent) forControlEvents:UIControlEventTouchUpInside];
    subButton.titleLabel.text=mainTableView.isEditing?@"完成":@"编辑";
    UIBarButtonItem* btn=[[UIBarButtonItem alloc] initWithCustomView:subButton];
    return [btn autorelease];
}

-(void)editCancle
{
    [mainTableView setEditing:!mainTableView.isEditing animated:NO ];
    
    [UIView transitionWithView:self.view duration:0.6 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^
     {
         
     }completion:nil];
    segControlTop.hidden=NO;
    mainTableView.frame=CGRectMake(0, 50, mainTableView.frame.size.width, mainTableView.frame.size.height-50);

    
    [self showCustomBackButton];
    self.navigationItem.rightBarButtonItem=[self myEditButtonItem];

}
@end
