public class AffectedEnterpriseProject 
{
	public String ProjectName{get;set;}
	public String Address{get;set;}
	public String City{get;set;}
	public String State{get;set;}
	public String County{get;set;}
	public String ZIP{get;set;}
	public String FIPSCode{get;set;}
	public String Latitude{get;set;}
	public String Longitude{get;set;}
	
	public String AddressDetail 
	{
		get
		{
			String projectAddressLine = Address + ', ' + City + ', ' + State;
			return projectAddressLine; 
		}	
	}
	
	public String ToHTML()
	{
		String htmlRepresentation = '<tr>';
		
		htmlRepresentation = htmlRepresentation + '<td style="vertical-align:top; font-family:verdana; font-size:11px;">';
		htmlRepresentation = htmlRepresentation + ProjectName;
		htmlRepresentation = htmlRepresentation + '</td>';
		
		htmlRepresentation = htmlRepresentation + '<td style="vertical-align:top; font-family:verdana; font-size:11px;">';
		htmlRepresentation = htmlRepresentation + AddressDetail;
		htmlRepresentation = htmlRepresentation + '</td>';
	
		htmlRepresentation = htmlRepresentation + '</tr>';
		
		return htmlRepresentation;	
	}
}