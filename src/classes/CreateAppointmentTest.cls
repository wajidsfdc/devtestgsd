@isTest
public class CreateAppointmentTest {
    
    static testmethod void testSaveEvent(){
        list<lead> leadlist = new list<lead>();
         Lead l1 = new lead();
         l1.lastName = 'test1';
          l1.company = 'testcompany1';
          l1.city = 'Austin';
          l1.state = 'TX';
        leadlist.add(l1);
        
        
        lead l2 = new lead();
        l2.lastName = 'test2';
        l2.company = 'testcompany2';
        l2.city = 'Houston';
        l2.State = 'TX';
        
        leadlist.add(l2);
        
        lead l3 = new lead();
        l3.lastName = 'test2';
        l3.company = 'testcompany2';
        l3.city = 'Houston';
        l3.State = 'TX';
        
        leadlist.add(l3);
        insert leadlist;
        
        event e1 = new event();
        e1.startdateTime = datetime.newInstance(2018, 09, 20, 8, 30, 0);
        e1.endDatetime = e1.startdatetime.addHours(1);
        e1.subject = 'Appointment';
        
        event e2 = new event();
        e2.startdateTime = datetime.newInstance(2018, 09, 20, 10, 30, 0);
        e2.endDatetime = e2.startdatetime.addHours(1);
        e2.subject = 'Appointment';
        
         event e3 = new event();
        e3.startdateTime = datetime.newInstance(2018, 09, 20, 12, 30, 0);
        e3.endDatetime = e3.startdatetime.addHours(1);
        e3.subject = 'Appointment';
         
        createappointmentcontroller.saveEvent(e1, leadlist[0].id);
        
        
        test.startTest();
       StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
         mock.setStaticResource('DistanceResponse');
         mock.setStatusCode(200);
         mock.setHeader('Content-Type', 'application/json');
         Test.setMock(HttpCalloutMock.class, mock);
         createappointmentcontroller.saveEvent(e3, leadlist[2].id);
       // createappointmentcontroller.saveEvent(e2, leadlist[1].id);
        
        test.stopTest();
        
        
        
        
        
        
        
    }
    
    static testmethod void testSaveEvent2(){
        list<lead> leadlist = new list<lead>();
         Lead l1 = new lead();
         l1.lastName = 'test4';
          l1.company = 'testcompany4';
          l1.city = 'Austin';
          l1.state = 'TX';
        leadlist.add(l1);
        
        
        lead l2 = new lead();
        l2.lastName = 'test4';
        l2.company = 'testcompany4';
        l2.city = 'Houston';
        l2.State = 'TX';
        
        leadlist.add(l2);
        
       
        
        
        insert leadlist;
        
        event e1 = new event();
        e1.startdateTime = datetime.newInstance(2018, 09, 20, 13, 30, 0);
        e1.endDatetime = e1.startdatetime.addHours(1);
        e1.subject = 'Appointment';
        
        event e2 = new event();
        e2.startdateTime = datetime.newInstance(2018, 09, 20, 10, 30, 0);
        e2.endDatetime = e2.startdatetime.addHours(1);
        e2.subject = 'Appointment';
        
         
         
        createappointmentcontroller.saveEvent(e1, leadlist[0].id);
        
        
        test.startTest();
       StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
         mock.setStaticResource('DistanceResponse');
         mock.setStatusCode(200);
         mock.setHeader('Content-Type', 'application/json');
         Test.setMock(HttpCalloutMock.class, mock);
         
       createappointmentcontroller.saveEvent(e2, leadlist[1].id);
        
        test.stopTest();
        
        
        
        
        
        
        
    }
    
    
    static testmethod void testQueryEvents(){
       
        list<event> events = new list<event>();
        event e1 = new event();
        e1.startdateTime = datetime.newInstance(2018, 09, 20, 8, 30, 0);
        e1.endDatetime = e1.startdatetime.addHours(1);
        e1.subject = 'Appointment';
        events.add(e1);
        
        event e2 = new event();
        e2.startdateTime = datetime.newInstance(2018, 09, 20, 10, 30, 0);
        e2.endDatetime = e2.startdatetime.addHours(1);
        e2.subject = 'Appointment';
        events.add(e2);
        
        
         event e3 = new event();
        e3.startdateTime = datetime.newInstance(2018, 09, 20, 12, 30, 0);
        e3.endDatetime = e3.startdatetime.addHours(1);
        e3.subject = 'Appointment';
         events.add(e3);
        insert events;
        //createappointmentcontroller.saveEvent(e1, leadlist[0].id);
        
        
        test.startTest();
        createappointmentcontroller.getEvents();
        
        test.stopTest();
        
        
        
        
        
    }
    
   
    
    

}