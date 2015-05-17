#import "ManagedVolume.h"

@interface ManagedVolume ()

// Private interface goes here.

@end

@implementation ManagedVolume

// Custom logic goes here.


-(void)awakeFromInsert{
    [super awakeFromInsert];
    self.insertionDate = [NSDate date];
    
}


+(NSFetchRequest *) fetchRequestForAllVolumes{
    
    NSFetchRequest *fr = [NSFetchRequest fetchRequestWithEntityName:[ManagedVolume entityName]];
    [fr setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:ManagedVolumeAttributes.insertionDate ascending:YES]]];
    [fr setFetchBatchSize:20];
    return fr;
}

+(void) deleteAllVolumesInManagedObjectContext:(NSManagedObjectContext *) managedObjectContext{
    
    NSFetchRequest *fr = [self fetchRequestForAllVolumes];
    
    //Al momento de hacer el fetch no es necesario traer los property values. Esto agiliza el borrado
    [fr setIncludesPropertyValues:NO];
    
    NSArray *volumes = [managedObjectContext executeFetchRequest:fr error:NULL];
    for (NSManagedObject *volume in volumes) {
        [managedObjectContext deleteObject:volume];
    }
}

@end
