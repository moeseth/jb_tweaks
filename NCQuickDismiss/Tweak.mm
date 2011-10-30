#define imagePath @"/Applications/AppStore.app/CloseBox.png"

static UIButton *bulletinCloseBtn = nil;
static UIButton *bannerCloseBtn = nil;

@interface SBBulletinListView
- (void) hideBoardNow;
@end

@interface SBBannerAndShadowView : UIView
@end

@interface SBBulletinBannerController
- (void) hideBannerNow;
@end

%hook SBBulletinListView
-(id)linenView
{
    UIView *view = MSHookIvar <UIView *> (self, "_slidingView");
    bulletinCloseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bulletinCloseBtn.frame = CGRectMake(view.frame.size.width - 35, view.frame.size.height - 35, 30, 30);
    [bulletinCloseBtn setImage:[UIImage imageWithContentsOfFile:imagePath] forState:UIControlStateNormal];
    [bulletinCloseBtn addTarget:self action:@selector(hideBoardNow) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:bulletinCloseBtn];
    return %orig;
}

%new(v@:)
- (void) hideBoardNow
{
    [[objc_getClass("SBBulletinListController") sharedInstance] hideListViewAnimated:YES];
}
%end

%hook SBBulletinBannerController
-(void)_presentBannerForItem:(id)item
{
    %orig;
    
    SBBannerAndShadowView *view = MSHookIvar <SBBannerAndShadowView *> (self, "_bannerAndShadowView");
    bannerCloseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) 
        bannerCloseBtn.frame = CGRectMake(view.frame.size.width - 65, 7, 30, 30);
    else
        bannerCloseBtn.frame = CGRectMake(view.frame.size.width - 35, 5, 30, 30);

    [bannerCloseBtn setImage:[UIImage imageWithContentsOfFile:imagePath] forState:UIControlStateNormal];
    [bannerCloseBtn addTarget:self action:@selector(hideBannerNow) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:bannerCloseBtn];
}

%new(v@:)
- (void) hideBannerNow
{
    [self _tryToDismissBannerWithAnimation:0];
    bannerCloseBtn.alpha = 0.0f;
}

-(void)_tearDownView
{
    bannerCloseBtn.alpha = 0.0f;
    %orig;
}
%end

















