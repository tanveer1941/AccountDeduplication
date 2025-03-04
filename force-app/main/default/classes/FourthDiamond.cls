global with sharing class FourthDiamond implements Database.Batchable<AggregateResult>{ 
    private static final Integer BATCH_SIZE = Integer.valueOf(System.Label.Dedup_Batch_Size);
    private static final Integer LIMIT_FOR_RELATED_OPPORTUNITIES=Integer.valueOf(System.label.Dedupe_Related_Opportunities_Limit);
    global Iterable<AggregateResult> start(Database.batchableContext info){
        // just instantiate the new iterable here and return
        return new AccountEmailOptInAggregateResultIterable();
    }
     
    global void execute(Database.BatchableContext BC, List<Sobject> scope){ //  Email_Mobile_Key__c
        // New Section added ---- Start ----
        Set<String> stringList = new Set<String>();
        List<String> decimalList = new List<String>();
        // New Section added ---- End ----
 
        Set<String> EmailCampspotIDKeySet = new Set<String>();
        Map<String, List<Account>> accountMap = new Map<String, List<Account>>();
        List<Account> accountsRetrieved = new List<Account>();
        List<Account> accountsToKeepList = new List<Account>();
        List <Task> tasksToUpdateList = new List<Task>();
        List<Opportunity> opportunitiesToUpdateList = new List<Opportunity>();
        List<Case> casesToUpdateList = new List<Case>();
        List<Lead> leadsRefferedToUpdateList = new List<Lead>();
        List<Opportunity> opportunitiesReferredToUpdateList = new List<Opportunity>();
        List<Note> newNotesList = new List<Note>();
        List<Note> oldNotesList = new List<Note>();
        List<Attachment> newAttachmentsList = new List<Attachment>();
        List<Attachment> oldAttachmentsList = new List<Attachment>();
        List<Survey_Feedback__c> surveyFeedbacksListToUpdate = new List<Survey_Feedback__c>();
        List<talkdesk__Talkdesk_Activity__c> talkdeskactivitiesToUpdate = new List<talkdesk__Talkdesk_Activity__c>();
        List<LiveChatTranscript> livechattranscriptstoUpdate = new List<LiveChatTranscript>();
        List<Account> accountsToDeleteList = new List<Account>();
        Set<ID> accountIds = new Set<ID>();
        Set<Id> contactIdsPersonAccount = new Set<Id>();
        List<Account> allAccounts = new List<Account>();
        List<Invoice_Charge__c>chargestoupdate = new List<Invoice_Charge__c>();
        List<Earning__c> earningstoupdate = new List<Earning__c>();
        List<Award__c> awardstoupdate = new List<Award__c>();
        List<Contact> currContacts = new List<Contact>();
        List<et4ae5__IndividualEmailResult__c> IERsToUpdateList = new List<et4ae5__IndividualEmailResult__c>();
        EmailCampspotIDKeySet = new Set<String>();
        for (SObject so : scope)  {
            
            AggregateResult ar = (AggregateResult) so;
            //System.debug('ar: ' +ar);
            //if ((String)ar.get('Email_Phone_Key__c') != null){
            //    EmailCampspotIDKeySet.add((String)ar.get('Email_Phone_Key__c') );
            EmailCampspotIDKeySet.add((String)ar.get('PersonEmail'));


            }
            
           // System.debug('EmailCampspotIDKeySet: '+EmailCampspotIDKeySet);
        
        accountsRetrieved = [SELECT id, SMS_Opt_in__c, Email_Opt_in__c, PersonEmail, PersonContactId, 
                                    (SELECT id FROM Opportunities LIMIT :LIMIT_FOR_RELATED_OPPORTUNITIES+1)  
                               FROM Account 
                              WHERE PersonEmail=: EmailCampspotIDKeySet 
                                AND ( SMS_Opt_in__c=true or Email_Opt_in__c = true)
                           ORDER BY CreatedDate DESC];
        Map<Id,Account> accountsRetrievedMap=new Map<Id,Account>(accountsRetrieved);
        if ( accountsRetrieved != null && !accountsRetrieved.isEmpty() ){
            for(Account acc : accountsRetrieved)
            {
                if(accountMap.containsKey(acc.PersonEmail)) {
                    List<Account> accountsList = accountMap.get(acc.PersonEmail);
                  //  System.debug(accountMap.get(acc.Email_Mobile_Key__c));
                    accountsList.add(acc);
                    accountMap.put(acc.PersonEmail, accountsList);
                    if (acc.Opportunities.size()>LIMIT_FOR_RELATED_OPPORTUNITIES)
                {
                    accountMap.remove(acc.PersonEmail);
                }
                } else {
                    accountMap.put(acc.PersonEmail, new List<Account> { acc });
                }

                contactIdsPersonAccount.add(acc.PersonContactId);
            }
        }
        
        
        // New Section added ---- Start ----
        Map<String, List<String>> fieldsMap = DedupUtils.getFieldsMap();
        List<String> fieldsList = DedupUtils.getFields(fieldsMap);
        String soql = DedupUtils.getQuery(fieldsList, 'accountIds');
        List<Account> accsAtOnce1 = DedupUtils.getAllAtOnce(accountsRetrievedMap.keySet(),soql);
        
        for(String str : fieldsMap.keyset())
        {
            if(str == 'STRING' || 
               str == 'PICKLIST' ||
               str == 'REFERENCE'|| 
               str == 'TEXTAREA'|| 
               str == 'URL' || 
               str == 'EMAIL' || 
               str == 'MULTIPICKLIST')
            {
                
                stringList.addAll(fieldsMap.get(str));
                
            }
            else if (str == 'DOUBLE' || 
                    str == 'CURRENCY' ||
                    str == 'INTEGER'||
                    str == 'PERCENT')
            {
                decimalList.addAll(fieldsMap.get(str));
            }
        }
        
        
        
        // New Section added ---- End ----
    
        
      //  List<Account> accsAtOnce1 = DedupUtils.getAllAtOnce(accountsRetrievedMap.keySet());
        List<Contact> contactsWithTasks = DedupUtils.getAllContactsAtOnce(contactIdsPersonAccount);
        Map<id,Contact> contactsWithTasksMap = new Map<id,Contact>(contactsWithTasks);
        Map<Id,Account>accsAtonceMap=new Map<Id,Account>(accsAtOnce1);
        System.debug('accountMap: '+accsAtOnce1.size());
       
        
        
        if ( EmailCampspotIDKeySet != null && !EmailCampspotIDKeySet.isEmpty() && !accountMap.isEmpty()){
            for(String EmailCampspotIDKey : EmailCampspotIDKeySet)
            {
                accountIds = new Set<Id>();
                allAccounts=new List<Account>();
                currContacts = new List<Contact>();
                if (accountMap.get(EmailCampspotIDKey)!=null)
                {

                
                for (Account acc: accountMap.get(EmailCampspotIDKey)){
                    
                    accountIds.add(acc.id);
                    allAccounts.add(accsAtonceMap.get(acc.id));
                    currContacts.add(contactsWithTasksMap.get(acc.PersonContactId));
                    
                        }
                }
                if(!allAccounts.isEmpty())
                {
                   // List<Account> accsAtOnce = DedupUtils.getAllAtOnce(Accountids);
                    
                    
                    Map<Id,Contact>currContactMap= new Map<id,Contact>(currContacts);
                    DedupUtils.accs=allAccounts;
                    DedupUtils.currContacts=currContacts;
                    DedupUtils.currContactMap=currContactMap;
                    System.debug('Accs : '+DedupUtils.accs.size());
                   
                    
                    
                   Map<String, boolean> checkBoxesValues = DedupUtils.getCheckBoxesValues(fieldsMap.get('BOOLEAN'));
                    Map<String, String> remainingFields = DedupUtils.getRemainingFieldsValues(stringList);
                    //Map<String, String> newFields = DedupUtils.getNewFieldsValues();
                    Map<String, Date> Dates= DedupUtils.getDates(fieldsMap.get('DATE'));
                    Map<String,Decimal> Decimals = DedupUtils.getDecimals(decimalList);
                    Map<String,DateTime> DateTimes = DedupUtils.getDateTimes(fieldsMap.get('DATETIME'));
                
                    Account accountToKeep = DedupUtils.getUpdatedAccount(allAccounts, checkBoxesValues, remainingFields, Dates , Decimals , DateTimes);
                    accountsToKeepList.add(accountToKeep);
                    List<Account> accountsToDelete = DedupUtils.getAccountsToDelete(allAccounts, accountToKeep);
                    
                    List<Task> accountRelatedTasks = DedupUtils.getAccountRelatedTasks();
                    List<Task> contactRelatedTasks = DedupUtils.getcontactRelatedTasks();
                    if(!accountRelatedTasks.isEmpty() || !contactRelatedTasks.isEmpty())
                    {
                        List <Task> tasksToUpdate = DedupUtils.getTasksToUpdate(accountRelatedTasks, accountToKeep,contactRelatedTasks);
                        tasksToUpdateList.addAll(tasksToUpdate);
                        //updateTasks(tasksToUpdate);
                    }
                    List<et4ae5__IndividualEmailResult__c> contactRelatedIERS = DedupUtils.getcontactRelatedIndividualEmailResults();
                    if (!contactRelatedIERS.isEmpty()){
                        List<et4ae5__IndividualEmailResult__c> IERsToUpdate = DedupUtils.getIERsToUpdate(contactRelatedIERS,accountToKeep);
                         IERsToUpdateList.addAll(IERsToUpdate);
    
                    }
                    List<Opportunity> opportunitiesToUpdate = DedupUtils.getOpportunitiesToUpdate(accountToKeep);
                    if(!opportunitiesToUpdate.isEmpty())
                    {
                        opportunitiesToUpdateList.addAll(opportunitiesToUpdate);
                        //updateOpportunities(opportunitiesToUpdate);
                    }
                    
                    List<Case> accountRelatedCases = DedupUtils.getAccountRelatedCases();
                    List<Case> contactRelatedCases = DedupUtils.getContactRelatedCases();
                    if(!accountRelatedCases.isEmpty() || !contactRelatedCases.isEmpty())
                    {
                        List<Case> casesToUpdate = DedupUtils.getCasesToUpdate(accountRelatedCases,contactRelatedCases, accountToKeep);
                        casesToUpdateList.addAll(casesToUpdate);
                        //updateCases(casesToUpdate);
                    }
                    List<Lead> leadsRefferedToUpdate = DedupUtils.getLeadsReffered( accountToKeep);
                    if(!leadsRefferedToUpdate.isEmpty())
                    {
                        leadsRefferedToUpdateList.addAll(leadsRefferedToUpdate);
                        //updateLeadsReffered(leadsReffered);
                    }
                    
                    List<Opportunity> opportunitiesReferredToUpdate = DedupUtils.getOpportunitiesReferred( accountToKeep);
                    if(!opportunitiesReferredToUpdate.isEmpty())
                    {
                        opportunitiesReferredToUpdateList.addAll(opportunitiesReferredToUpdate);
                        //updateOpportunitiesReferred(opportunitiesReferred);
                    }
                    
                    List<Survey_Feedback__c> surveyFeedbacks = DedupUtils.getSurveyFeedbackList( accountToKeep);
                    if(!surveyFeedbacks.isEmpty())
                    {
                        surveyFeedbacksListToUpdate.addAll(surveyFeedbacks);
                        //DedupUtils.updateSurveyFeedbacks(surveyFeedbacksListToUpdate);
                    }
                    List<talkdesk__Talkdesk_Activity__c> taskdestActivites = DedupUtils.gettaskdeskactvities(accountToKeep);
                    if (!taskdestActivites.isEmpty())
                    {
                        talkdeskactivitiesToUpdate.addAll(taskdestActivites);
                       // DedupUtils.updatetalkkdesks(talkdeskactivitiesToUpdate);

                    }
                    List<LiveChatTranscript> livechattranscripts= DedupUtils.getlivechattranscripts(accounttokeep);
                    if(!livechattranscripts.isEmpty())
                    {
                        livechattranscriptstoUpdate.addAll(livechattranscripts);
                        DedupUtils.updatealllivechattranscripts(livechattranscriptstoUpdate);
                    }
                    List<Award__c> awards= DedupUtils.getAwards(accountToKeep);
                    if (!awards.isEmpty())
                    {
                        awardstoupdate.addAll(awards);
                    }
                    List<Earning__c> earnings= DedupUtils.getEarnings(accountToKeep);
                    if (!earnings.isEmpty())
                    {
                        earningstoupdate.addAll(earnings);
                    }
                    List<Invoice_Charge__c> charges= DedupUtils.getInvoiceCharges(accountToKeep);
                    if (!charges.isEmpty())
                    {
                        chargestoupdate.addAll(charges);
                    }

                     if (!accountsToDelete.isEmpty())
                     {
                         accountsToDeleteList.addAll(accountsToDelete);
                        // DedupUtils.deleteAccounts(accountsToDeleteList);
                     }
                    
                    allAccounts=null;
                    currContacts=null;

                }

                System.debug('Number of Queries used in this apex code so far: ' + Limits.getQueries());
                System.debug('Number of rows queried in this apex code so far: ' + Limits.getDmlRows());


            }
        }
        
        for(account acc:accountsToDeleteList){
            System.debug(acc.Applicant_ID__c);
            acc.Applicant_ID__c = '';
        }
        update accountsToDeleteList;
        update tasksToUpdateList;
        update opportunitiesToUpdateList;
        update casesToUpdateList;
        update leadsRefferedToUpdateList;
        update opportunitiesReferredToUpdateList;
        update awardstoupdate;
        update earningstoupdate;
        update chargestoupdate;
        update talkdeskactivitiesToUpdate;
        update surveyFeedbacksListToUpdate;
        update IERsToUpdateList;
        insert newNotesList;
        delete oldNotesList;
        insert newAttachmentsList;
        delete oldAttachmentsList;
        delete accountsToDeleteList;
        System.debug('Account to Keep List: '+accountsToKeepList.size());
        update accountsToKeepList;
    }
    global void finish(Database.BatchableContext BC){
        Database.executeBatch(new FifthDiamond(),Batch_SIZE);
    }
    
}