//
//  FlyViewController.m
//  Yorker
//
//  Created by 肖逸飞 on 14-3-4.
//  Copyright (c) 2014年 SCU. All rights reserved.
//



#import "FlyViewController.h"
#import "Cell.h"
#import "FlyTableViewController.h"

#define kNumberOfPages               4

NSString* kDetailedViewControllerID = @"DetailView";    // view controller storyboard id
NSString* kCellID                  =  @"cellID";                          // UICollectionViewCell storyboard id


@interface FlyViewController ()
{
    NSMutableArray* pages;
    NSArray* cellNames;
    NSMutableArray *cellContentArray;
    
    __weak IBOutlet UIPageControl *pageCtl;
    __weak IBOutlet UIScrollView *pagesView;
    __weak IBOutlet UICollectionView *collectionView;
}
@end

@implementation FlyViewController
#pragma mark -
#pragma mark System Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addPages];
    [self initCollectCells];
	// Do any additional setup after loading the view, typically from a nib.
}

-(void)initCollectCells
{
    
    cellNames =[ [NSArray alloc]initWithObjects:@"体育",@"游戏",@"棋牌",@"桌游",@"旅游",@"娱乐", nil];
    
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Normal Methods
-(void)addPages
{
     [pagesView setContentSize:CGSizeMake(280*kNumberOfPages, 132)];
    CGSize size;
    size.height = 132;
    size.width = 280;
    
    for (int i=1; i<kNumberOfPages+1; i++) {
        UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake((0+(i-1)*280),0, 280 , 132)];
        UIImage *image = [UIImage imageNamed:  [NSString stringWithFormat:@"background%d.png",i] ];
//        NSLog(@"image->height=%f,image->width=%f",image.size.height,image.size.width);
        image = [self reSizeImage:image toSize:size];
//        NSLog(@"after change : image->height=%f,image->width=%f,imageView size=%f",image.size.height,image.size.width,imageView.frame.size.width+imageView.frame.size.height);
//        NSLog(@"%f,%f",pagesView.frame.size.height+pagesView.frame.size.width,pagesView.contentSize.height+pagesView.contentSize.width);
        [imageView setImage:image];
        [pagesView addSubview:imageView];
    }
    pagesView.pagingEnabled = YES;

    
    pagesView.bounces = NO;//是否触碰到内容边界有弹回效果，NO-——没有
    pagesView.showsHorizontalScrollIndicator = NO;
    
    [pageCtl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
    
    
    
    
}
- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize

{
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return reSizeImage;
    
}
-(void)pageTurn:(UIPageControl*)sender
{
    CGSize viewSize = pagesView.frame.size;
    CGRect rect = CGRectMake(sender.currentPage*viewSize.width, 0,viewSize.width, viewSize.height);
    [pagesView scrollRectToVisible:rect animated:YES];
    
}
#pragma mark - 
#pragma mark ScrollView Delegate Methods
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //更新pageCtl当前页
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.frame;
    [pageCtl setCurrentPage:offset.x/bounds.size.width ];
//    NSLog(@"%d",pageCtl.currentPage);
}
#pragma mark - 
#pragma mark CollectionView Data Source
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    return 6;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    // we're going to use a custom UICollectionViewCell, which will hold an image and its label
    //
    Cell *cell = [cv dequeueReusableCellWithReuseIdentifier:kCellID forIndexPath:indexPath];
    
    // make the cell's title the actual NSIndexPath value
    cell.label.text = [cellNames objectAtIndex:indexPath.row];
    
    // load the image for this cell
    NSString *imageToLoad = [NSString stringWithFormat:@"%ld.JPG", indexPath.row];
    cell.image.image = [UIImage imageNamed:imageToLoad];
    
    return cell;
}
// the user tapped a collection item, load and set the image on the detail view controller
//
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"])
    {
        NSIndexPath *selectedIndexPath = [[collectionView indexPathsForSelectedItems] objectAtIndex:0];
        
        // load the image, to prevent it from being cached we use 'initWithContentsOfFile'
//        NSString *imageNameToLoad = [NSString stringWithFormat:@"%d_full", selectedIndexPath.row];
//        NSString *pathToImage = [[NSBundle mainBundle] pathForResource:imageNameToLoad ofType:@"JPG"];
//        UIImage *image = [[UIImage alloc] initWithContentsOfFile:pathToImage];
        
        FlyTableViewController *tableViewController = [segue destinationViewController];
        tableViewController.title = cellNames[selectedIndexPath.row];
    }
}
@end
