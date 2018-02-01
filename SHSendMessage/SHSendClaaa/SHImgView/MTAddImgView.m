//
//  MTAddImgView.m
//  MTRealEstate
//
//  Created by HaoSun on 2017/6/8.
//  Copyright © 2017年 MaiTianMM. All rights reserved.
//

#import "MTAddImgView.h"
#import <MobileCoreServices/UTCoreTypes.h>
#define KImageY 0
@interface MTAddImgView()<ZYQAssetPickerControllerDelegate,ACActionSheetDelegate,MTWCPhotosViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, strong) NSMutableArray *titleArr;
@property (nonatomic, weak)  UIImageView *addImg;//加号图片
@property (nonatomic, weak)  MTWCPhotoView *photoView;//放图片的View

@end

@implementation MTAddImgView

- (instancetype)initWithController:(UIViewController *)viewController
{
    self = [super init];
    if (self) {
        self.viewController = viewController;
        self.maxPhoto = 9;
        [self setupPhotoView];
        [self resetAddImgFrame];
    }
    return self;
}

- (NSMutableArray *)imageArray{
    if (!_imageArray) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}
- (NSMutableArray *)titleArr {
    if (!_titleArr) {
        _titleArr = [NSMutableArray array];
    }
    return _titleArr;
}

#pragma mark - 图片的view
- (void)setupPhotoView {
    CGFloat margin = 12;
    CGFloat imageH = (ScreenWidth - 5 * margin) * 0.25;
    MTWCPhotoView *photoView = [[MTWCPhotoView alloc] initWithFrame:CGRectMake(0, KImageY, ScreenWidth, 300)];
    photoView.delegate = self;
    _photoView = photoView;
    [self addSubview:_photoView];
    UIImageView *addImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"circle_send_addImage"]];
    addImg.userInteractionEnabled = YES;
    [addImg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addImgIBAction)]];
    addImg.frame = CGRectMake(margin ,KImageY + margin , imageH, imageH);
    _addImg = addImg;
    [self addSubview:_addImg];
}


- (void)pictureImgIBAction{
    [self endEditing:YES];
    [self addImgIBAction];
}

- (void)photoViewRemoveImageByIndex:(NSInteger)index{
    [self.imageArray removeObjectAtIndex:index];
    [_titleArr removeObjectAtIndex:index];
    [_photoView removeObjectAtIndex:index];
    [self resetAddImgFrame];
}

- (void)addImgIBAction{
    [self endEditing:YES];
    ACActionSheet *actionSheet = [[ACActionSheet alloc] initWithTitle:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@[@"拍照",@"从手机相册选取"] actionSheetBlock:^(NSInteger buttonIndex) {
        if (self.imageArray.count>=_maxPhoto) {
            return ;
        }
        if(buttonIndex == 0){
            //拍照按钮
#if !TARGET_IPHONE_SIMULATOR
            UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
            ipc.view.backgroundColor = [UIColor whiteColor];
            ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
            ipc.delegate = self;
            [_viewController presentViewController:ipc animated:YES completion:nil];
#endif
        }
        if(buttonIndex == 1) {
            //从相册中选择
            if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusNotDetermined) {
                ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
                [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                    if (stop) {
                        //点击“好”回调方法:
                        ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
                        picker.maximumNumberOfSelection = _maxPhoto;
                        picker.delegate=self;
                        [_viewController presentViewController:picker animated:YES completion:NULL];
                    }
                    *stop = TRUE;
                } failureBlock:^(NSError *error) {
                    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
                    picker.maximumNumberOfSelection = _maxPhoto;
                    picker.delegate=self;
                    [_viewController presentViewController:picker animated:YES completion:NULL];
                }];
            }else{
                ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];

                [picker setDelegate:self];
                [picker setMaximumNumberOfSelection:(_maxPhoto - self.imageArray.count)];
                [_viewController presentViewController:picker animated:YES completion:NULL];
            }

        }
    }];
    [actionSheet show];
}


#pragma mark - ZYQAssetPickerControllerDelegate
- (void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{

    __weak typeof(self) weakSelf = self;
    for (NSUInteger i = 0; i < assets.count;i++) {
        ZYQAsset *asset = [assets objectAtIndex:i];
        asset.getThumbnail = ^(UIImage *result) {
            [weakSelf.imageArray addObject:result];
            [weakSelf.titleArr addObject:@"1"];
            [weakSelf.photoView addImage:result];
            [weakSelf resetAddImgFrame];
        };
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {

    NSString *mediaType = info[UIImagePickerControllerMediaType];
    if([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *resultImage = nil;
        if(picker.allowsEditing){
            resultImage = info[UIImagePickerControllerEditedImage];
        } else {
            resultImage = info[UIImagePickerControllerOriginalImage];
        }
        [self.imageArray addObject:resultImage];
        [_photoView addImage:resultImage];
        [self.titleArr addObject:@"1"];
        [self resetAddImgFrame];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)resetAddImgFrame{
    CGFloat margin = 12;
    CGFloat btnW = (ScreenWidth - 5 * margin) * 0.25;
    CGFloat addImgY = KImageY;
    if(_titleArr.count < _maxPhoto){
        NSInteger imgRow  = _titleArr.count%4;
        NSInteger imgLine = _titleArr.count/4;
        _addImg.frame = CGRectMake(imgRow * (btnW + margin) + margin, margin + addImgY + (margin + btnW) * imgLine, btnW, btnW);
        _addImg.hidden = NO;
    }else{
        _addImg.hidden = YES;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(getSendMailImages:)]) {
        [self.delegate getSendMailImages:_imageArray];
    }
}

- (void)setMaxPhoto:(NSInteger)maxPhoto{
    _maxPhoto = maxPhoto;
    
}


@end
