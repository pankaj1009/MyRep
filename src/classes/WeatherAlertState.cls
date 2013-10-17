public class WeatherAlertState 
{
	public String State{get;set;}
	public List<WeatherAlertWarning> Warnings {get;set;}
	
	public String ToHTML()
	{
		String htmlRepresentation = '<tr>';
		htmlRepresentation = htmlRepresentation + '<td colspan="2" style="font-family:verdana;font-size:100%;font-weight:bold;" >';
		htmlRepresentation = htmlRepresentation + '<strong>' + State + '</strong>';	
		htmlRepresentation = htmlRepresentation + '</td>';
		htmlRepresentation = htmlRepresentation + '</tr>';	
		
		htmlRepresentation = htmlRepresentation + '<tr>';
		htmlRepresentation = htmlRepresentation + '<td width="5%"></td>';
		
		htmlRepresentation = htmlRepresentation + '<td width="95%">';
		htmlRepresentation = htmlRepresentation + '<table border="1px" width="98%" bgcolor="#FAF7F7" border="1px" style="border-color:#1797C0;" >';
		for(WeatherAlertWarning warning: Warnings)
		{
			htmlRepresentation = htmlRepresentation + warning.ToHTML();
		}
		htmlRepresentation = htmlRepresentation + '</table>';
		htmlRepresentation = htmlRepresentation + '</td>';
		htmlRepresentation = htmlRepresentation + '</tr>';
		
		return htmlRepresentation;
	}
}