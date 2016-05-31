//
//  YPBReigsterSecondViewController.m
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/11.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "YPBReigsterSecondViewController.h"
#import "YPBActionButton.h"
#import <ActionSheetStringPicker.h>
#import <ActionSheetMultipleStringPicker.h>
#import "YPBUser+Account.h"
#import "YPBRegisterModel.h"
#import "YPBActivateModel.h"
#import "YPBUser+Mine.h"
#import "YPBPhotoPicker.h"
#import "YPBUserAvatarUpdateModel.h"
#import <CoreLocation/CoreLocation.h>

@interface YPBReigsterSecondViewController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,CLLocationManagerDelegate>
{
    UIView *_view;
    UIImageView *_imgV;
    UITableViewCell *_jobCell;
    UITextField *_jobTextField;
    UITableViewCell *_educationCell;
    UITableViewCell *_revenuesCell;
    UITableViewCell *_heightCell;
    UITableViewCell *_marriageCell;
//    CLLocationManager *_locationManager;
}
@property (nonatomic,retain) YPBUser *user;
@property (nonatomic,retain) YPBRegisterModel *registerModel;
@property (nonatomic,retain) YPBActivateModel *activateModel;
@property (nonatomic,retain) YPBUserAvatarUpdateModel *avatarUpdateModel;
@end

@implementation YPBReigsterSecondViewController

DefineLazyPropertyInitialization(YPBRegisterModel, registerModel)
DefineLazyPropertyInitialization(YPBActivateModel, activateModel)
DefineLazyPropertyInitialization(YPBUserAvatarUpdateModel, avatarUpdateModel)

