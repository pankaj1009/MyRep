public class WeatherAlertMapNListController
{
    /***************
    PRIVATE FIELDS
    ***************/
    private WeatherAlertMessage message;
    private List<WeatherAlertState> stateWarnings;

    /***************
    PUBLIC PROPERTIES
    ***************/
    public List<WeatherAlertState> ProcessedStateWarnings
    {
        get{return stateWarnings;} 
    }
    
    public WeatherAlertMessage AlertMessage
    {
        get{return message;}
    }
    
    public String MessageHTML
    {
        get{return message.ToHTML();}
    } 

    /***************
    CONSTRUCTOR
    ***************/
    public WeatherAlertMapNListController()
    {
        message = MessageProcessor.GetCurrentMessage();
        stateWarnings = message.StateWarnings; 
    }
    
    /*************** TEST METHODS ***************/
    // 
    public static TestMethod void TestCase()
    {
        // Insert Enterprise Projects
        WTR_ALRT_ENT_PROJECT__c project1 = new WTR_ALRT_ENT_PROJECT__c();
        project1.LegacyId__c = '1252';
        project1.ProjectAddress__c = '2120 29th St';
        project1.Project_City__c = 'Williston';
        project1.ProjectCounty__c = '';
        project1.ProjectName__c = 'Bakken Heights II Phase II'; 
        project1.ProjectState__c = 'ND'; 
        project1.ProjectZIP__c = '';
        project1.GEO_AVGLATITUDE__c = '48.1702665';
        project1.GEO_AVGLONGITUDE__c = '-103.652397'; 
        project1.GEO_Census_FIPS__c = '021215';
        project1.GEO_CITY__c = 'Williston'; 
        project1.GEO_COUNTY__c = '';
        project1.GEO_STATE_ABBR__c = 'ND';
        
        WTR_ALRT_ENT_PROJECT__c project2 = new WTR_ALRT_ENT_PROJECT__c();
        project2.LegacyId__c = '1253';
        project2.ProjectAddress__c = '150 S. Wahanna Rd';
        project2.Project_City__c = 'Seaside';
        project2.ProjectCounty__c = '';
        project2.ProjectName__c = 'Sandhill Apts'; 
        project2.ProjectState__c = 'OR'; 
        project2.ProjectZIP__c = '';
        project2.GEO_AVGLATITUDE__c = '45.998223';
        project2.GEO_AVGLONGITUDE__c = '-123.9122415'; 
        project2.GEO_Census_FIPS__c = '034545';
        project2.GEO_CITY__c = 'Seaside'; 
        project2.GEO_COUNTY__c = '';
        project2.GEO_STATE_ABBR__c = 'OR';
        
        insert project1;
        insert project2;
        
        // Insert DB Message
        WTR_ALRT_MESSAGE__c dbMessage = new WTR_ALRT_MESSAGE__c();
        dbMessage.NumberOfProjectsAffected__c = 110;
        dbMessage.NumberOfUnitsAffected__c = 1010;
        dbMessage.MailBodyHTML__c = '<HTML><BODY><p>This is a test</p></BODY></HTML>';
        
        insert dbMessage;
        
        // Insert DB Warnings
        WTR_ALRT_WARNING__c dbWarning1 = new WTR_ALRT_WARNING__c();
        dbWarning1.AffectedState__c = 'ND';
        dbWarning1.FIPSCode__c = '021215';
        dbWarning1.MessageMail__c = dbMessage.Id;
        dbWarning1.NumberOfProjectsAffected__c = 3; 
        dbWarning1.NumberOfUnitsAffected__c = 9;
        dbWarning1.Warning__c = 'TEST WARNING 1 TEST WARNING 1 TEST WARNING 1';
        dbWarning1.Title__c = 'Test Title 1';
        dbWarning1.Severity__c = 'Severe';
        
        WTR_ALRT_WARNING__c dbWarning2 = new WTR_ALRT_WARNING__c();
        dbWarning2.AffectedState__c = 'OR';
        dbWarning2.FIPSCode__c = '034545';
        dbWarning2.MessageMail__c = dbMessage.Id;
        dbWarning2.NumberOfProjectsAffected__c = 2; 
        dbWarning2.NumberOfUnitsAffected__c = 12;
        dbWarning2.Warning__c = 'TEST WARNING 2 TEST WARNING 2 TEST WARNING 2';
        dbWarning2.Title__c = 'Test Title 2';
        dbWarning2.Severity__c = 'Severe';
        
        insert dbWarning1;
        insert dbWarning2;
        
        WTR_ALRT_WARNING_PROJECT_MAP__c map1 = new WTR_ALRT_WARNING_PROJECT_MAP__c();
        map1.AlertWarning__c = dbWarning1.Id;
        map1.EnterpriseProject__c = project1.id;
        
        WTR_ALRT_WARNING_PROJECT_MAP__c map2 = new WTR_ALRT_WARNING_PROJECT_MAP__c();
        map2.AlertWarning__c = dbWarning2.Id;
        map2.EnterpriseProject__c = project2.id;
        
        insert map1;
        insert map2;
        
        Test.startTest();
        system.assertNotEquals(null, dbMessage.Id);
        system.assertNotEquals(null, dbWarning1.Id);
        system.assertNotEquals(null, dbWarning2.Id);
        system.assertNotEquals(null, project1.Id);
        system.assertNotEquals(null, project2.Id);
        system.assertNotEquals(null, map1.Id);
        system.assertNotEquals(null, map2.Id);
        
        
        WeatherAlertMapNListController controller = new WeatherAlertMapNListController();
        system.assertNotEquals(null, controller.AlertMessage);  
        system.assertNotEquals(null, controller.ProcessedStateWarnings);
        system.assertNotEquals(null, controller.MessageHTML);
        Test.stopTest();
    }
    
    // Code for filtering weather alerts
    // Public Fields
    public String searchText {get;set;}
    public String NoRecordsFound {get;set;}
    
    public PageReference doSearch()
    {
        if(searchText.toUpperCase() == 'ALL')
        {
            message = MessageProcessor.GetCurrentMessage();
        }
        else
        {
            message = MessageProcessor.GetCurrentMessage(searchText.toUpperCase());            
        }
        stateWarnings = message.StateWarnings;
        
        if(stateWarnings.size() == 0)
        {
            NoRecordsFound = 'No matching records found.';
        }
        else
        {
            NoRecordsFound = '';
        }
        
        return null;
    }
    
    // Code to display alert types
    public List<SelectOption> getAlertTypes()
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('All', 'All'));
        options.add(new SelectOption('Flash Flood Warning', 'Flash Flood Warning'));
        options.add(new SelectOption('Flood Warning', 'Flood Warning'));
        options.add(new SelectOption('Blizzard Warning', 'Blizzard Warning'));
        options.add(new SelectOption('Storm Warning', 'Storm Warning'));
        options.add(new SelectOption('Gale Warning', 'Gale Warning'));
        return options;
    }
}