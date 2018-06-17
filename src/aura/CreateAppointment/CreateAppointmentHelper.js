({

  doInit : function(component, event, helper){
    var theHours = [];
        for(var i = 0; i <= 12; i++){

            if(i < 10){
                i = '0' +i 
            }
            theHours.push(String(i));
            
        }
       


       component.set("v.Hours", theHours );
        console.log("the lead id is" +component.get("v.recordId"));
        var theleadid = component.get("v.recordId");
         var action = component.get("c.getLead");

         action.setParams({"Id" : theleadid});
        action.setCallback(this, function(response){
         if(response.getState() === "SUCCESS"){
            component.set("v.lead", response.getReturnValue());
            console.log("the lead is "+component.get("v.lead.Owner.FirstName"));
         }
       });
         $A.enqueueAction(action);
       },

        
       transformToFullCalendarFormat : function(component, events){
        //alert('entered helper');
         var eventArr = [];
        for(var i = 0;i < events.length;i++){
            eventArr.push({
                'id':events[i].Id,
                'start':events[i].StartDateTime,
                'end':events[i].EndDateTime,
                'title':events[i].Subject
            });
        }
        return eventArr;
       },

       loadDataToCalendar : function(component, eventArr){
        var d = new Date();
            var t = d.getDay();
          var ele = component.find('calendar').getElement();
           // alert('just before entering inside full calendar' +eventArr.length);
            $(ele).fullCalendar({
               
            
                header: {
                    left: 'prev',
                    center: 'title',
                    right: 'next' 
                },
                
                firstDay: t,
                timezone : 'local',
                editable: true,
                eventLimit: true,
                defaultView: 'agendaWeek',
                defaultEventMinutes:30,
                minTime : "06:00:00",
                maxTime : "20:00:00",
                events: eventArr,
                slotminutes : 30,
                displayEventEnd : true,
                slotDuration: '00:30:00',
                //slotLabelInterval: 30,

                selectable:true,
                eventClick: function (calEvent, jsEvent, view) {
                    var strconfirm = confirm("You already have an event for this time do you want to book anyway?");
                    if(strconfirm == true){
                        //alert('you are continuing');
                        dayview = component.find('dayview').getElement();
                    console.log('the dayview is '+dayview);
                    var stdate = calEvent.start;
                    var date = new Date(stdate);
                     


                   //alert(mydate.getFullYear());
                    $(dayview).show();
                    component.set("v.Year", date.getFullYear());
                    component.set("v.Month", date.getMonth());
                    component.set("v.Day", date.getDate());
                    //console.log(mydate.getMonth());
                     //console.log(date.getDate());
                     //console.log(component.get("v.Day"));
                     var theStartHour = date.getHours();

                     
                    console.log('the start hour is '+theStartHour);

                   if(theStartHour >= 12 && theStartHour < 24){
                        component.set("v.AMORPM", "PM")
                    }
                    else{
                        component.set("v.AMORPM", "AM");
                    }
                    var finalStartHour;
                    if(theStartHour > 12){
                         finalStartHour = theStartHour - 12;
                    }
                    else{
                        finalStartHour = theStartHour;
                    }


                    component.set("v.Hour", finalStartHour);
                    component.set("v.Minute", date.getMinutes());

                   

                    var theEndHour = theStartHour + 1;

                    console.log('the end hour is '+theEndHour);

                    if(theEndHour >= 12 && theEndHour < 24){
                        component.set("v.endAMORPM", "PM")
                    }
                    else{
                        component.set("v.endAMORPM", "AM");
                    }

                   

                    if(theEndHour > 12){
                       var finalEndHour = theEndHour - 12;
                    }
                    else{
                        var finalEndHour = theEndHour;
                    }

                    component.set("v.endHour", finalEndHour);
                    component.set("v.endMinute", date.getMinutes());



                    

                    //component.set("v.endHour", theEndHour);
                    //component.set("v.endMinute", date.getMinutes());
                    //console.log(date.getMonth());
                     //console.log(date.getDate());
                     console.log(component.get("v.Day"));
                     console.log('$$the hour is '+date.getHours());
                     console.log('$$the minutes is '+date.getMinutes());
                        
                    }
                     
           //what should happen when event is clicked   
                },
                dayClick: function(date, jsevent, view) {

                    dayview = component.find('dayview').getElement();
                    console.log('the dayview is '+dayview);
                    $(dayview).show();
                    var date = new Date(date);
                    component.set("v.Year", date.getFullYear());
                    component.set("v.Month", date.getMonth());
                    component.set("v.Day", date.getDate());
                    component.set("v.showAs", "Busy");
                    component.set("v.subject", "Appointment");
                    var theStartHour = date.getHours();

                     
                    console.log('the start hour is '+theStartHour);

                   if(theStartHour >= 12 && theStartHour < 24){
                        component.set("v.AMORPM", "PM")
                    }
                    else{
                        component.set("v.AMORPM", "AM");
                    }
                    var finalStartHour;
                    if(theStartHour > 12){
                         finalStartHour = theStartHour - 12;
                    }
                    else{
                        finalStartHour = theStartHour;
                    }


                    component.set("v.Hour", finalStartHour);
                    component.set("v.Minute", date.getMinutes());

                   

                    var theEndHour = theStartHour + 1;

                    console.log('the end hour is '+theEndHour);

                    if(theEndHour >= 12 && theEndHour < 24){
                        component.set("v.endAMORPM", "PM")
                    }
                    else{
                        component.set("v.endAMORPM", "AM");
                    }

                   

                    if(theEndHour > 12){
                       var finalEndHour = theEndHour - 12;
                    }
                    else{
                        var finalEndHour = theEndHour;
                    }

                    component.set("v.endHour", finalEndHour);
                    component.set("v.endMinute", date.getMinutes());



                    

                    //component.set("v.endHour", theEndHour);
                    //component.set("v.endMinute", date.getMinutes());
                    //console.log(date.getMonth());
                     //console.log(date.getDate());
                     console.log(component.get("v.Day"));
                     console.log('$$the hour is '+date.getHours());
                     console.log('$$the minutes is '+date.getMinutes());

                
               }
           });
        }
                

        }
      }    
       },

        
    

      
    })