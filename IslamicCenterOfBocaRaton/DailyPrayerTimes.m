//
//  DailyPrayerTimes.m
//  IslamicCenterOfBocaRaton
//
//  Created by Hashim Shafique on 3/30/11.
//  Copyright 2011 Siemens Enterprise. All rights reserved.
//

#import "DailyPrayerTimes.h"
#import <sqlite3.h>

@implementation DailyPrayerTimes
@synthesize asr = asr_;
@synthesize fajr = fajr_;
@synthesize shurooq = shurooq_;
@synthesize dhohur = dhohur_;
@synthesize maghrib = maghrib_;
@synthesize isha = isha_;
@synthesize month = month_;
@synthesize day = day_;
@synthesize year = year_;
@synthesize ifStatus = ifStatus_;

-(id)init
{
    fajr_ = [[NSString alloc] init];
    shurooq_ = [[NSString alloc] init];
    dhohur_ = [[NSString alloc] init];
    asr_ = [[NSString alloc] init];
    maghrib_ = [[NSString alloc] init];
    isha_ = [[NSString alloc] init];
    value_ = [[NSMutableString alloc] init];
    tableNeedsToBeUpdated_ = YES;
    currentMonthUsedforQuery_ = 5;

    return self;
}

-(NSString *)dataFilePath:(NSString*)filename
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:filename];
}

