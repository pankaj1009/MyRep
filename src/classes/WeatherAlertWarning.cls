public class WeatherAlertWarning 
{
	public WeatherAlertMessage AlertMessage{get;set;}
	public String FIPSCode {get;set;}
	public String AffectedState {get;set;}
	public List<AffectedEnterpriseProject> AffectedProjects {get;set;}
	public Decimal NumberOfProjectsAffected{get;set;} 
	public Decimal NumberOfUnitsAffected{get;set;}
	public String HTMLContent{get;set;}
	public List<IndividualWarning> IndividualWarningList{get;set;}
	public Integer ProjectsAffected{get{return NumberOfProjectsAffected.intValue();}} 
	public Integer UnitsAffected{get{return NumberOfUnitsAffected.intValue();}}
	public Integer IndWarningCount
	{
		get
		{
			if(IndividualWarningList == null)
				return 0;
			
			return IndividualWarningList.size();	
		}
	}
	
	public String ToHTML()
	{
		String htmlRepresentation = '<tr>';
		htmlRepresentation = htmlRepresentation + '<td>';
		
		htmlRepresentation = htmlRepresentation + '<table>';
		for(IndividualWarning indWarning : IndividualWarningList)
		{
			htmlRepresentation = htmlRepresentation + indWarning.ToHTML();
		}
		htmlRepresentation = htmlRepresentation + '</table>';
		
		htmlRepresentation = htmlRepresentation + '<br>';
		
		htmlRepresentation = htmlRepresentation + '<table bgcolor="#FFFFE3" width="100%" cellpadding="2" >';
		
		htmlRepresentation = htmlRepresentation + '<td style="vertical-align:top; font-family:verdana; font-size:11px;" colspan="2"><b>Affected Projects</b></td>';
		
		for(AffectedEnterpriseProject affectedProject : AffectedProjects)
		{
			htmlRepresentation = htmlRepresentation + affectedProject.ToHTML();
		}
		htmlRepresentation = htmlRepresentation + '</table>';
		
		htmlRepresentation = htmlRepresentation + '</td>';
		htmlRepresentation = htmlRepresentation + '</tr>';
		
		return htmlRepresentation;
	}
}