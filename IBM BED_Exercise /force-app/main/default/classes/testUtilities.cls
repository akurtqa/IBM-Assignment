@IsTest
global class testUtilities {
    @TestSetup
    static void testSetup() {
        List<Account> accList = new List<Account>();
        for(Integer i = 0 ; i < 100 ; i++){
            Account temp = new Account(Name = 'Test Acc ' + i);
            accList.add(temp);
        }
        insert accList;
        List<Contact> contactList = new List<Contact>();
        for(Integer i = 0 ; i < accList.size() ; i++){
            Contact temp = new Contact(LastName = 'Test Contact ' + i, AccountId = accList[i].Id);
            contactList.add(temp);
        }
        insert contactList;
        List<Contact> lstContact = new List<Contact>();
        for(Integer i = 0 ; i < accList.size() ; i++){
            Contact temp = new Contact(LastName = 'Partner Contact ' + i, AccountId = accList[i].Id);
            lstContact.add(temp);
        }
        insert lstContact;
        Id partnerProfileId      = [SELECT Id FROM Profile WHERE Name = 'Partner Community User'].Id;
        List<User> lstUser       = new List<User>();
        for (Contact cont : lstContact) {
            User usr              = new User();
            usr.Alias             = 'pUsr'+lstContact.indexOf(cont);
            usr.Emailencodingkey  = 'UTF-8';
            usr.Lastname          = 'Testing'+lstContact.indexOf(cont);
            usr.languagelocalekey = 'en_US';
            usr.localesidkey      = 'en_US';
            usr.Profileid         = partnerProfileId;
            usr.IsActive          = true;
            usr.IsActive          = true;
            usr.ContactId         = cont.Id;
            usr.Timezonesidkey    ='America/Los_Angeles';
            usr.Email             ='test'+lstContact.indexOf(cont)+'@noemail.com';
            usr.Username          ='test'+lstContact.indexOf(cont)+'@noemail.com.partner0';
            //Address
            usr.Street     = '1150 Marsh Trail';
            usr.City       = 'Atlanta';
            usr.State      = 'Georgia';
            usr.PostalCode = '30004';
            usr.Country    = 'United States';
            lstUser.add(usr);
        }
        Test.startTest();
        insert lstUser;
        Test.stopTest();
    }
    @IsTest
    static void insertPartnerUser(){
        Id partnerProfileId      = [SELECT Id FROM Profile WHERE Name = 'Partner Community User'].Id;
        List<Contact> lstContact = [SELECT Id, MailingStreet, MailingCity, MailingState, MailingPostalCode, MailingCountry FROM Contact WHERE LastName LIKE '%Test%'];
        List<User> lstUser       = new List<User>();
        for (Contact cont : lstContact) {
            User usr              = new User();
            usr.Alias             = 'pUsr'+lstContact.indexOf(cont);
            usr.Emailencodingkey  = 'UTF-8';
            usr.Lastname          = 'Testing'+lstContact.indexOf(cont);
            usr.languagelocalekey = 'en_US';
            usr.localesidkey      = 'en_US';
            usr.Profileid         = partnerProfileId;
            usr.IsActive          = true;
            usr.IsActive          = true;
            usr.ContactId         = cont.Id;
            usr.Timezonesidkey    ='America/Los_Angeles';
            usr.Email             ='test'+lstContact.indexOf(cont)+'@noemail.com';
            usr.Username          ='test'+lstContact.indexOf(cont)+'@noemail.com.partner1';
            //Address
            usr.Street     = '1150 Marsh Trail';
            usr.City       = 'Atlanta';
            usr.State      = 'Georgia';
            usr.PostalCode = '30004';
            usr.Country    = 'United States';
            lstUser.add(usr);
        }
        Test.startTest();
        insert lstUser;
        Test.stopTest();
        Map<Id, User> updatedUsers      = new Map<Id, User>();
        Map<Id, Id> contactIdWithUserId = new Map<Id, Id>();
        for (User usr : lstUser) {
            updatedUsers.put(usr.Id, usr);
            contactIdWithUserId.put(usr.ContactId, usr.Id);
        }
        List<Contact> lstContact2 = [SELECT Id, MailingStreet, MailingCity, MailingState, MailingPostalCode, MailingCountry FROM Contact WHERE LastName LIKE '%Test%'];
        for (Contact cont : lstContact2) {
            System.assertEquals(updatedUsers.get(contactIdWithUserId.get(cont.Id)).Street, cont.MailingStreet);
            System.assertEquals(updatedUsers.get(contactIdWithUserId.get(cont.Id)).City, cont.MailingCity);
            System.assertEquals(updatedUsers.get(contactIdWithUserId.get(cont.Id)).State, cont.MailingState);
            System.assertEquals(updatedUsers.get(contactIdWithUserId.get(cont.Id)).PostalCode, cont.MailingPostalCode);
            System.assertEquals(updatedUsers.get(contactIdWithUserId.get(cont.Id)).Country, cont.MailingCountry);
        }
    }
    @IsTest
    static void updatePartnerUser(){
        Id partnerProfileId         = [SELECT Id FROM Profile WHERE Name = 'Partner Community User'].Id;
        Map<Id, Contact> mapContact = new Map<Id, Contact>([SELECT Id, MailingStreet, MailingCity, MailingState, MailingPostalCode, MailingCountry
                                                            FROM Contact
                                                            WHERE LastName LIKE '%Partner%']);
        List<User> lstUser2         = new List<User>();
        List<User> lstUser = new List<User>();
        Test.startTest();
        for (User usr : [SELECT Id, Street, City, State, PostalCode, Country, ContactId FROM User WHERE ContactId IN: mapContact.keySet()]) {
            usr.Street     = '1151 Marsh Trail';
            usr.City       = 'Atlanta';
            usr.State      = 'Georgia';
            usr.PostalCode = '30005';
            usr.Country    = 'United States';
            lstUser.add(usr);
        }
        update lstUser;
        Test.stopTest();
        Map<Id, User> updatedUsers      = new Map<Id, User>();
        Map<Id, Id> contactIdWithUserId = new Map<Id, Id>();
        for (User usr : lstUser) {
            updatedUsers.put(usr.Id, usr);
            contactIdWithUserId.put(usr.ContactId, usr.Id);
        }
        List<Contact> lstContact2 = [SELECT Id, MailingStreet, MailingCity, MailingState, MailingPostalCode, MailingCountry FROM Contact WHERE LastName LIKE '%Partner%'];
        for (Contact cont : lstContact2) {
            System.assertEquals(updatedUsers.get(contactIdWithUserId.get(cont.Id)).Street, cont.MailingStreet);
            System.assertEquals(updatedUsers.get(contactIdWithUserId.get(cont.Id)).City, cont.MailingCity);
            System.assertEquals(updatedUsers.get(contactIdWithUserId.get(cont.Id)).State, cont.MailingState);
            System.assertEquals(updatedUsers.get(contactIdWithUserId.get(cont.Id)).PostalCode, cont.MailingPostalCode);
            System.assertEquals(updatedUsers.get(contactIdWithUserId.get(cont.Id)).Country, cont.MailingCountry);
        }
    }
}