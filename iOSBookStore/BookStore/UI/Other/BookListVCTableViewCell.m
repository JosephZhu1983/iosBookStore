//
//  BookListVCTableViewCell.m
//  BookStore
//
//  Created by Ye Zhu on 8/26/12.
//
//

#import "BookListVCTableViewCell.h"
#import "BookController.h"
#import "TextStepperField.h"
#import "SVProgressHUD.h"
#import "ShoppingCartController.h"

@interface BookListVCTableViewCell()

@property (nonatomic, weak) IBOutlet UIButton *addtocartButton;
@property (nonatomic, weak) IBOutlet UILabel *booknameLabel;
@property (nonatomic, weak) IBOutlet UILabel *bookcategoryLabel;
@property (nonatomic, weak) IBOutlet UILabel *bookpriceLabel;
@property (nonatomic, weak) IBOutlet UIImageView *bookImage;
@property (nonatomic, weak) IBOutlet TextStepperField *bookcountStepper;


@end

@implementation BookListVCTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)configureForBook:(Book*)book
{
    [self.addtocartButton addTarget:self action:@selector(addtoShoppingCart:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.bookcountStepper setCurrent:1];
    [self.bookcountStepper setMaximum:99];
    [self.bookcountStepper setMinimum:1];
    [self.bookcountStepper setIsEditableTextField:NO];
    
    self.booknameLabel.text = book.bookname;
    self.bookcategoryLabel.text = book.categoryname;
    self.bookpriceLabel.text = [[book.bookprice stringValue ] stringByAppendingString:NSLocalizedString(@"元", nil)];
    
    [self setbookImage:book.imagename];
    self.tag = book.bookid;
}

-(void)setbookImage:(NSString*)imagename
{
    [[BookController instance] setBookImage:imagename onImageView:self.bookImage];
}

- (void)configureForShoppingCart:(ShoppingCart*)cart
{
    [self.addtocartButton addTarget:self action:@selector(updateShoppingCart:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.bookcountStepper setCurrent:cart.qty];
    [self.bookcountStepper setMaximum:99];
    [self.bookcountStepper setMinimum:0];
    [self.bookcountStepper setIsEditableTextField:NO];
    
    self.booknameLabel.text = cart.bookname;
    self.bookcategoryLabel.text = cart.categoryname;
    self.bookpriceLabel.text = [[cart.bookprice stringValue ] stringByAppendingString:NSLocalizedString(@"元", nil)];
    
    [self.addtocartButton setTitle:NSLocalizedString(@"修改数量", nil) forState:UIControlStateNormal];
    [self setbookImage:cart.imagename];
    self.tag = cart.bookid;
}

- (void)prepareForReuse
{
}

- (void)addtoShoppingCart:(id)sender
{
    NSInteger bookid = self.tag;
    [[ShoppingCartController instance] addShoppingCartWithBookid:bookid andQty: self.bookcountStepper.Current];
    [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"加入购物车成功", nil)];
}

- (void)updateShoppingCart:(id)sender
{
    NSInteger bookid = self.tag;
    [[ShoppingCartController instance] updateShoppingCartWithBookid:bookid andQty: self.bookcountStepper.Current];
    if (self.bookcountStepper.Current == 0)
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"删除了一种图书", nil)];
    else
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"修改数量成功", nil)];
    if (self.delegate)
        [self.delegate updateShoppingCart];
}

@end
