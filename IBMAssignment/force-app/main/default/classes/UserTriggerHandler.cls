public without sharing class UserTriggerHandler {
    public static void afterInsert(List<User> newList, Map<Id, User> newMap) {
        Map<Id, User> updatedUsers      = new Map<Id, User>();
        Map<Id, Id> contactIdWithUserId = new Map<Id, Id>();
        for (User usr : newList) {
            if (usr.ContactId != null) {
                if ((usr.Street != null) || (usr.City != null) || (usr.State != null) || (usr.PostalCode != null) || (usr.Country != null)) {
                    updatedUsers.put(usr.Id, usr);
                    contactIdWithUserId.put(usr.ContactId, usr.Id);
                }
            }
        }
        if (!updatedUsers.isEmpty()) {
            syncContactAddressWithUserAddress(updatedUsers, contactIdWithUserId);
        }
    }
    public static void afterUpdate(List<User> newList, Map<Id, User> newMap,  List<User> oldList, Map<Id, User> oldMap) {
        Map<Id, User> updatedUsers      = new Map<Id, User>();
        Map<Id, Id> contactIdWithUserId = new Map<Id, Id>();
        for (User usr : newList) {
            if (usr.ContactId != null) {
                if ((usr.Street != oldMap.get(usr.Id).Street) || (usr.City != oldMap.get(usr.Id).City) ||
                    (usr.State != oldMap.get(usr.Id).State) || (usr.PostalCode != oldMap.get(usr.Id).PostalCode) ||
                    (usr.Country != oldMap.get(usr.Id).Country)) {
                        updatedUsers.put(usr.Id, usr);
                        contactIdWithUserId.put(usr.ContactId, usr.Id);
                }
            }
        }
        if (!updatedUsers.isEmpty()) {
            syncContactAddressWithUserAddress(contactIdWithUserId);
        }
    }
    public static void syncContactAddressWithUserAddress(Map<Id, User> userMap, Map<Id, Id> contactIdWithUserId) {
        if (!userMap.isEmpty()) {
            List<Contact> lstContact = [SELECT Id, MailingStreet, MailingCity, MailingState, MailingPostalCode, MailingCountry
                                        FROM Contact
                                        WHERE Id IN: contactIdWithUserId.keySet()];
            for (Contact cont : lstContact) {
                cont.MailingStreet     = userMap.get(contactIdWithUserId.get(cont.Id)).Street;
                cont.MailingCity       = userMap.get(contactIdWithUserId.get(cont.Id)).City;
                cont.MailingState      = userMap.get(contactIdWithUserId.get(cont.Id)).State;
                cont.MailingPostalCode = userMap.get(contactIdWithUserId.get(cont.Id)).PostalCode;
                cont.MailingCountry    = userMap.get(contactIdWithUserId.get(cont.Id)).Country;
                //cont.Country__c      = userMap.get(contactIdWithUserId.get(cont.Id)).Country__c;
            }
            update lstContact;
        }
    }
    @future
    public static void syncContactAddressWithUserAddress(Map<Id, Id> contactIdWithUserId) {
        Map<Id, User> userMap = new Map<Id, User>([SELECT Id, Street, City, State, PostalCode, Country FROM User WHERE Id IN: contactIdWithUserId.values()]);
        if (!userMap.isEmpty()) {
            List<Contact> lstContact = [SELECT Id, MailingStreet, MailingCity, MailingState, MailingPostalCode, MailingCountry
                                        FROM Contact
                                        WHERE Id IN: contactIdWithUserId.keySet()];
            for (Contact cont : lstContact) {
                cont.MailingStreet     = userMap.get(contactIdWithUserId.get(cont.Id)).Street;
                cont.MailingCity       = userMap.get(contactIdWithUserId.get(cont.Id)).City;
                cont.MailingState      = userMap.get(contactIdWithUserId.get(cont.Id)).State;
                cont.MailingPostalCode = userMap.get(contactIdWithUserId.get(cont.Id)).PostalCode;
                cont.MailingCountry    = userMap.get(contactIdWithUserId.get(cont.Id)).Country;
            }
            update lstContact;
        }
    }
}