- (instancetype)initWithYPBUser:(YPBUser *)user {
    self = [super init];
    if (self) {
        _user = user;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //定位
    
//    [self locate];
    
//    UIImageView *bgImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"register_bgImg.jpg"]];
//    [self.view addSubview:bgImg];
//    [self.view sendSubviewToBack:bgImg];
//    {
//        [bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.left.right.bottom.equalTo(self.view);
//        }];
//    }

    
    // Do any additional setup after loading the view.
    self.title = @"个人资料";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f6f7ec"];
    
    _view = [[UIView alloc] init];
    _view.backgroundColor = [UIColor colorWithHexString:@"#fffff9"];
    _view.layer.cornerRadius = 55;
    _view.layer.borderWidth = 0.5;
    _view.layer.borderColor = [UIColor colorWithHexString:@"#c3c4bc"].CGColor;
    _view.layer.masksToBounds = YES;
    _view.alpha = 0.5;
    [self.view addSubview:_view];
    {
        [_view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.view);
            make.centerY.mas_equalTo(self.view).multipliedBy(0.3);
            make.size.mas_equalTo(CGSizeMake(110, 110));
        }];
    }
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photoPick"]];
    backgroundImageView.contentMode = UIViewContentModeScaleToFill;
    backgroundImageView.transform = CGAffineTransformMakeScale(1.2, 1.2);
    [_view addSubview:backgroundImageView];
    {
        [backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_view);
            make.centerY.mas_equalTo(_view).offset(-10);
        }];
    }
    
    UILabel *notilabel = [[UILabel alloc] init];
    notilabel.text = @"＊输入真实资料,可极大提高速配机会＊";
    notilabel.alpha = 0.5;
    notilabel.textAlignment = NSTextAlignmentCenter;
    notilabel.textColor = [UIColor colorWithHexString:@"262523"];
    notilabel.font = [UIFont systemFontOfSize:12.];
    notilabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:notilabel];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"上传真实头像";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithHexString:@"262523"];
    label.font = [UIFont systemFontOfSize:12.];
    label.backgroundColor = [UIColor clearColor];
    [_view addSubview:label];
    {
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_view);
            make.top.mas_equalTo(backgroundImageView.mas_bottom).offset(10);
            make.size.mas_equalTo(CGSizeMake(100, 15));
        }];
        
        [notilabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_view.mas_bottom).offset(5);
            make.right.equalTo(self.view).offset(0);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 14));
        }];
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@""
                                                                                style:UIBarButtonItemStylePlain
                                                                              handler:nil];
    
    {
        [_view bk_whenTapped:^{
            @weakify(self);
            YPBPhotoPicker *photoPicker = [[YPBPhotoPicker alloc] init];
            photoPicker.allowsEditing = YES;
            photoPicker.cameraDevice = YPBPhotoPickingCameraDeviceFront;
            [photoPicker showPickingSheetInViewController:self
                                                withTitle:@"选取头像"
                                        completionHandler:^(BOOL success,
                                                            NSArray<UIImage *> *originalImages,
                                                            NSArray<UIImage *> *thumbImages)
             {
                 if (photoPicker == nil || !success || thumbImages.count == 0) {
                     return;
                 }
                 
                 UIImage *pickedImage = originalImages[0];
                 [[YPBMessageCenter defaultCenter] showProgressWithTitle:@"头像上传中..." subtitle:nil];
                 NSString *name = [NSString stringWithFormat:@"%@_%@_avatar.jpg", [YPBUser currentUser].userId, [[NSDate date] stringWithFormat:kDefaultDateFormat]];
                 [YPBUploadManager uploadImage:pickedImage
                                      withName:name
                               progressHandler:^(double progress)
                  {
                      [[YPBMessageCenter defaultCenter] proceedProgressWithPercent:progress];
                  } completionHandler:^(BOOL success, id obj) {
                      @strongify(self);
                      [[YPBMessageCenter defaultCenter] hideProgress];
                      if (success) {
                          self.user.logoUrl = obj;
                          [[YPBMessageCenter defaultCenter] showSuccessWithTitle:@"头像更新成功" inViewController:self];
                          
                          [_view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                          [self setImgV:obj];
                      } else {
                       [[YPBMessageCenter defaultCenter] showErrorWithTitle:@"头像更新失败" inViewController:self];
                          self.user.logoUrl = @"";
                      }
                  }];
             }];
        }];
    }
    DLog("%f",SCREEN_HEIGHT);
    self.layoutTableView.layer.cornerRadius = 8;
    self.layoutTableView.rowHeight = MAX(kScreenHeight * 0.08, SCREEN_HEIGHT/15);
    self.layoutTableView.scrollEnabled = NO;
    self.layoutTableView.separatorInset = UIEdgeInsetsZero;
    self.layoutTableView.alpha = 0.5;
    [self.layoutTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        make.top.equalTo(_view.mas_bottom).offset(20);
        make.height.mas_equalTo(self.layoutTableView.rowHeight*5);
    }];
    
    @weakify(self);
    YPBActionButton *nextButton = [[YPBActionButton alloc] initWithTitle:@"进入同城速配" action:^(id sender) {
        @strongify(self);
        
        if (!self) {
            return ;
        }
        
        @weakify(self);
        void (^RegisterBlock)(void) = ^{
            @strongify(self);
            [self.registerModel requestRegisterUser:self.user withCompletionHandler:^(BOOL success, id obj) {
                @strongify(self);
                if (!self) {
                    return ;
                }
                
                if (success) {
                    [self onRegisterSuccessfullyWithUserId:obj];
                } else {
                    [self.view endLoading];
                }
            }];
        };
        
        [self.view beginLoading];
        if ([YPBUtil activationId].length == 0) {
            [self.activateModel requestActivationWithCompletionHandler:^(BOOL success, id obj) {
                if (success) {
                    self.user.uuid = obj;
                    [YPBUtil setActivationId:obj];
                    RegisterBlock();
                } else {
                    [self.view endLoading];
                    YPBShowWarning(@"注册失败,请稍后再试");
                }
            }];
        } else {
            RegisterBlock();
        }
    }];
    
    [self.view addSubview:nextButton];
    {
        
        [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.layoutTableView).offset(10);
            make.right.equalTo(self.layoutTableView).offset(-10);
            make.top.equalTo(self.layoutTableView.mas_bottom).offset(SCREEN_HEIGHT/16);
            make.height.mas_equalTo(self.layoutTableView.rowHeight);
        }];
    }
    
    [self initLayoutCells];
    
    if (self.user.logoUrl.length > 0) {
        [self setImgV:self.user.logoUrl];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = NO;
}

- (void)setImgV:(NSString *)imgUrl {
    if (_imgV == nil) {
        _imgV = [[UIImageView alloc] init];
        _imgV.userInteractionEnabled = YES;
        _imgV.layer.cornerRadius = _imgV.frame.size.width/2;
        [_view addSubview:_imgV];
        {
            [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.bottom.right.equalTo(_view);
            }];
        }
    }
    
    [_imgV sd_setImageWithURL:[NSURL URLWithString:imgUrl]];
    
}

