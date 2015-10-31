//
//  MasterViewController.m
//  Macoun2015
//
//  Created by Philip Schneider on 19.10.15.
//  Copyright © 2015 Philip Schneider. All rights reserved.
//

#import "MasterViewController.h"
#import "AppleMapsDetailViewController.h"

@interface MasterViewController ()

@property NSMutableArray *objects;
@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"Demos";
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];

//    for (int i=0; i < 18; i++)
//    {
//        [self insertNewObject:nil];
//    }
}

- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Warning"
                                                                   message:@"running out of memory"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)insertNewObject:(id)sender {
    if (!self.objects) {
        self.objects = [[NSMutableArray alloc] init];
    }
    
    
    NSDictionary *newObject = nil;
    switch ([self.objects count]) {
        case 0:
            newObject = @{@"name" : @"Apple Maps", @"segue" : @"AppleMaps", @"controller" : @"AppleMapsDetailViewController"};
            break;
        case 1:
            newObject = @{@"name" : @"OpenStreetMap",  @"segue" : @"OpenStreetMap", @"controller" : @"OSMMapsDetailViewController"};
            break;
        case 2:
            newObject = @{@"name" : @"Hillshading mit Apple Maps (above roads)",  @"segue" : @"AppleShadingAboveRoads", @"controller" : @"AppleShadingMapsAboveRoadsDetailViewController"};
            break;
        case 3:
            newObject = @{@"name" : @"Hillshading (above labels)",  @"segue" : @"AppleShadingAboveLabels", @"controller" : @"AppleShadingMapsAboveLabelsDetailViewController"};
            break;
        case 4:
            newObject = @{@"name" : @"Hillshading (above roads & replace)",  @"segue" : @"AppleShadingAboveRoadsAndReplace", @"controller" : @"AppleShadingMapsAboveRoadsAndReplaceDetailViewController"};
            break;
           
        case 5:
            newObject = @{@"name" : @"Hillshading (above labels & replace)",  @"segue" : @"AppleShadingAboveLabelsAndReplace", @"controller" : @"AppleShadingMapsAboveLabelsAndReplaceDetailViewController"};
            break;

        case 6:
            newObject = @{@"name" : @"HillShading mit OpenStreetMap",  @"segue" : @"OSMShading", @"controller" : @"OSMShadingMapsDetailViewController"};
            break;
            
        case 7:
            newObject = @{@"name" : @"Apple Maps & Grid Tile",  @"segue" : @"AppleGridTile", @"controller" : @"AppleMapsGridTileDetailViewController"};
            break;
            
        case 8:
            newObject = @{@"name" : @"Openptmap",  @"segue" : @"Openptmap", @"controller" : @"OSMOpenTpMapsDetailViewController"};
            break;
            
            // Caching
        case 9:
            newObject = @{@"name" : @"OSM Caching",  @"segue" : @"OsmCached", @"controller" : @"OSMMapsSwitchingTemplatesDetailViewController"};
            break;
            
        case 10:
            newObject = @{@"name" : @"Speichere Tiles",  @"segue" : @"SavedTiles", @"controller" : @"OSMMapsSaveTIlesDetailViewController"};
            break;
            
        case 11:
            newObject = @{@"name" : @"Mitgelieferte Tiles",  @"segue" : @"BundledTiles", @"controller" : @"OSMBundledMapsDetailViewController"};
            break;
                        
        case 12:
            newObject = @{@"name" : @"Wechselnde Tiles",  @"segue" : @"SwitchingTiles", @"controller" : @"OSMMapsSwitchingTemplatesDetailViewController"};
            break;
            
        case 13:
            newObject = @{@"name" : @"OSM Pois",  @"segue" : @"OSMpoi", @"controller" : @"OSMMapsAndPoisDetailsViewController"};
            break;

        case 14:
            newObject = @{@"name" : @"OSM Ways",  @"segue" : @"OSMWay", @"controller" : @"OSMMapsAndWaysDetailsViewController"};
            break;
            
        case 15:
            newObject = @{@"name" : @"MapBox - RunBikeHike",  @"segue" : @"MapBoxRunBikeHike", @"controller" : @"PSMapBoxRunBikeHikeDetailViewController"};
            break;
            
        case 16:
            newObject = @{@"name" : @"MapBox - Custom",  @"segue" : @"MapBoxCustom", @"controller" : @"PSMapBoxCustomDetailViewController"};
            break;
            
        case 17:
            newObject = @{@"name" : @"Flyover",  @"segue" : @"AppleMapsFlyOver", @"controller" : @"AppleMapsFlyoverDetailViewController"};
            break;
            
            
        default:
            break;
    }
    
    if (newObject)
    {
        [self.objects insertObject:newObject atIndex:0];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSDictionary *object = self.objects[indexPath.row];
    UIViewController *controller = [[segue destinationViewController] topViewController];
    controller.title = [object valueForKey:@"name"];
    controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
    controller.navigationItem.leftItemsSupplementBackButton = YES;
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    NSDictionary *object = self.objects[indexPath.row];
    cell.textLabel.text = [object valueForKey:@"name"];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (void) tableView:(nonnull UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    NSDictionary *object = self.objects[indexPath.row];
    [self performSegueWithIdentifier:[object valueForKey:@"segue"] sender:self];
}
@end