-(BOOL)initDatabase
{
    sqlite3 *database;
    if (sqlite3_open([[self dataFilePath:kFilename] UTF8String], &database) != SQLITE_OK)
    {
        sqlite3_close(database);
        NSLog(@"Failed to open database");
    }
    // this check should be replaced with a check to see if the table exists
    // if it does, it is OK to exit here as we assume the data has already been
    // populdated
    char *errorMsg;
 
    /*NSString *dropSQL = @"DROP TABLE PRAYER_TABLE;";
    
    if (sqlite3_exec(database, [dropSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK)
    {
        // if table exists, the data is already in the sql database, exit here
        //if (strcmp("no such table: PRAYER_TABLE", errorMsg) != 0)
        //{
        //sqlite3_close(database);
        NSLog(@"table already exists %s", errorMsg);  
        //return;
    }
    
    NSString *dropIqamaSQL = @"DROP TABLE IQAMA_TABLE;";
    
    if (sqlite3_exec(database, [dropIqamaSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK)
    {
        // if table exists, the data is already in the sql database, exit here
        //if (strcmp("no such table: PRAYER_TABLE", errorMsg) != 0)
        //{
        //sqlite3_close(database);
        NSLog(@"table already exists %s", errorMsg);  
        //return;
    }*/
    
    // check if table exists, if it does exit now as the data is already loaded
    NSString *tableExists = @"SELECT * FROM PRAYER_TABLE";
    if (sqlite3_exec(database, [tableExists UTF8String], NULL, NULL, &errorMsg) == SQLITE_OK)
    {
        // table exists close database and exit
        sqlite3_close(database);
        NSLog(@"table already exists %s", errorMsg);  
        tableNeedsToBeUpdated_ = NO;
        NSLog(@"parsing completed");
        self.ifStatus = @"DONE";
        return NO;
    }
    
    
    NSString *createSQL = @"CREATE TABLE PRAYER_TABLE (MONTH TEXT, DAY TEXT, YEAR TEXT, FAJR TEXT, SUNRISE TEXT, DHOHUR TEXT, ASR TEXT, MAGHRIB TEXT, ISHA TEXT);";
    
    if (sqlite3_exec(database, [createSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK)
    {
        // if table exists, the data is already in the sql database, exit here
        sqlite3_close(database);
        NSLog(@"table already exists %s", errorMsg);  
        return YES;
    }
    
    // now let's create the iqama table
    NSString *createIqamaSQL = @"CREATE TABLE IQAMA_TABLE (MONTH TEXT, DAY TEXT, YEAR TEXT, WEEKDAY TEXT, HIJMONTH TEXT, HIJDAY TEXT, HIJYEAR TEXT, FAJR TEXT, SUNRISE TEXT, DHOHUR TEXT, ASR TEXT, MAGHRIB TEXT, ISHA TEXT);";

    if (sqlite3_exec(database, [createIqamaSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK)
    {
        // if table exists, the data is already in the sql database, exit here
        sqlite3_close(database);
        NSLog(@"table already exists %s", errorMsg);  
        return YES;
    }
    
    sqlite3_close(database);
    [self insertIqamaRowIntoDatabase];
    return YES;
    
}
-(void)removePrayerTable
{
    sqlite3 *database;
    if (sqlite3_open([[self dataFilePath:kFilename] UTF8String], &database) != SQLITE_OK)
    {
        sqlite3_close(database);
        NSLog(@"Failed to open database");
    }
    
    char *errorMsg;
    NSString *dropSQL = @"DROP TABLE PRAYER_TABLE;";
    
    if (sqlite3_exec(database, [dropSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK)
    {
        // if table exists, the data is already in the sql database, exit here
        //if (strcmp("no such table: PRAYER_TABLE", errorMsg) != 0)
        //{
        //sqlite3_close(database);
        NSLog(@"table does not exist %s", errorMsg);  
        //return;
    }
    
}

-(void)getdataFromDatabase
{
    NSLog(@"into get row from database");
    sqlite3 *database;
    if (sqlite3_open([[self dataFilePath:kFilename] UTF8String], &database) != SQLITE_OK)
    {
        sqlite3_close(database);
        NSLog(@"Failed to open database");
    }

    NSString *selectSQL = [NSString stringWithFormat: @"SELECT MONTH, DAY, YEAR, FAJR, SUNRISE, DHOHUR, ASR, MAGHRIB, ISHA FROM PRAYER_TABLE WHERE month=\"4\""];

    const char *select_stmt = [selectSQL UTF8String];
    sqlite3_stmt    *statement;
    sqlite3_prepare_v2(database, select_stmt, -1, &statement, NULL);
    while (sqlite3_step(statement) == SQLITE_ROW)
    {
        const char *cmonthName = (const char*)sqlite3_column_text(statement, 0);
        NSString *monthName = [[[NSString alloc] initWithUTF8String:cmonthName] autorelease];
        const char *cdayName = (const char*)sqlite3_column_text(statement, 1);
        NSString *dayName = [[[NSString alloc] initWithUTF8String:cdayName] autorelease];
        const char *cyearName = (const char*)sqlite3_column_text(statement, 2);
        NSString *yearName = [[[NSString alloc] initWithUTF8String:cyearName] autorelease];
        const char *cfajrName = (const char*)sqlite3_column_text(statement, 3);
        NSString *fajrName = [[[NSString alloc] initWithUTF8String:cfajrName] autorelease];
        break;
    }
    sqlite3_finalize(statement);
    sqlite3_close(database);

}

-(void) getRowFromDatabase:(NSString*)lMonth:(NSString*)lDay:(NSString*)lYear:(DailyPrayerTimes*)result
{
    sqlite3 *database;
    if (sqlite3_open([[self dataFilePath:kFilename] UTF8String], &database) != SQLITE_OK)
    {
        sqlite3_close(database);
        NSLog(@"Failed to open database");
    }
    
    NSString *selectSQL = [NSString stringWithFormat: @"SELECT MONTH, DAY, YEAR, FAJR, SUNRISE, DHOHUR, ASR, MAGHRIB, ISHA FROM PRAYER_TABLE WHERE month=\"%@\" AND day=\"%@\" AND YEAR=\"%@\"", lMonth, lDay, lYear];
    
    
    const char *select_stmt = [selectSQL UTF8String];
    sqlite3_stmt    *statement;
    sqlite3_prepare_v2(database, select_stmt, -1, &statement, NULL);
    while (sqlite3_step(statement) == SQLITE_ROW)
    {
        const char *cFajrName = (const char*)sqlite3_column_text(statement, 3);
        result.fajr = [NSString stringWithUTF8String:cFajrName];
        
        const char *cSunriseName = (const char*)sqlite3_column_text(statement, 4);
        result.shurooq = [NSString stringWithUTF8String:cSunriseName];

        const char *cDhohurName = (const char*)sqlite3_column_text(statement, 5);
        result.dhohur = [NSString stringWithUTF8String:cDhohurName];

        const char *cAsrName = (const char*)sqlite3_column_text(statement, 6);
        result.asr = [NSString stringWithUTF8String:cAsrName];

        const char *cMaghribName = (const char*)sqlite3_column_text(statement, 7);
        result.maghrib = [NSString stringWithUTF8String:cMaghribName];

        const char *cIshaName = (const char*)sqlite3_column_text(statement, 8);
        result.isha = [NSString stringWithUTF8String:cIshaName];

        break;

    }
    sqlite3_finalize(statement);
    sqlite3_close(database);   
}

-(void) getIqamaRowFromDatabase:(NSString*)lMonth:(NSString*)lDay:(NSString*)lYear:(DailyPrayerTimes*)result
{
    sqlite3 *database;
    if (sqlite3_open([[self dataFilePath:kFilename] UTF8String], &database) != SQLITE_OK)
    {
        sqlite3_close(database);
        NSLog(@"Failed to open database");
    }
    
    NSString *selectSQL = [NSString stringWithFormat: @"SELECT MONTH, DAY, YEAR, FAJR, SUNRISE, DHOHUR, ASR, MAGHRIB, ISHA FROM IQAMA_TABLE WHERE month=\"%@\" AND day=\"%@\" AND YEAR=\"%@\"", lMonth, lDay, lYear];
    
    const char *select_stmt = [selectSQL UTF8String];
    sqlite3_stmt    *statement;
    sqlite3_prepare_v2(database, select_stmt, -1, &statement, NULL);
    while (sqlite3_step(statement) == SQLITE_ROW)
    {
        const char *cFajrName = (const char*)sqlite3_column_text(statement, 3);
        result.fajr = [NSString stringWithUTF8String:cFajrName];
        
        const char *cSunriseName = (const char*)sqlite3_column_text(statement, 4);
        result.shurooq = [NSString stringWithUTF8String:cSunriseName];
        
        const char *cDhohurName = (const char*)sqlite3_column_text(statement, 5);
        result.dhohur = [NSString stringWithUTF8String:cDhohurName];
        
        const char *cAsrName = (const char*)sqlite3_column_text(statement, 6);
        result.asr = [NSString stringWithUTF8String:cAsrName];
        
        const char *cMaghribName = (const char*)sqlite3_column_text(statement, 7);
        result.maghrib = [NSString stringWithUTF8String:cMaghribName];
        
        const char *cIshaName = (const char*)sqlite3_column_text(statement, 8);
        result.isha = [NSString stringWithUTF8String:cIshaName];
        
        break;
        
    }
    sqlite3_finalize(statement);
    sqlite3_close(database);    
    
}
-(void) insertRowIntoDatabase
{
    sqlite3 *database;
    if (sqlite3_open([[self dataFilePath:kFilename] UTF8String], &database) != SQLITE_OK)
    {
        sqlite3_close(database);
        NSLog(@"Failed to open database %s", sqlite3_errmsg(database));
    }
        
    NSString *insertSQL = [NSString stringWithFormat: @"INSERT INTO PRAYER_TABLE (MONTH, DAY, YEAR, FAJR, SUNRISE, DHOHUR, ASR, MAGHRIB, ISHA) VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\",\"%@\", \"%@\", \"%@\")", month_, day_, year_, fajr_, shurooq_, dhohur_, asr_, maghrib_, isha_];
    
    const char *insert_stmt = [insertSQL UTF8String];
    sqlite3_stmt    *statement;
    sqlite3_prepare_v2(database, insert_stmt, -1, &statement, NULL);
    if (sqlite3_step(statement) == SQLITE_DONE)
    {
        //NSLog(@"update complete");
    } else 
    {
        NSLog(@"insert failed %s", sqlite3_errmsg(database));
    }
    sqlite3_finalize(statement);
    sqlite3_close(database);
    
}

-(void) insertIqamaRowIntoDatabase
{
    NSString *dataFilePath;
    dataFilePath = [[NSBundle mainBundle] pathForResource:@"IqamaTimes2011" 
                                                   ofType:@"txt"];  
    
    if ( nil == dataFilePath ) return;
    NSError *error;
    
    NSString *dataSource = [NSString stringWithContentsOfFile:dataFilePath encoding:NSUTF8StringEncoding error:&error];
    
    NSArray *lines = [dataSource componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    sqlite3 *database;
    if (sqlite3_open([[self dataFilePath:kFilename] UTF8String], &database) != SQLITE_OK)
    {
        sqlite3_close(database);
        NSLog(@"Failed to open database %s", sqlite3_errmsg(database));
    }

    for(NSString *line in lines)
    {
        NSArray *lineElements = [line componentsSeparatedByString:@","];
        // insert into the table
        if ([lineElements count] > 12)
        {
            NSString *insertSQL = [NSString stringWithFormat: @"INSERT INTO IQAMA_TABLE (MONTH, DAY, YEAR, WEEKDAY, HIJMONTH, HIJDAY, HIJYEAR,FAJR, SUNRISE, DHOHUR, ASR, MAGHRIB, ISHA) VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\",\"%@\", \"%@ am\", \"%@ am\", \"%@ pm\", \"%@ pm\", \"%@ pm\", \"%@ pm\")", [lineElements objectAtIndex:0], [lineElements objectAtIndex:1], [lineElements objectAtIndex:2], [lineElements objectAtIndex:3], [lineElements objectAtIndex:4], [lineElements objectAtIndex:5], [lineElements objectAtIndex:6], [lineElements objectAtIndex:7], [lineElements objectAtIndex:8], [lineElements objectAtIndex:9], [lineElements objectAtIndex:10], [lineElements objectAtIndex:11], [lineElements objectAtIndex:12]];
        
            const char *insert_stmt = [insertSQL UTF8String];
            sqlite3_stmt    *statement;
            sqlite3_prepare_v2(database, insert_stmt, -1, &statement, NULL);
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                //NSLog(@"update complete");
            } 
            else 
            {
                NSLog(@"insert failed %s", sqlite3_errmsg(database));
            }
            sqlite3_finalize(statement);
        }
    }    

    sqlite3_close(database);
    
}

-(void)loadMonthlyAthanTimes
{
    NSLog(@"loading athan times");
    if (tableNeedsToBeUpdated_ == NO)
    {
        self.ifStatus = @"DONE";
        return;
    }
    
    NSString *currentMonth = [NSString stringWithFormat:@"%d", currentMonthUsedforQuery_];    

    NSString *urlString = [[NSString alloc] initWithFormat:@"http://www.islamicfinder.org/prayer_service.php?country=usa&city=boca_raton&state=FL&zipcode=&latitude=26.3583&longitude=-80.0834&timezone=-5&HanfiShafi=1&pmethod=1&fajrTwilight1=10&fajrTwilight2=10&ishaTwilight=&ishaInterval=30&dhuhrInterval=1&maghribInterval=2&dayLight=1&simpleFormat=xml&monthly=1&month=%@", currentMonth];
    
    // construct the web service url
    NSURL *url = [NSURL URLWithString:urlString];
    
    // create a request object with that URL for the exact times
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
    
    //clear out the existing progress if there is one
    if (connectionInProgress_)
    {
        [connectionInProgress_ cancel];
        [connectionInProgress_ release];
    }
    
    [webData_ release];
    webData_ = [[NSMutableData alloc] init];
    
    // create and initiate the connection non - blocking
    connectionInProgress_ = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [webData_ appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:webData_];
    
    //give it a delegate
    [parser setDelegate:self];
    [parser parse];
    
    [parser release];
    
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"date"])
    {
        year_ = [attributeDict objectForKey:@"year"];
        month_ = [attributeDict objectForKey:@"month"];
        day_ = [attributeDict objectForKey:@"day"];
    }
    else
    {
        title_ = elementName;
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([string length] >0)
    {
        [value_ appendString:string];
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([title_ isEqualToString:@"isha"])
    {
        [value_ appendFormat:@" pm"];
        isha_ = [NSString stringWithString:value_];
        // insert new field into database
        [self insertRowIntoDatabase];
        title_ = @"";
        return;
    }
    if ([title_ isEqualToString:@"fajr"])
    {
        [value_ appendFormat:@" am"];
        fajr_ = [NSString stringWithString:value_];
    }
    if ([title_ isEqualToString:@"sunrise"])
    {
        [value_ appendFormat:@" am"];
        shurooq_ = [NSString stringWithString:value_];
    }
    if ([title_ isEqualToString:@"dhuhr"])
    {
        [value_ appendFormat:@" pm"];
        dhohur_ = [NSString stringWithString:value_];
    }
    if ([title_ isEqualToString:@"asr"])
    {
        [value_ appendFormat:@" pm"];
        asr_ = [NSString stringWithString:value_];
    }
    if ([title_ isEqualToString:@"maghrib"])
    {
        [value_ appendFormat:@" pm"];
        maghrib_ = [NSString stringWithString:value_];
    }
   //clear out the value_ ivar
    [value_ setString:@""];
}

-(void)parserDidEndDocument:(NSXMLParser *)parser
{
    NSLog(@"parsing completed");
    currentMonthUsedforQuery_++;
    if (currentMonthUsedforQuery_ < 13)
        [self loadMonthlyAthanTimes];
    else
    {
        self.ifStatus = @"DONE";
        [ifStatus_ release];
        [connectionInProgress_ release];
        [title_ release];
        [value_ release];
    }
}

@end