- (void)showImagePickerVCWithType:(UIImagePickerControllerSourceType)type {
    //创建pickerVC
    UIImagePickerController * pickerVC = [[UIImagePickerController alloc] init];
    //设置图片来源类型:可以是相机  相册
    /*
     UIImagePickerControllerSourceTypePhotoLibrary, 相册
     UIImagePickerControllerSourceTypeCamera, 相机
     UIImagePickerControllerSourceTypeSavedPhotosAlbum
     */
    pickerVC.sourceType = type;
    //是否可编辑
    pickerVC.allowsEditing = YES;
    //设置代理
    pickerVC.delegate = self;
    //弹出pickerVC动画
    [self presentViewController:pickerVC animated:YES completion:nil];
    
}

- (void)initLayoutCells {
    _jobCell = [[UITableViewCell alloc] init];
    _jobCell.backgroundColor = [UIColor colorWithHexString:@"#fffffd"];
    _jobCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setLayoutCell:_jobCell inRow:0 andSection:0];
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"职业";
    titleLabel.font = [UIFont systemFontOfSize:15.];
    [_jobCell addSubview:titleLabel];
    {
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_jobCell);
            make.left.equalTo(_jobCell).offset(15);
            make.width.mas_equalTo(35);
        }];
    }
    
    _jobTextField = [[UITextField alloc] init];
    _jobTextField.placeholder = @"请输入职业";
    [_jobTextField setValue:[UIColor colorWithHexString:@"#989994"] forKeyPath:@"_placeholderLabel.textColor"];
    [_jobTextField setValue:[UIFont systemFontOfSize:16.] forKeyPath:@"_placeholderLabel.font"];
    _jobTextField.textAlignment = NSTextAlignmentRight;
    _jobTextField.delegate = self;
    _jobTextField.returnKeyType = UIReturnKeyNext;
    _jobTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _user.profession = @"";
    [_jobCell addSubview:_jobTextField];
    {
        [_jobTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleLabel.mas_right).offset(20);
            make.top.right.bottom.equalTo(_jobCell).insets(UIEdgeInsetsMake(5, 0, 5, 15));
        }];
    }
    {
        [_jobTextField bk_whenTapped:^{
            [_jobTextField becomeFirstResponder];
        }];
    }

    
//    _educationCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
//    _educationCell.backgroundColor = [UIColor colorWithHexString:@"#fffffd"];
//    _educationCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    _educationCell.textLabel.text = @"学历";
//    _educationCell.textLabel.font = [UIFont systemFontOfSize:15.];
//    self.user.selfEducation = YPBUserEducationE;
//    _user.edu = self.user.selfEducationDescription;
//    _educationCell.detailTextLabel.text = self.user.edu;
//    [self setLayoutCell:_educationCell inRow:1 andSection:0];
    
    _revenuesCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    _revenuesCell.backgroundColor = [UIColor colorWithHexString:@"#fffffd"];
    _revenuesCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    _revenuesCell.textLabel.text = @"收入";
    _revenuesCell.textLabel.font = [UIFont systemFontOfSize:15.];
    _revenuesCell.detailTextLabel.text = @"您的收入";
    _user.monthIncome = @"";
    [self setLayoutCell:_revenuesCell inRow:1 andSection:0];
    
    _heightCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    _heightCell.backgroundColor = [UIColor colorWithHexString:@"#fffffd"];
    _heightCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    _heightCell.textLabel.text = @"身高";
    _heightCell.textLabel.font = [UIFont systemFontOfSize:15.];
    _heightCell.detailTextLabel.text = @"您的身高";
    [self setLayoutCell:_heightCell inRow:2 andSection:0];
    
//    _marriageCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
//    _marriageCell.backgroundColor = [UIColor colorWithHexString:@"#fffffd"];
//    _marriageCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    _marriageCell.textLabel.text = @"婚姻";
//    _marriageCell.textLabel.font = [UIFont systemFontOfSize:15.];
//    self.user.selfMarriage = YPBUserMarriageA;
//    _user.marry = self.user.selfMarriageDescripiton;
//    _marriageCell.detailTextLabel.text = self.user.marry;
//    [self setLayoutCell:_marriageCell inRow:4 andSection:0];
}

