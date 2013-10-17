public class MessageProcessor
{
    /***************************************
    PUBLIC METHODS
    ***************************************/
    public static WeatherAlertMessage GetCurrentMessage()
    {
        WTR_ALRT_MESSAGE__c dbMessage = AlertServiceHelper.GetRecentlyAddedMessage();
        
        WeatherAlertMessage message = AlertServiceHelper.GetMessageFromRecord(dbMessage);
        //message.Warnings = AlertServiceHelper.GetWarningsForMessage(dbMessage, message);
        message.StateWarnings = AlertServiceHelper.GetStateWarningsForMessage(dbMessage, message);
        
        return message;
    }
    
    public static WeatherAlertMessage GetCurrentMessage(string searchText)
    {
        WTR_ALRT_MESSAGE__c dbMessage = AlertServiceHelper.GetRecentlyAddedMessage();
        
        WeatherAlertMessage message = AlertServiceHelper.GetMessageFromRecord(dbMessage);
        //message.Warnings = AlertServiceHelper.GetWarningsForMessage(dbMessage, message);
        message.StateWarnings = AlertServiceHelper.GetStateWarningsForMessage(dbMessage, message, searchText);
        
        return message;
    }

    /***************************************
    PRIVATE METHODS
    
    private static List<WeatherAlertWarning> GetProcessedSevereWarnings()
    {
        List<WeatherAlertWarning> listWarnings = new List<WeatherAlertWarning>();
        
        // Get the lerts from the national weather alert service
        List<NationalServiceAlert> listSeverAlerts;
        NWSFeedProcessor feedProcessor = new NWSFeedProcessor();   
        listSeverAlerts = feedProcessor.GetCurrentSevereNationalAlerts();
        
        Map<String, List<WTR_ALRT_ENT_PROJECT__c>> mapProjects = AlertServiceHelper.InitializeProjectsMap();        

        for(NationalServiceAlert serviceAlert: listSeverAlerts )
        {
           for(String warningFIPS: serviceAlert.FIPSCodeList)
            {
                List<AffectedEnterpriseProject> listAffectedProjects = new List<AffectedEnterpriseProject>();
                List<WTR_ALRT_ENT_PROJECT__c> fipsProjects = AlertServiceHelper.GetProjectsForFIPSCode(warningFIPS);
                for(WTR_ALRT_ENT_PROJECT__c dbProj :fipsProjects)
                {
                    listAffectedProjects.Add(AlertServiceHelper.GetAffectedProject(dbProj));
                }
           
                if(listAffectedProjects.size() > 0)
                {
                    WeatherAlertWarning warning = new WeatherAlertWarning();
                    warning.FIPSCode = warningFIPS;
                    warning.Warning = serviceAlert.Summary;
                    warning.AffectedProjects = listAffectedProjects;
                    listWarnings.Add(warning);
                }
            } 
        }
        
        return listWarnings;        
    } 
    
    private static List<AffectedEnterpriseProject> GetAffectedEnterpriseProjects(List<AffectedEnterpriseProject> listProject, String fipsCode)
    {
        List<AffectedEnterpriseProject> listAffected = new List<AffectedEnterpriseProject>();
        
        for(AffectedEnterpriseProject project :listProject)
        {
            if(project.FIPSCode == fipsCode)
            {
                listAffected.Add(project);
            }
            if(listAffected.size() > 2)
                break;
        }
        
        return listAffected;
    }
    
    private static List<AffectedEnterpriseProject> GetAffectedEnterpriseProjects(List<WTR_ALRT_ENT_PROJECT__c> listFIPSProjects)
    {
        List<AffectedEnterpriseProject> listAffectedProject = new List<AffectedEnterpriseProject>(); 
        for(WTR_ALRT_ENT_PROJECT__c project: listFIPSProjects)
        {
            AffectedEnterpriseProject affectedProject = new AffectedEnterpriseProject(); 
            
            affectedProject.ProjectName = project.ProjectName__c;
            affectedProject.Address = project.ProjectAddress__c;
            affectedProject.City = project.Project_City__c;
            affectedProject.State = project.ProjectState__c;
            affectedProject.County = project.ProjectCounty__c;
            affectedProject.ZIP = project.ProjectZIP__c;
            affectedProject.FIPSCode = project.GEO_Census_FIPS__c;
            affectedProject.Latitude = project.GEO_AVGLATITUDE__c;
            affectedProject.Longitude = project.GEO_AVGLONGITUDE__c;
            
            listAffectedProject.Add(affectedProject);
        }
        
        return listAffectedProject;
    } 
    
    private static String GetWarningMessageHTML(List<WTR_ALRT_ENT_PROJECT__c> listFIPSProjects, string warningMesssage)
    {
        String messageHTML = '';
        messageHTML = messageHTML + 'Warning Message:-\n\n' ;
        messageHTML = messageHTML + warningMesssage;
        
        String messageRow = '';
        if(listFIPSProjects<>null)
        {
            for(WTR_ALRT_ENT_PROJECT__c project: listFIPSProjects)
            {
                messageRow = messageRow + ' Project Name: ' + project.ProjectName__c;
                String addressDet = ' Street Address: ' + project.ProjectAddress__c;
                addressDet = addressDet + ' City: ' + project.Project_City__c;
                addressDet = addressDet + ' State: ' + project.ProjectState__c;
                messageRow = messageRow + addressDet;  

                messageHTML = messageHTML + messageRow;
            }
        }
        
        return messageHTML;
        
    }
    
    private static String GetAffectedProjectList(List<WTR_ALRT_ENT_PROJECT__c> listFIPSProjects)
    {
        string projects = '';
        for(WTR_ALRT_ENT_PROJECT__c project:listFIPSProjects)
        {
            projects = projects + project.ProjectName__c + '|'; 
        }
        return projects;
    }
    ***************************************/    
}