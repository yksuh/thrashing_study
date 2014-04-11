package azdblab.utility.watcher;

public class ParseNotification {
	public static AZDBNotification formatNotification(AZDBNotification n){
		  String[] info = n.getMessage().split("&");
		  int type=0;
		  try{
		  type=Integer.parseInt(info[0].trim());
		  }catch(NumberFormatException ex){
			  return n;
		  }
		  System.out.println("parse type " +type);
		  if(type ==1){
			  //donothing
			  return n;
		}if(type==3||type==2){
			//email
			return new AZDBNotification(n.getSource(), n.getSequenceNumber(), n.getTimeStamp(),
					info[1], info[2], type);
		}if(type==4){
			return new AZDBNotification(n.getSource(), n.getSequenceNumber(), n.getTimeStamp(),
					info[1], info[2], info[3],type);
		}
		return n;
		}
}
