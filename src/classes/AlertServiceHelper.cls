public class AlertServiceHelper
{
    /************************ 
    PUBLIC METHODS
    ************************/
    public static WeatherAlertMessage GetMessageFromRecord(WTR_ALRT_MESSAGE__c dbMessage)
    {
        WeatherAlertMessage message = new WeatherAlertMessage();
        
        message.GeneratedAt = dbMessage.GeneratedAt__c;
        message.MailBodyHTML = dbMessage.MailBodyHTML__c;
        message.NumberOfProjectsAffected = dbMessage.NumberOfProjectsAffected__c;
        message.NumberOfUnitsAffected = dbMessage.NumberOfUnitsAffected__c;
        message.SentAtTime = dbMessage.SentAtTime__c;
        
        
        if(dbMessage.SentToEmails__c<>null && dbMessage.SentToEmails__c <> '')
        {
            String[] arrEmails = dbMessage.SentToEmails__c.split(';');
            List<String> emailList = new List<String>();
            
            for(Integer i=0;i<emailList.size();i++)
            {
                emailList.Add(arrEmails[i]);
            }
            message.SentToEmails = emailList; 
        }
        return message; 
    }
    
    public static List<WeatherAlertState> GetStateWarningsForMessage(WTR_ALRT_MESSAGE__c dbMessage, WeatherAlertMessage message)
    {
        Map<String, List<WeatherAlertWarning>> mapStateWarning = new Map<String, List<WeatherAlertWarning>>(); 
        List<WTR_ALRT_WARNING__c> listDBWarning = GetWarningRecordsForMessage(dbMessage);
        
        for(WTR_ALRT_WARNING__c dbWarning: listDBWarning)
        {
            String state = dbWarning.AffectedState__c;
            System.Debug(state);
            if(state<> null && state <> '') 
            {
                if(!mapStateWarning.containsKey(state.trim()))
                {
                    List<WeatherAlertWarning> listW = new List<WeatherAlertWarning>();
                    
                    if(dbWarning.Name <> '' || dbWarning.Name <> null)
                    {
                        listW.Add(GetWarnigFromRecord(message, dbWarning));
                        mapStateWarning.put(state.trim(), listW);
                    }
                }
                else
                {
                    List<WeatherAlertWarning> listW = mapStateWarning.get(state.trim());
                    if(listW==null)
                    {
                        listW = new List<WeatherAlertWarning>();
                    }
                    
                    if(dbWarning.Name <> '' || dbWarning.Name <> null)
                    {
                        listW.Add(GetWarnigFromRecord(message, dbWarning));
                    }
                }
            }
        }
                
        // This needs to be returned
        List<WeatherAlertState> stateWarnings = new List<WeatherAlertState>();
        
        for(String key: mapStateWarning.keySet())
        {
            WeatherAlertState stateWarning = new WeatherAlertState();
            
            stateWarning.State = key;
            stateWarning.Warnings = mapStateWarning.get(key);
            
            stateWarnings.Add(stateWarning);
        }
        
        return stateWarnings; 
    }
    
    public static List<WeatherAlertState> GetStateWarningsForMessage(WTR_ALRT_MESSAGE__c dbMessage, WeatherAlertMessage message, String searchText)
    {
        Map<String, List<WeatherAlertWarning>> mapStateWarning = new Map<String, List<WeatherAlertWarning>>(); 
        List<WTR_ALRT_WARNING__c> listDBWarning = GetWarningRecordsForMessage(dbMessage);
        
        for(WTR_ALRT_WARNING__c dbWarning: listDBWarning)
        {
            String state = dbWarning.AffectedState__c;
            System.Debug(state);
            if(state<> null && state <> '') 
            {
                if(!mapStateWarning.containsKey(state.trim()))
                {
                    List<WeatherAlertWarning> listW = new List<WeatherAlertWarning>();
                    
                    if(dbWarning.Name <> '' || dbWarning.Name <> null)
                    {
                        WeatherAlertWarning weatherAlertWarningObject = GetWarnigFromRecord(message, dbWarning, searchText);
                        
                        if(weatherAlertWarningObject.IndividualWarningList.size() > 0)
                        {
                            listW.Add(weatherAlertWarningObject);
                            mapStateWarning.put(state.trim(), listW);
                        }
                    }
                }
                else
                {
                    List<WeatherAlertWarning> listW = mapStateWarning.get(state.trim());
                    if(listW==null)
                    {
                        listW = new List<WeatherAlertWarning>();
                    }
                    
                    if(dbWarning.Name <> '' || dbWarning.Name <> null)
                    {
                        WeatherAlertWarning weatherAlertWarningObject = GetWarnigFromRecord(message, dbWarning, searchText);
                        
                        if(weatherAlertWarningObject.IndividualWarningList.size() > 0)
                        {
                            listW.Add(weatherAlertWarningObject );
                        }
                    }
                }
            }
        }
                
        // This needs to be returned
        List<WeatherAlertState> stateWarnings = new List<WeatherAlertState>();
        
        for(String key: mapStateWarning.keySet())
        {
            WeatherAlertState stateWarning = new WeatherAlertState();
            
            stateWarning.State = key;
            stateWarning.Warnings = mapStateWarning.get(key);
            
            stateWarnings.Add(stateWarning);
        }
        
        return stateWarnings; 
    }
        
    public static List<WeatherAlertWarning> GetWarningsForMessage(WTR_ALRT_MESSAGE__c dbMessage, WeatherAlertMessage message)
    {
        List<WeatherAlertWarning> listWarning = new List<WeatherAlertWarning>();
        
        List<WTR_ALRT_WARNING__c> listDBWarning = GetWarningRecordsForMessage(dbMessage);

        for(WTR_ALRT_WARNING__c dbWarning: listDBWarning)
        {
            listWarning.Add(GetWarnigFromRecord(message, dbWarning));
        }
        
        return listWarning;
    }
    
    public static WeatherAlertWarning GetWarnigFromRecord(WeatherAlertMessage message, WTR_ALRT_WARNING__c dbWarning)
    {
        WeatherAlertWarning warning = new WeatherAlertWarning();
        
        warning.AffectedState = dbWarning.AffectedState__c;
        warning.AlertMessage = message;
        warning.FIPSCode = dbWarning.FIPSCode__c;
        warning.HTMLContent = dbWarning.CompleteMessageHTML__c;
        warning.NumberOfProjectsAffected = dbWarning.NumberOfProjectsAffected__c;
        warning.NumberOfUnitsAffected = dbWarning.NumberOfUnitsAffected__c;
        
        List<WTR_ALRT_ENT_PROJECT__c> listDBProject = GetProjectsForWarning(dbWarning);
        List<AffectedEnterpriseProject> listProject = new List<AffectedEnterpriseProject>(); 
        
        for(WTR_ALRT_ENT_PROJECT__c dbProj: listDBProject)
        {
            listProject.Add(GetAffectedProject(dbProj));
        }
        
        String[] arrTitle = dbWarning.Title__c.split('\\|');
        String[] arrWarning = dbWarning.Warning__c.split('\\|');
        String[] arrSeverity = dbWarning.Severity__c.split('\\|');
        
        List<IndividualWarning> listIndWarnings = new List<IndividualWarning>();
        
        if(arrSeverity.size()==0)
        {
            IndividualWarning indWarning = new IndividualWarning();
            indWarning.Title = dbWarning.Title__c;
            indWarning.Severity = dbWarning.Severity__c;
            indWarning.Warning = dbWarning.Warning__c;
            listIndWarnings.Add(indWarning);
        }
        else
        {
            for(Integer i=0; i<arrSeverity.size(); i++)
            {
                IndividualWarning indWarning = new IndividualWarning();
                
                indWarning.Title = arrTitle[i];
                indWarning.Severity = arrSeverity[i];
                indWarning.Warning = arrWarning[i];
                
                listIndWarnings.Add(indWarning);
            }
        }
        
        warning.AffectedProjects = listProject;
        warning.IndividualWarningList = listIndWarnings;
        
        return warning;
    }
    
    public static WeatherAlertWarning GetWarnigFromRecord(WeatherAlertMessage message, WTR_ALRT_WARNING__c dbWarning, String searchText)
    {
        WeatherAlertWarning warning = new WeatherAlertWarning();
        
        warning.AffectedState = dbWarning.AffectedState__c;
        warning.AlertMessage = message;
        warning.FIPSCode = dbWarning.FIPSCode__c;
        warning.HTMLContent = dbWarning.CompleteMessageHTML__c;
        warning.NumberOfProjectsAffected = dbWarning.NumberOfProjectsAffected__c;
        warning.NumberOfUnitsAffected = dbWarning.NumberOfUnitsAffected__c;
        
        List<WTR_ALRT_ENT_PROJECT__c> listDBProject = GetProjectsForWarning(dbWarning);
        List<AffectedEnterpriseProject> listProject = new List<AffectedEnterpriseProject>(); 
        
        for(WTR_ALRT_ENT_PROJECT__c dbProj: listDBProject)
        {
            listProject.Add(GetAffectedProject(dbProj));
        }
        
        String[] arrTitle = dbWarning.Title__c.split('\\|');
        String[] arrWarning = dbWarning.Warning__c.split('\\|');
        String[] arrSeverity = dbWarning.Severity__c.split('\\|');
        
        List<IndividualWarning> listIndWarnings = new List<IndividualWarning>();
        
        if(arrSeverity.size()==0)
        {
            if(dbWarning.Warning__c.contains(searchText))
            {
                IndividualWarning indWarning = new IndividualWarning();
                indWarning.Title = dbWarning.Title__c;
                indWarning.Severity = dbWarning.Severity__c;
                indWarning.Warning = dbWarning.Warning__c;
                listIndWarnings.Add(indWarning);
            }
        }
        else
        {
            for(Integer i=0; i<arrSeverity.size(); i++)
            {
                if(arrWarning[i].contains(searchText))
                {
                    IndividualWarning indWarning = new IndividualWarning();
                    
                    indWarning.Title = arrTitle[i];
                    indWarning.Severity = arrSeverity[i];
                    indWarning.Warning = arrWarning[i];
                    
                    listIndWarnings.Add(indWarning);
                }
            }
        }
        
        warning.AffectedProjects = listProject;
        warning.IndividualWarningList = listIndWarnings;
        
        return warning;
    }

    public static WTR_ALRT_MESSAGE__c GetRecentlyAddedMessage()
    {
        WTR_ALRT_MESSAGE__c message = [ SELECT  Id, Name, GeneratedAt__c, MailBodyHTML__c,NumberOfProjectsAffected__c,
                                                NumberOfUnitsAffected__c, SentAtTime__c, SentToEmails__c 
                                        FROM 
                                            WTR_ALRT_MESSAGE__c 
                                        ORDER BY    
                                        Name DESC LIMIT 1];
        return message;        
    }
    
    public static List<WTR_ALRT_WARNING__c> GetWarningRecordsForMessage(WTR_ALRT_MESSAGE__c message)
    {
        List<WTR_ALRT_WARNING__c> warnings = [SELECT Id, Name, AffectedProjectsList__c, AffectedState__c,
                                                    CompleteMessageHTML__c, FIPSCode__c, MessageMail__c,
                                                    NumberOfProjectsAffected__c, NumberOfUnitsAffected__c,
                                                    Warning__c,Title__c,Severity__c           
                                                FROM 
                                                    WTR_ALRT_WARNING__c 
                                                WHERE 
                                                    MessageMail__c =: message.Id
                                                ORDER BY
                                                    AffectedState__c];
        return warnings;                                                    
    }
    
    public static List<WTR_ALRT_ENT_PROJECT__c> GetProjectsForWarning(WTR_ALRT_WARNING__c warning)
    {
        List<WTR_ALRT_ENT_PROJECT__c> listProjects = new List<WTR_ALRT_ENT_PROJECT__c>();
        
        for(WTR_ALRT_ENT_PROJECT__c project : [SELECT Id, Name, LegacyId__c, ProjectAddress__c, Project_City__c, ProjectCounty__c,
                        ProjectName__c, ProjectState__c, ProjectZIP__c, GEO_AVGLATITUDE__c,
                        GEO_AVGLONGITUDE__c, GEO_Census_FIPS__c, GEO_CITY__c, GEO_COUNTY__c,
                        GEO_STATE_ABBR__c  
                FROM WTR_ALRT_ENT_PROJECT__c
                WHERE
                    Id IN (SELECT EnterpriseProject__c FROM WTR_ALRT_WARNING_PROJECT_MAP__c WHERE AlertWarning__c =: warning.Id)
                LIMIT 50 ])
        {
            listProjects.Add(project);
        }       
        
        return listProjects;                                                                
    }
    
    /****
    public static Map<String, List<WTR_ALRT_ENT_PROJECT__c>> InitializeProjectsMap()
    {
        Map<String, List<WTR_ALRT_ENT_PROJECT__c>> mapProjects = new Map<String, List<WTR_ALRT_ENT_PROJECT__c>>();  
        
        for(WTR_ALRT_ENT_PROJECT__c dbProj : [select Name, LegacyId__c, ProjectAddress__c, Project_City__c, ProjectCounty__c,
                        ProjectName__c, ProjectState__c, ProjectZIP__c, GEO_AVGLATITUDE__c,
                        GEO_AVGLONGITUDE__c, GEO_Census_FIPS__c, GEO_CITY__c, GEO_COUNTY__c,
                        GEO_STATE_ABBR__c  
                from WTR_ALRT_ENT_PROJECT__c
                where (GEO_Census_FIPS__c <> null or GEO_Census_FIPS__c <> '' )])
        {
            String state = dbProj.GEO_STATE_ABBR__c;
            if(state<> null && state <> '') 
            {
                if(!mapProjects.containsKey(state.trim()))
                {
                    List<WTR_ALRT_ENT_PROJECT__c> listStateProject = new List<WTR_ALRT_ENT_PROJECT__c>();
                    
                    if(dbProj.Name <> '' || dbProj.Name <> null)
                    {
                        listStateProject.Add(dbProj);
                        mapProjects.put(state.trim(), listStateProject);
                    }
                }
                else
                {
                    List<WTR_ALRT_ENT_PROJECT__c> listStateProject = mapProjects.get(state.trim());
                    if(listStateProject==null)
                    {
                        listStateProject = new List<WTR_ALRT_ENT_PROJECT__c>();
                    }
                    
                    if(dbProj.Name <> '' || dbProj.Name <> null)
                    {
                        listStateProject.Add(dbProj);
                    }
                }
            }
        }
        
        return mapProjects;
    } 
    ****/
    
    /****
    public static List<AffectedEnterpriseProject> GetAffectedProjectsHavingFIPSCode()
    {
        List<WTR_ALRT_ENT_PROJECT__c> listProject = GetProjectsHavingFIPSCode();
        
        List<AffectedEnterpriseProject> listAffectedProject = new List<AffectedEnterpriseProject>();
        for(WTR_ALRT_ENT_PROJECT__c dbProj : listProject)
        {
            listAffectedProject.Add(GetAffectedProject(dbProj));
        }
        return listAffectedProject;
    } 
    ****/
    
    /****
    public static List<WTR_ALRT_ENT_PROJECT__c> GetProjectsHavingFIPSCode()
    {
        List<WTR_ALRT_ENT_PROJECT__c> listProject = new List<WTR_ALRT_ENT_PROJECT__c>();
        
        for(WTR_ALRT_ENT_PROJECT__c dbProj: [select Name, LegacyId__c, ProjectAddress__c, Project_City__c, ProjectCounty__c,
                        ProjectName__c, ProjectState__c, ProjectZIP__c, GEO_AVGLATITUDE__c,
                        GEO_AVGLONGITUDE__c, GEO_Census_FIPS__c, GEO_CITY__c, GEO_COUNTY__c,
                        GEO_STATE_ABBR__c  
                from WTR_ALRT_ENT_PROJECT__c
                where (GEO_Census_FIPS__c <> null or GEO_Census_FIPS__c <> '' )])
       {
            listProject.Add(dbProj);
       }
        
        return listProject; 
    }
    ***/
    
    /****
    public static List<WTR_ALRT_ENT_PROJECT__c> GetProjectsForFIPSCode(String fipsCode)
    {
        List<WTR_ALRT_ENT_PROJECT__c> listProject = new List<WTR_ALRT_ENT_PROJECT__c>();
        
        for(WTR_ALRT_ENT_PROJECT__c dbProj: [select Name, LegacyId__c, ProjectAddress__c, Project_City__c, ProjectCounty__c,
                        ProjectName__c, ProjectState__c, ProjectZIP__c, GEO_AVGLATITUDE__c,
                        GEO_AVGLONGITUDE__c, GEO_Census_FIPS__c, GEO_CITY__c, GEO_COUNTY__c,
                        GEO_STATE_ABBR__c  
                from WTR_ALRT_ENT_PROJECT__c
                where GEO_Census_FIPS__c =: fipsCode])
        {
                listProject.Add(dbProj);
        }
        
        return listProject; 
    }
    ****/
    
    public static List<WTR_ALRT_ALERT_RECIPIENT__c> GetAlertRecipient() 
    {
        List<WTR_ALRT_ALERT_RECIPIENT__c> listRecipient = [select FirstName__c, LastName__c, Email__c, Phone__c, BusinessUnit__c, 
                        AlternateEmail__c, AlternatePhone__c   
                    from WTR_ALRT_ALERT_RECIPIENT__c 
                    where IsActive__c =: true 
                ];
        
        return listRecipient;
    }
    
    public static AffectedEnterpriseProject GetAffectedProject(WTR_ALRT_ENT_PROJECT__c dbProject)
    {
        AffectedEnterpriseProject project = new AffectedEnterpriseProject();
        
        project.ProjectName = dbProject.ProjectName__c;
        project.Address = dbProject.ProjectAddress__c;
        project.City = dbProject.Project_City__c;
        project.State = dbProject.ProjectState__c;
        project.County = dbProject.ProjectCounty__c;
        project.ZIP = dbProject.ProjectZIP__c;
        project.FIPSCode = dbProject.GEO_Census_FIPS__c;
        project.Latitude = dbProject.GEO_AVGLATITUDE__c;
        project.Longitude = dbProject.GEO_AVGLONGITUDE__c;
    
        return project; 
    } 
}