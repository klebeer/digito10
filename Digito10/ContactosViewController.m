//
//  ContactosViewController.m
//  ContactosEC
//
//  Created by Kleber Ayala Leon on 8/11/12.
//  Copyright (c) 2012 Kleber Ayala Leon. All rights reserved.
//

#import "ContactosViewController.h"
#import "Contacto.h"
#import "ContactosDAO.h"
#import "ContactosCell.h"
#import "AvatarLoader.h"


@interface ContactosViewController ()
- (void)startAvatarLoad:(Contacto *)contacto forIndexPath:(NSIndexPath *)indexPath;
@end

@implementation ContactosViewController
@synthesize imageAvatarsInProgress;

#pragma mark

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.contactos=[NSMutableArray arrayWithArray: [[ContactosDAO singleton] listarContactos]];
    self.imageAvatarsInProgress = [NSMutableDictionary dictionary];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // terminate all pending download connections
    NSArray *allDownloads = [self.imageAvatarsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.contactos count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ContactosCell";
    
    
    // add a placeholder cell while waiting on table data
    int numeroContactos = [self.contactos count];
	
    
    ContactosCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if(numeroContactos>0)
    {
        Contacto *contacto=[self.contactos objectAtIndex:indexPath.row];
        
        [cell.nombreLabel setText: [contacto nombreCompleto]];
        
        [cell.movilLabel setText:[[contacto listarCelularesActualizados] objectAtIndex:0]];
        
        if(!contacto.avatar)
        {
            if (self.tableView.dragging == NO && self.tableView.decelerating == NO)
            {
                [self startAvatarLoad:contacto forIndexPath:indexPath];
            }
            
            cell.avatarImageView.image = [UIImage imageNamed:@"blank_avatar.png"];
            
        }else
        {
            cell.avatarImageView.image = contacto.avatar;
            
        }
    }
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 77.0f;
}
/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}


//cuando la imagen se ha cargado el delegado le informa
- (void)avatarCargado:(NSIndexPath *)indexPath
{
    AvatarLoader *avatarLoader = [imageAvatarsInProgress objectForKey:indexPath];
    if (avatarLoader != nil)
    {
        ContactosCell *cell = (ContactosCell *)[self.tableView cellForRowAtIndexPath:avatarLoader.indexPathInTableView];
        cell.avatarImageView.image = avatarLoader.contacto.avatar;
        
    }
}

- (void)cancelDownload
{
    
    
}

- (void)cargarImagenesEnFilas
{
    if ([self.contactos count] > 0)
    {
        NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            Contacto *contacto = [self.contactos objectAtIndex:indexPath.row];
            
            if (!contacto.avatar)
            {
                [self startAvatarLoad:contacto forIndexPath:indexPath];
            }
        }
    }
}

- (void)startAvatarLoad:(Contacto *)contacto forIndexPath:(NSIndexPath *)indexPath
{
    AvatarLoader *avatarLoader = [imageAvatarsInProgress objectForKey:indexPath];
    if (avatarLoader == nil)
    {
        avatarLoader = [[AvatarLoader alloc] init];
        avatarLoader.contacto = contacto;
        avatarLoader.indexPathInTableView = indexPath;
        avatarLoader.delegate = self;
        [imageAvatarsInProgress setObject:avatarLoader forKey:indexPath];
        [avatarLoader startLoad];
    }
}


#pragma mark -
#pragma mark Deferred image loading (UIScrollViewDelegate)

// Load images for all onscreen rows when scrolling is finished
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
	{
        [self cargarImagenesEnFilas];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self cargarImagenesEnFilas];
}

@end