- (void)onRegisterSuccessfullyWithUserId:(NSString *)uid {
    [[YPBMessageCenter defaultCenter] showSuccessWithTitle:@"注册成功" inViewController:self];
    
    @weakify(self);
    [self bk_performBlock:^(id receiver) {
        @strongify(self);
        [[YPBMessageCenter defaultCenter] dismissMessageWithCompletion:^{
            self.user.userId = uid;
            [self.user saveAsCurrentUser];
            [self dismissViewControllerAnimated:YES completion:nil];
            [YPBUtil notifyRegisterSuccessfully];
        }];
        
    } afterDelay:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    @weakify(self);
    if (indexPath.row == 0) {
        //不做处理
    } else if (indexPath.row == 1) {
        NSArray *allIncomes = [YPBUser allIncomeStrings];
        NSUInteger index = self.user.incomeIndex;
        
        @weakify(self);
        [ActionSheetStringPicker showPickerWithTitle:@"请选择收入范围"
                                                rows:allIncomes
                                    initialSelection:index
                                           doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue)
         {
             @strongify(self);
             [self.user setIncomeWithIndex:selectedIndex];
             self->_revenuesCell.detailTextLabel.text = selectedValue;
         } cancelBlock:nil origin:self.view];
//        [ActionSheetStringPicker showPickerWithTitle:@"请选择您的学历"
//                                                rows:[YPBUser allEducationsDescription]
//                                    initialSelection:self.user.valueIndexOfSelfEducation
//                                           doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue)
//         {
//             @strongify(self);
//             [self.user setSelfEducationWithString:selectedValue];
//             self->_educationCell.detailTextLabel.text = self.user.selfEducationDescription;
//         } cancelBlock:nil origin:self.view];
    } else if (indexPath.row == 2) {
        @weakify(self);
        NSArray *allHeights = [YPBUser allHeightStrings];
        NSUInteger index = self.user.heightIndex;
        [ActionSheetStringPicker showPickerWithTitle:@"请选择您的身高"
                                                rows:allHeights
                                    initialSelection:index
                                           doneBlock:^(ActionSheetStringPicker *picker,
                                                       NSInteger selectedIndex,
                                                       id selectedValue)
         {
             @strongify(self);
             [self.user setHeightWithIndex:selectedIndex];
             self->_heightCell.detailTextLabel.text = self.user.heightDescription;
         } cancelBlock:nil origin:self.view];
    } else if (indexPath.row == 3) {

    } else if (indexPath.row == 4) {
//        [ActionSheetStringPicker showPickerWithTitle:@"请设置您的近况"
//                                                rows:[YPBUser allMarriageDescription]
//                                    initialSelection:self.user.valueIndexOfSelfMarriage
//                                           doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue)
//         {
//             @strongify(self);
//             [self.user setSelfMarriageWithString:selectedValue];
//             self->_marriageCell.detailTextLabel.text = self.user.selfMarriageDescripiton;
//         } cancelBlock:nil origin:self.view];
    }
}

//#pragma mark - 代理方法
////在用户选择完图片以后调用 可以拿到用户选择的图片
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
//    NSLog(@"%@",info);
//    //使pickerVC消失
//    [picker dismissViewControllerAnimated:YES completion:nil];
//    [_view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//    UIImageView *imgV = [[UIImageView alloc] init];
//    imgV.image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
//    imgV.userInteractionEnabled = YES;
//    imgV.layer.cornerRadius = imgV.frame.size.width/2;
//    [_view addSubview:imgV];
//    {
//        [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.left.bottom.right.equalTo(_view);
//        }];
//    }
//}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UITextFieldDelegate
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_jobTextField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [_jobTextField resignFirstResponder];
    return YES;
}

- (BOOL)disablesAutomaticKeyboardDismissal {
    return NO;
}

//#pragma mark - CLLocationManager
//- (void)locate {
//    _locationManager = [[CLLocationManager alloc] init];
//    _locationManager.delegate = self;
//    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//    _locationManager.distanceFilter = kCLDistanceFilterNone;
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
//        [_locationManager requestAlwaysAuthorization];
//    }
//    [_locationManager startUpdatingLocation];
//    
//}
//
//- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(nonnull NSArray<CLLocation *> *)locations {
//    CLLocation *currentLocation = [locations lastObject];
//    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
//    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
//        if (placemarks.count > 0) {
//            CLPlacemark *placemark = [placemarks objectAtIndex:0];
//            DLog("%@ %@",placemark.administrativeArea,placemark.locality);
//            _user.province = placemark.administrativeArea;
//            _user.city = placemark.locality;
//            self.navigationItem.rightBarButtonItem.title = placemark.locality;
//        }
//    }];
//}



@end
