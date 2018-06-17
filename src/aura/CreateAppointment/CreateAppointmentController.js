({
    afterScriptsLoaded: function(component,event,helper){
     // helper.afterScriptsLoaded;
    
      var dayview;
        //alert('entered first event');
       	var eventArr = [];
    	//console.log(component.get("v.Seconds"));
    	helper.doInit(component, event, helper);
        var events = component.get("v.events");
        //alert(events.length);
        
           console.log('inside fetch events');
           var action = component.get("c.getEvents"); 
           
           action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS"){
             // alert(JSON.stringify(response.getReturnValue()));
             
                eventArr = helper.transformToFullCalendarFormat(component, response.getReturnValue());
                helper.loadDataToCalendar(component, eventArr);
              
             	
               
            
             // alert('returned from helper');
              //alert(eventArr.length);
              
             // alert(component.get("v.events").length);
               } 
            }); 
           $A.enqueueAction(action); 
            
       
       // component.set("v.events",eventArr);
        //alert("the initial events size is "+eventArr.length);
        

          console.log(component.find('calendar'));
            


            
         //alert('entered if condition')
     component.set("v.events", eventArr);
       
    },

    handleSelectHour : function(component, event, helper){
        //helper.handleSelectHour(component, event, helper);
        //alert('iam here');
        helper.doInit(component, event, helper);
        var selected;
    	var theName =  event.getSource().get("v.name");
     if(theName == "hour_opt"){
    	 selected = event.getSource().get("v.value");
     
    	//alert(selected);
    	component.set("v.Hour", selected);
       }
       else{
          selected = event.getSource().get("v.value");
    	//alert(selected);
    	component.set("v.endHour", selected);
       }
    	console.log(component.get("v.Hour"));
    },

       handleSelectMinute : function(component, event, helper){
        //helper.handleSelectMinute(component, event, helper);
        helper.doInit(component, event, helper);
    	var selected;
    	var theName =  event.getSource().get("v.name");
     if(theName == "minute_opt"){
    	 selected = event.getSource().get("v.value");
     
    	//alert(selected);
    	component.set("v.Minute", selected);
       }
       else{
          selected = event.getSource().get("v.value");
    	//alert(selected);
    	component.set("v.endMinute", selected);
       }
    },

    handleAMorPMCheck : function(component, event, helper){
      //helper.handleAMorPMCheck(component, event, helper);
     helper.doInit(component, event, helper);
    	var selected;
    	var theName =  event.getSource().get("v.name");
      if(theName == "ampm_opt"){
    	 selected = event.getSource().get("v.value");
      
    	//alert(selected);
    	component.set("v.endAMORPM", selected);
       }
       else{
          selected = event.getSource().get("v.value");
    	//alert(selected);
    	component.set("v.endendAMORPM", selected);
       }
    },

     handleShowAs : function(component, event, helper){
      //helper.handleShowAs(component, event, helper);
     //helper.doInit(component, event, helper);
      var selected;
      var theName =  event.getSource().get("v.name");
      if(theName == "showAs_opt"){
       selected = event.getSource().get("v.value");
      
      //alert(selected);
      component.set("v.showAs", selected);
       }
      
    },

     handleSubject : function(component, event, helper){
     //helper.doInit(component, event, helper);
      //helper.handleSubject(component, event, helper);
      var selected;
      var theName =  event.getSource().get("v.name");
      if(theName == "subject_opt"){
       selected = event.getSource().get("v.value");
      
      //alert(selected);
      component.set("v.subject", selected);
       }
      
    },

    cancel : function(component, event, helper){
       if($('.dayClickWindow').is(":visible")){
              $( '.dayClickWindow').hide();
            }
          },

    submitTime : function(component, event, helper){
      var returnedVerbiage;
      //helper.submitTime(component, event, helper);
    	var theYear = parseInt(component.get("v.Year"));
    	var theMonth = parseInt(component.get("v.Month"));
    	var theDate = parseInt(component.get("v.Day"));
    	var theHour = (component.get("v.AMORPM") == "PM" && component.get("v.Hour") != 12) ? parseInt(component.get("v.Hour"))+12 : parseInt(component.get("v.Hour"));
    	console.log('the hour is '+theHour);
    	var theMinute = parseInt(component.get("v.Minute"));
    	var startDate = new Date(theYear, theMonth, theDate, theHour, theMinute, 0);
    	console.log('the startDate is' +startDate);

    	var theYear = parseInt(component.get("v.Year"));
    	var theMonth = parseInt(component.get("v.Month"));
    	var theDate = parseInt(component.get("v.Day"));
    	var theEndHour = (component.get("v.endAMORPM") == "PM" && component.get("v.endHour") != 12)? parseInt(component.get("v.endHour"))+12 : parseInt(component.get("v.endHour"));
    	console.log('the endhour is '+theEndHour);
    	var theEndMinute = parseInt(component.get("v.endMinute"));
    	var endDate = new Date(theYear, theMonth, theDate, theEndHour, theEndMinute, 0);
    	console.log('the endDate is' +endDate);
        
    	component.set("v.event.Subject", component.get("v.subject"));
    	component.set("v.event.OwnerId", component.get("v.lead.OwnerId"));
       //component.set("v.event.WhoId", '003f400000OQ270AAD');
      // component.set("v.event.WhatId", '006f400000CISwVAAX');
      component.set("v.event.ShowAs", component.get("v.showAs"));
      component.set("v.event.StartDateTime", startDate);
      component.set("v.event.EndDateTime", endDate);

      function isLightningDesktop() {
        //alert(typeof sforce !== 'undefined');
         return typeof sforce !== 'undefined';
         //return((typeof sforce != 'undefined') && sforce && (!!sforce.one));
      }
      
       var myevent = component.get("v.event");
       myeventparsed = JSON.stringify(myevent);
       console.log('##the event is' +JSON.stringify(myevent));
       console.log('##the record id is' +component.get("v.recordId"));
       var toastEvent = $A.get("e.force:showToast");
        var action = component.get("c.saveEvent");
       action.setParams({"theEvent": myevent,
                          "leadId" : component.get("v.recordId")});
       action.setCallback(this, function(response){
        if(response.getState() === "SUCCESS"){
           returnedVerbiage = JSON.parse(JSON.stringify(response.getReturnValue()));
            console.log('the returned verbiage is '+returnedVerbiage);
           // var theEvents = component.get("v.events");
            //theEvents.push(insertedEvent);
            //component.set("v.events", theEvents);
            //console.log("the final events are "+JSON.stringify(component.get("v.events").length));
            
                if(returnedVerbiage.length > 1){

                   alert(returnedVerbiage);

             if(isLightningDesktop()) {

                sforce.one.navigateToList('00Bf4000007LZJ7EAO', 'custom list view', 'Opportunity');
                       //window.location = ('lightning/o/Opportunity/list?filterName=Recent&0.source=alohaHeader'); 
                       //window.location = ('lightning/o/Opportunity/list?filterName=Recent');
                         /*var listviews = response.getReturnValue();
                      var navEvent = $A.get("e.force:navigateToList");
                   navEvent.setParams({
                  "listViewId": "00Bf4000007LZJ7EAO",
                  "listViewName": null,
                   "scope": "Opportunity"
            });
            navEvent.fire();*/
                 }
            else {
                 // alert('inside else');
                  window.location = ('/006/o');
     }
                }
             
             
              toastEvent.setParams({
               "title": "Success!",
                "message": " Your Appointment has been inserted successfully."
          });

               

            
           




        }
        else{
        	var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                 }
                 toastEvent.setParams({
                  "title" : "Error!",
                  "message" : " Something has gone wrong."
                 });

        }
        toastEvent.fire();
    });

    $A.enqueueAction(action);
    //alert(returnedVerbiage);
    if($('.dayClickWindow').is(":visible")){
              $( '.dayClickWindow').hide();
            }

     

       


     
  /*var parsedEvent = JSON.parse(JSON.stringify(myevent));
   var events= component.get("v.events");
    events.push(parsedEvent);
    component.set("v.events", events);*/

    },

    showSpinner: function(component, event, helper) {
       // make Spinner attribute true for display loading spinner 
        component.set("v.Spinner", true); 
   },
    
 // this function automatic call by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
     // make Spinner attribute to false for hide loading spinner    
       component.set("v.Spinner", false);
    }
  

})