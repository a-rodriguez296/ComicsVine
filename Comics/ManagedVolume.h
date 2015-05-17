#import "_ManagedVolume.h"

@interface ManagedVolume : _ManagedVolume {}


+(NSFetchRequest *) fetchRequestForAllVolumes;

+(void) deleteAllVolumesInManagedObjectContext:(NSManagedObjectContext *) managedObjectContext;


@end
