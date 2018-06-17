public class CreateAppointmentController {
	 @AuraEnabled
    public static List<Event> getEvents(){
        return [SELECT AccountId, EndDateTime , Id , StartDateTime , Subject FROM Event];
    }

    @AuraEnabled
	public static String saveEvent(sobject theEvent, String leadId) {
    system.debug('the event is '+theEvent);
    system.debug('the leadId is '+leadId);
    Event e = (Event)theEvent;
    
    lead theLead = new lead();
     theLead = [select id, street, firstName, LastName, city, state, country , PostalCode, isconverted, convertedAccountId, convertedContactId, convertedopportunityId from lead where id = :LeadId limit 1];
   
     system.debug('event start time is '+e.startDateTime);
     datetime dtnew = e.startDateTime;
     datetime dtEnd = e.endDateTime;
     Integer theDate = dtnew.Day();
      /*Integer theYear = dt.Year();
      Integer theMonth = dt.Month();
      Integer theDate = dt.Day();
      Integer theHour = dt.Hour();
      Integer theMinute = dt.Minute();
      Integer theSecond = dt.second();
     datetime dt2 = datetime.newInstance(theYear, theMonth, theDate, theHour, theMinute, theSecond);*/
     list<event> previousEvent = [select id, createdDate, whoId, endDateTime from event where endDateTime <= :dtnew  order by endDateTime desc Limit 1];
     list<event> nextEvent = [select id, createdDate, whoId, startDateTime from event where startDateTime >= :dtEnd order by startDateTime asc Limit 1];
     system.debug('&&&the previous event is ' +previousEvent );
     system.debug('&&&the next event is ' +nextEvent);
      datetime prevDt;
      datetime nextDt;
      Date PrevEventDate;
      Date nextEventDate;
      Date newEventDate;
      Boolean prevSameDay;
      Boolean nextSameDay;
      newEventDate = date.newInstance(dtnew.Year(), dtnew.Month(), dtnew.Day());

        if(previousEvent.size() > 0 && previousEvent != null){
          system.debug('&&&entered previous event check');
           prevDt = previousEvent[0].endDateTime;
           PrevEventDate = date.newInstance(prevDt.Year(), prevDt.Month(), prevDt.Day());
           prevSameDay = prevEventDate == newEventDate;
        }

        if(nextEvent.size() > 0 && nextEvent != null){
          system.debug('&&&entered next event check');
           nextDt = nextEvent[0].startDateTime;
           nextEventDate = date.newInstance(nextDt.Year(), nextDt.Month(), nextDt.Day());
           nextSameDay = nextEventDate == newEventDate;
        }
        
      
         

        

        system.debug('$$$$nextSameDay is '+nextSameDay);
        system.debug('$$$$prevSameDay is '+prevSameDay);

        String prevOrNext = '';
        String verbiageToDisplayPrev = '';
        String verbiageToDisplaynext = '';
     if (previousEvent != null && previousEvent.size() > 0 && prevSameDay ){
         prevOrNext = 'prev';
        datetime dtprev = previousEvent[0].endDateTime;
        Integer minuteDifference = getMinutes(dtnew, dtprev);
        system.debug('the minutes difference with prev appt is '+minuteDifference);
        Contact prevContact = [select id, MailingStreet, MailingCity,MailingPostalCode, MailingState, MailingCountry from contact where id = :previousEvent[0].whoId];
        
        system.debug('prev contact is '+prevContact);
        string prevContactAddress = EncodingUtil.urlEncode(prevContact.MailingCity+prevContact.MailingState, 'UTF-8');
        system.debug('the prev contact address is' +prevContactAddress);
        string newLeadAddress = EncodingUtil.urlEncode(theLead.City+theLead.State, 'UTF-8');
        system.debug('the new lead address is '+newleadAddress);
        if(prevContact.MailingCity != null && thelead.city != null && prevContact.MailingState !=null && thelead.state != null){
          HttpResponse responseprev = invokeGoogleDistanceAPI(prevContactAddress, newLeadAddress, minuteDifference, prevOrNext);
          Integer travelTimeBetweenCitiesPrev = processResponse(String.valueOf(responseprev.getBody()), minuteDifference, prevOrNext);
          verbiageToDisplayPrev = checkMakeNextAppointment(travelTimeBetweenCitiesPrev, minuteDifference, prevOrNext);
        }
        

     } 

     if (nextEvent != null && nextEvent.size() > 0 && nextSameDay){
        prevOrNext = 'next';
        datetime dtnext = nextEvent[0].StartDateTime;
        Integer minuteDifference = getMinutes(dtnext, dtnew);
        system.debug('the minutes difference with next appt is '+minuteDifference);
        Contact nextContact = [select id, MailingStreet, MailingCity, MailingState,MailingPostalCode, MailingCountry from contact where id = :nextEvent[0].whoId ];
        
        system.debug('next contact is '+nextContact);
        //string nextContactAddress = nextContact.MailingCity + '+' + nextContact.MailingState;
        string nextContactAddress = EncodingUtil.urlEncode(nextContact.MailingCity+nextContact.MailingState, 'UTF-8');
        system.debug('the next contact address is' +nextContactAddress);
        //string newLeadAddress = EncodingUtil.urlEncode(theLead.city, 'UTF-8') +'+'+EncodingUtil.urlEncode(theLead.state, 'UTF-8');
        string newLeadAddress = EncodingUtil.urlEncode(theLead.City+theLead.State, 'UTF-8');
        system.debug('the next contact address is' +nextContactAddress);
        if(nextContact.MailingCity != null && thelead.city != null && nextContact.MailingState !=null && thelead.state != null){
          HttpResponse responsenext = invokeGoogleDistanceAPI( newLeadAddress,nextContactAddress, minuteDifference, prevOrNext);
          system.debug('the response received is '+responsenext.getBody());
          Integer travelTimeBetweenCitiesPrev = processResponse(String.valueOf(responsenext.getBody()), minuteDifference, prevOrNext);
          verbiageToDisplaynext = checkMakeNextAppointment(travelTimeBetweenCitiesPrev, minuteDifference, prevOrNext);
        }
        
     } 
     //datetime dtprev = previousEvent[0].endDateTime;
     //datetime dtnext =  nextEvent[0].startDateTime;

     //Integer minuteDifference = getMinutes(dtnew, dtprev);

     //system.debug('the minutes difference is '+minuteDifference);

     //Lead prevLead = [select id, city, state from lead where id = '00Qf4000007UcJt' limit 1];

     

     //Contact prevContact = [select id, MailingCity, MailingState, MailingCountry from contact where id = :previousEvent[0].whoId];
     

      //system.debug('prev lead is '+prevLead);
     // system.debug('prev contact is '+prevContact);
     //string prevleadAddress = prevLead.city + '+' + prevlead.state;
     //string prevContactAddress = prevContact.Mailingcity +'+' + prevContact.Mailingstate;
     //string nextContactAddress = nextContact.MailingCity + '+' + nextContact.MailingState;
     //system.debug(prevleadAddress);

     /*system.debug('the prev contact address is' +prevContactAddress);
     system.debug('the next contact address is' +nextContactAddress);
     string newLeadAddress = theLead.city +'+'+theLead.state;
     system.debug(newleadAddress);*/
     //String Message = invokeGoogleDistanceAPI(prevleadAddress, newLeadAddress, minuteDifference);
     Database.leadConvert lc = new database.leadConvert();
      lc.setLeadId(theLead.Id);
    LeadStatus convertStatus = [select id, Masterlabel from leadstatus where isconverted = true limit 1];
    system.debug('the convertstatus is '+convertStatus);
    lc.setConvertedStatus(convertStatus.MasterLabel);
    
    Database.leadConvertResult lcr = Database.convertLead(lc);
     

    

    
      //theEvent.DurationInMinutes = 1;
      //theEvent.EndDateTime = System.now() + 1;
      //theEvent.startdatetime = system.now();
      //system.debug('startdate is' +theEvent.startdatetime);
      //system.debug('enddate is' +theEvent.subject);
      system.debug('Entered createEvent');
      thelead = [select id, convertedAccountId, convertedContactId, convertedopportunityId from lead where id = :LeadId limit 1];
      //system.debug('the converted lead is '+theLead);
      e.whoId = theLead.convertedContactId;
      e.whatId = theLead.convertedOpportunityId;
      try{
        upsert e;
      }
      catch(exception err){
        system.debug('insert failed with exception '+err.getMessage());
      }
      
      system.debug('###the inserted event id is' +e.Id);
      string finalverbiage = 'Your Event has been Inserted \n\n';
      /*if(verbiageToDisplayPrev != null){
        finalverbiage = verbiageToDisplayPrev;
      }
      if(verbiageToDisplayPrev != null){
        finalverbiage = finalverbiage + verbiageToDisplayNext;
      }*/

      if(verbiageToDisplayPrev.length() > 0  && verbiageToDisplayNext.length()  > 0 ){
             finalverbiage += verbiageToDisplayPrev + verbiageToDisplayNext;
         }
         else if(verbiageToDisplayPrev.length() > 0 && (verbiageToDisplayNext.length() <= 1)){
             system.debug('%%%%%ENTERED CONDITION FOR PREV');
            finalverbiage += verbiageToDisplayPrev ;
         }
        else if(verbiageToDisplayNext.length() > 0 && (verbiageToDisplayPrev.length() <= 1)){
          system.debug('%%%%%ENTERED CONDITION FOR NEXT');
            finalverbiage += verbiageToDisplayNext;
        }

      system.debug('the final verbiage is '+finalverbiage);

      return finalverbiage;
      
		
	}

  @AuraEnabled
  public static Lead getLead (String Id){
    //system.debug('the record id is'+recordId);
    return [select id , name, ownerId,firstName, lastname, Street, postalCode,State,Country, Email, Phone, City,  owner.FirstName, owner.LastName from Lead where id = :Id];

  }

  public static Integer getMinutes(dateTime newdt, dateTime previousdt){
    Long prevTime = previousdt.getTime();
     Long newTime = newdt.getTime();

     Long millisecdiff = (newTime - prevTime);
     Integer theminutes = (Integer)millisecdiff/(1000*60);
     return theminutes;
  }

  public static HttpResponse invokeGoogleDistanceAPI(String oldContactAddress, String newLeadAddress, Integer theMinuteDifference, String prevnext){
    string baseurl = 'https://maps.googleapis.com/maps/api/distancematrix/json?';
    string origin = 'origins='+oldContactAddress;
    string dest =  '&destinations='+newleadAddress;
    string mode = '&mode=car';
    string trafficmodel = '&trafficModel=bestguess';
    string key = '&key=AIzaSyAaGOhG1H6k9cmBZ5Jy7irV7x7v_KVmD5g';
    string finalurl = baseurl + origin + dest + mode +trafficmodel+ key;
    String encodedUrl = EncodingUtil.URLENCODE(finalurl,'UTF-8');
     system.debug('the final url is '+finalurl);
     HTTP http = new Http();
     httpRequest req = new HttpRequest();
     req.setMethod('GET');
     req.setEndPoint(finalurl);
     HttpResponse res = http.send(req);

     system.debug('the response is '+String.valueOf(res.getBody()));
     return res;
      //system.debug('the response is '+res.getBody());
     //processResponse(res.getBody(), theMinuteDifference, prevnext);
    
  }

  public static Integer ProcessResponse(string jsonResponse, Integer minDifference, String prevnext){
      DistanceMatrixResponse response = DistanceMatrixResponse.parse(jsonResponse);

      list<string> destinationAddresses = response.destination_addresses;
      system.debug('the destinationaddreses are '+destinationAddresses);

      list<DistanceMatrixResponse.Rows> theRows = response.rows;
      DistanceMatrixResponse.Rows firstRow = theRows[0];
      system.debug('the rows are '+therows[0]);



      list<DistanceMatrixResponse.Elements> elements = firstRow.elements;
      system.debug(elements.size());

      DistanceMatrixResponse.distance dist = elements[0].distance;
      DistanceMatrixResponse.distance dur = elements[0].duration;

      system.debug('the distance is '+dist);

      Integer duration = dur.value;
      Integer durationInMinutes = (Integer)duration/60;
      return durationInMinutes;
      //checkMakeNextAppointment(durationInMinutes, minDifference, prevNext);
    }


    public static String checkMakeNextAppointment(Integer transitTimeBetweenCities, Integer timeBetweenEvents, String prevNext ){
      String travelTimeVerbiagePrev = '';
      String travelTimeVerbiagenext = ''; 
      String travelTimeVerbiage = ''; 
      system.debug('transit time between cities '+transitTimeBetweenCities);
      system.debug('time between events '+timeBetweenEvents);
          Integer hoursPrevbetweenEvents = timeBetweenEvents/60;
          Integer minutesBetweenPrevEvents = Math.mod(timeBetweenEvents, 60);
          Integer hoursPrevbetweenTravel = transitTimeBetweenCities/60;
          Integer minutesBetweenPrevTravel = Math.mod(transitTimeBetweenCities, 60);

          Integer hoursNextbetweenEvents = timeBetweenEvents/60;
          Integer minutesBetweenNextEvents = Math.mod(timeBetweenEvents, 60);
          Integer hoursNextbetweenTravel = transitTimeBetweenCities/60;
          Integer minutesBetweenNextTravel = Math.mod(transitTimeBetweenCities, 60);

         if(transitTimeBetweenCities > (timeBetweenEvents + 30) && prevNext == 'Prev' ){
          system.debug('@@@@ENTERED CONDITION FOR PREV');
           travelTimeVerbiageprev = 'You Dont have enough time to make this appointment from your previous appointment'+ '\n'+
                                'Time between previous and this event '+hoursPrevbetweenEvents+' Hours ' +minutesBetweenPrevEvents +' Minutes' + '\n'+ 
                                'Travel Time between Previous and this Appointment '+hoursPrevbetweenTravel +' Hours ' +minutesBetweenPrevTravel +' Minutes' +'\n\n';
            //system.debug('$$$YOU DONT HAVE ENOUGH TIME TO MAKE THIS APPOINTMENT FROM YOUR PREVIOUS APPOINTMENT');
            travelTimeVerbiage = travelTimeVerbiageprev;
         }
         

         if(transitTimeBetweenCities > (timeBetweenEvents + 30) && prevNext == 'next' ){
          system.debug('@@@@ENTERED CONDITION FOR NEXT');
            travelTimeVerbiageNext = 'You Dont have enough time to make your next appointment from this appointment'+ '\n'+
                                'Time between this and next event '+hoursNextbetweenEvents+' Hours ' +minutesBetweenNextEvents +' Minutes' + '\n'+ 
                                'Travel Time between this and Next Appointment '+hoursNextbetweenTravel +' Hours ' +minutesBetweenNextTravel +' Minutes';
                travelTimeVerbiage = travelTimeVerbiageNext;
         }

         /*if(travelTimeVerbiagePrev.length() > 0  && travelTimeVerbiagenext.length()  > 0 ){
            return 
         }
         else if(travelTimeVerbiagePrev.length() > 0 && (travelTimeVerbiagenext.length() <= 1)){
             system.debug('@@@@ENTERED CONDITION FOR PREV');
            travelTimeVerbiage = travelTimeVerbiagePrev;
         }
        else if(travelTimeVerbiagenext.length() > 0 && (travelTimeVerbiageprev.length() <= 1)){
          system.debug('@@@@ENTERED CONDITION FOR NEXT');
            travelTimeVerbiage = travelTimeVerbiageNext;
        }*/
          
        
         
         system.debug('###the travletime verbiage is '  + travelTimeVerbiage );
         return travelTimeVerbiage;
        
    }

 
}