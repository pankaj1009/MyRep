public class IndividualWarning
{
    public String Severity {get;set;}
    public String Effective {get;set;}
    public String Warning {get;set;}
    public String Title {get;set;}
     public String Title2 {get;set;}   
    public String ToHTML()
    {
        String htmlRepresentation = '<tr>';
        
        htmlRepresentation = htmlRepresentation + '<td>';
        
        htmlRepresentation = htmlRepresentation + '<span  style="font-size:11px; font-weight:bold; font-family:verdana;">' + Severity + '</span>';
        htmlRepresentation = htmlRepresentation + '<br/><br/>';
        
        htmlRepresentation = htmlRepresentation + '<span style="font-family:verdana; color:#303030; font-size:11px;">' + Title + '</span>';
        htmlRepresentation = htmlRepresentation + '<br/><br/>';
        
        htmlRepresentation = htmlRepresentation + '<span style="font-family:verdana; font-size:9px;">' + Warning + '</span>';
        
        htmlRepresentation = htmlRepresentation + '</td>'; 
        
        htmlRepresentation = htmlRepresentation + '</tr>';
        
        return htmlRepresentation;
    }
}