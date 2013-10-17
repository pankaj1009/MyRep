public class WeatherAlertMessage 
{
    public String MailBodyHTML{get;set;}
    public Datetime GeneratedAt{get;set;}
    public Decimal NumberOfProjectsAffected {get;set;}
    public Decimal NumberOfUnitsAffected {get;set;}
    public Datetime SentAtTime{get;set;}
    public List<String> SentToEmails{get;set;}
    public List<WeatherAlertState> StateWarnings{get;set;}

    public String GeneratedAtParsed
    {
        get
        {
            String myDtString = GeneratedAt.format('MM/dd/yyyy hh:mm:ss a', 'EST');
            return myDtString;
        }
    }
    
    public String ToHTML()
    {
        String htmlRepresentation = '<table border="1px" style="border-color:#1797C0;">';
        
        for(WeatherAlertState stateAlert:StateWarnings)
        {
            htmlRepresentation = htmlRepresentation + stateAlert.ToHTML();
        }
        
        htmlRepresentation = htmlRepresentation + '</table>';
        
        return htmlRepresentation;
    }
}