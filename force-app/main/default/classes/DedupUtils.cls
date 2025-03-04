public with sharing class DedupUtils {

    public Static List<Account> accs = new List<Account>();
    public Static List<Contact>currContacts= new List<Contact>();
    Public Static Map<id,Contact> currContactMap = new Map<id,Contact>();
    
    
    
    public static List<Account> getAccountsToDelete(List<Account> accountList, Account accountToRemove) {
        for (Integer i = accountList.size() - 1; i >= 0 ; --i) {
            if (accountList.get(i) == accountToRemove || accountList.get(i).get('id') == accountToRemove.get('id')) {
                accountList.remove(i); 
            }
            else {
                accountList.get(i).Account_Kept__c=accountToRemove.id;
            }
            
            
        }
        
        //System.debug('Accounts being deleted : '+accountList.size());
        return accountList;
    }
    
    public static Map<String, Decimal> getDecimals(List<String> fields)
    {
        Map<String, Decimal> decimalfields = new Map<String, Decimal>();
        for (Account acc : accs) 
        {
            for (string str : fields)
            {
                if ((Decimal)acc.get(str) !=NULL && !decimalfields.containsKey(str))
                {
                    decimalfields.put(str, (Decimal)acc.get(str));
                }
            }
        }
        return decimalfields;
    }
    
    
    
    public static Map<String, String> getRemainingFieldsValues(Set<String> fields)
    {
        
        Map<String, String> remainingFields = new Map<String, String>();
        
        for (Account acc : accs) 
        {
            for (string str : fields)
            {
             //System.debug('str: '+str);
                if(str =='PersonMailingCity'  || 
                   str =='PersonMailingState' || 
                   str =='PersonMailingPostalCode' || 
                   str =='PersonMailingStreet' ||
                   str =='PersonMailingCountry' )
                {
                    if (acc.PersonMailingCity != null && 
                        acc.PersonMailingState != null && 
                        acc.PersonMailingPostalCode != null && 
                        !remainingFields.containsKey('PersonMailingCity') &&
                        !remainingFields.containsKey('PersonMailingState') &&
                        !remainingFields.containsKey('PersonMailingPostalCode'))
                    {
                        remainingFields.put('PersonMailingCity', acc.PersonMailingCity);
                        remainingFields.put('PersonMailingState', acc.PersonMailingState);
                        remainingFields.put('PersonMailingPostalCode', acc.PersonMailingPostalCode);
                        remainingFields.put('PersonMailingStreet', acc.PersonMailingStreet);
                        remainingFields.put('PersonMailingCountry', acc.PersonMailingCountry);
                        //System.debug('str: '+str);
                    }
                }
                else if ((String)acc.get(str) !=NULL && !remainingFields.containsKey(str) && str != 'name' ) //
                {
                    //if (str != 'Applicant_ID__c' || str != 'Tenant_Code__c') {
                        remainingFields.put(str, (String)acc.get(str));
                    //}
                    //else {
                      //  remainingFields.put(str, (String)acc.get(str));
                      //  System.debug('acc.get(str)'+acc.get(str));
                      //  acc.put(str, null);
                      //  System.debug('acc.get(str)'+acc.get(str));
                   // }
                }
            }
        }
        
        return remainingFields;
    }
    
    public static Map<String, Date> getDates(List<String> fields)
    {
        Map<String, Date> Dates = new Map<String, Date>();
        for (Account acc : accs) 
        {
            for (string str : fields)
            {
                if ((Date)acc.get(str) !=NULL && !Dates.containsKey(str))
                {
                    Dates.put(str, (Date)acc.get(str));
                }
            }
        }
        return Dates;
    }
    
    public static Map<String, DateTime> getDateTimes(List<String> fields)
    {
        Map<String,Datetime> datetimes=new MAp<String,Datetime>();
        for (Account acc : accs) 
        {
            for (string str : fields)
            {
                if ((Datetime)acc.get(str) !=NULL && !datetimes.containsKey(str))
                {
                    datetimes.put(str, (Datetime)acc.get(str));
                }
            }
        }
        return datetimes;
    }
    public static Map<String, boolean> getCheckBoxesValues(List<String> fields)
    {
        Map<String, boolean> checkBoxesValues = new Map<String, boolean>();
        
        for (Account acc : accs) 
        {
            for (string str : fields)
            {
                if ((Boolean)acc.get(str) != FALSE && !checkBoxesValues.containsKey(str))
                {
                    checkBoxesValues.put(str, (Boolean)acc.get(str));
                }
            }
        }
        return checkBoxesValues;
    }
    
    
    
    public static Account getUpdatedAccount(List<Account> accsCheck, 
                                            Map<String, Boolean> checkBoxesValues, 
                                            Map<String, String> remainingFields, 
                                            Map<String, Date> Dates , 
                                            Map<String, Decimal> Decimals , 
                                            Map<String,DateTime> DateTimes)
    {
        Account accountToKeep;
        // Check if Any Account has a goExploreId
        for (Account acc : accsCheck) 
        {
            // First Priority is to keep the Account with GoExploreID
            
            if (acc.Account_To_Keep__c!=false && accountToKeep == Null)
            {
                accountToKeep= acc; 
            }
            
        }
        if (accountToKeep == null)
        {
            //newest Acc
            accountToKeep = accsCheck[0];                
        }
        
        for (string str : checkBoxesValues.keyset())
        {
            if ((Boolean)accountToKeep.get(str) == FALSE && checkBoxesValues.containsKey(str))
            {
                accountToKeep.put(str, checkBoxesValues.get(str));
            }
        }
        for (string str : remainingFields.keyset())
        {
            if(str =='PersonMailingCity'  || 
               str =='PersonMailingState' || 
               str =='PersonMailingPostalCode' || 
               str =='PersonMailingStreet' ||
               str =='PersonMailingCountry' )
            {
                accountToKeep.put('PersonMailingCity', remainingFields.get('PersonMailingCity'));
                accountToKeep.put('PersonMailingState', remainingFields.get('PersonMailingState'));
                accountToKeep.put('PersonMailingPostalCode', remainingFields.get('PersonMailingPostalCode'));
                accountToKeep.put('PersonMailingStreet', remainingFields.get('PersonMailingStreet'));
                accountToKeep.put('PersonMailingCountry', remainingFields.get('PersonMailingCountry'));
                
            }
            else if ((String)accountToKeep.get(str) == NULL && remainingFields.containsKey(str))
            {
                accountToKeep.put(str, remainingFields.get(str));
            } 
            
        }
        
        
        for (string str : Dates.keyset())
        {
            if ((Date)accountToKeep.get(str) == NULL && Dates.containsKey(str))
            {
                accountToKeep.put(str, Dates.get(str));
            }
        }
        
        
        
        
        for (string str : Decimals.keyset())
        {
            if ((Decimal)accountToKeep.get(str) == NULL && Decimals.containsKey(str))
            {
                accountToKeep.put(str, Decimals.get(str));
            }
        }
        
        
        
        for (string str : DateTimes.keyset())
        {
            if ((DateTime)accountToKeep.get(str) == NULL && DateTimes.containsKey(str))
            {
                accountToKeep.put(str, DateTimes.get(str));
            }
        }
        
        
        return accountToKeep;
    }
    
    public static List<Task> getAccountRelatedTasks()
    {
        List<Task> accountRelatedTasks = new List <Task>();
        for (Account acc : accs) {
            for(Task tsk : acc.Tasks)
            {
                
                accountRelatedTasks.add(tsk);
                
            }
            
            
        }
        return accountRelatedTasks;
    }
    public static List<Task> getcontactRelatedTasks(){
        List<Task> ContactRelatedTasks = new List<Task>();
        for (Account acc : accs){
           // System.debug(currContactMap.get(acc.PersonContactID));
            
            if (currContactMap.get(acc.PersonContactID).tasks != null)
            {
                for (Task tsk : currContactMap.get(acc.PersonContactID).tasks){
                    
                    ContactRelatedTasks.add(tsk);
                    
                }
            }
            
        }
        
        return ContactRelatedTasks;
    }
    public static List<Task> getTasksToUpdate(List <Task> accountRelatedTasks, Account accountToKeep , List <Task> contactRelatedTasks)
    {
       // System.debug('Account Related : '+accountRelatedTasks.size() +' Contact related : ' +contactRelatedTasks.size());
        Map<id,Task> tasksToUpdate = new Map <id,Task>();   
        
        for (Task tsk : accountRelatedTasks)
        {
            tsk.whatId = accountToKeep.Id;
            tasksToUpdate.put(tsk.id,tsk);
        }
        
        for (Task tsk : contactRelatedTasks)
        {
            if (tasksToUpdate.get(tsk.id)==null)
            {
                tsk.whoId=AccountTokeep.PersonContactId;
                
                taskstoUpdate.put(tsk.id,tsk);
            }
            else {
                tasksToUpdate.get(tsk.id).WhoId=accountToKeep.PersonContactId;
            }
            
        }
        
        //System.debug(taskstoupdate.values());
        return tasksToUpdate.values();
    }
    public static void updateTasks(List<Task> tasksToUpdate)
    {
        if(!tasksToUpdate.isEmpty())
        {
           // System.debug('These are tasks which we are updating '+tasksToUpdate);
            
            // DML statement
            Database.SaveResult[] srList = Database.update(tasksToUpdate, false);
            
            // Iterate through each returned result
            for (Database.SaveResult sr : srList) {
                if (sr.isSuccess()) {
                    // Operation was successful, so get the ID of the record that was processed
                   // System.debug('Successfully updated Task. Task ID: ' + sr.getId());
                }
                else {
                    // Operation failed, so get all errors                
                    for(Database.Error err : sr.getErrors()) {
                       // System.debug('The following error has occurred.');                    
                       // System.debug(err.getStatusCode() + ': ' + err.getMessage());
                       // System.debug('Task fields that affected this error: ' + err.getFields());
                    }
                }
            }
        }
    }
    
    public static List<Opportunity> getOpportunitiesToUpdate( Account accountToKeep)
    {
        List<Opportunity> opportunitiesToUpdate = new List<Opportunity>();
        
        for (Account acc : accs)
        {
            if (acc.Opportunities.size()<1000)
                for(Opportunity opp :acc.Opportunities )
            {
                opp.AccountId = accountToKeep.id;
                
                opportunitiesToUpdate.add(opp);
            }
        }
        
       // System.debug('Account : '+accountToKeep.id+' No.ofOpportunities : '+opportunitiesToUpdate.size());
        return opportunitiesToUpdate;
    }
    public static void updateOpportunities(List<Opportunity> opportunitiesToUpdate)
    {
        if(!opportunitiesToUpdate.isEmpty())
        {
            //System.debug('These are Opportunities which we are updating '+opportunitiesToUpdate);
            
            // DML statement
            Database.SaveResult[] srList = Database.update(opportunitiesToUpdate, false);
            
            // Iterate through each returned result
            for (Database.SaveResult sr : srList) {
                if (sr.isSuccess()) {
                    // Operation was successful, so get the ID of the record that was processed
                   // System.debug('Successfully updated Opportunity. Opportunity ID: ' + sr.getId());
                }
                else {
                    // Operation failed, so get all errors                
                    for(Database.Error err : sr.getErrors()) {
                       // System.debug('The following error has occurred.');                    
                       // System.debug(err.getStatusCode() + ': ' + err.getMessage());
                      //  System.debug('Opportunity fields that affected this error: ' + err.getFields());
                    }
                }
            }
            
        }
    }
    
    public static List<Case> getAccountRelatedCases()
    {
        List<Case> accountRelatedCases = new List <Case>();
        for (Account acc : accs) {
            for(Case cs : acc.Cases)
            {
                accountRelatedCases.add(cs);
            }
        }
        
       // System.debug(accountRelatedCases.size());
        return accountRelatedCases;
    }
    
    
    public static List<Case> getContactRelatedCases(){
        List<Case> ContactRelatedCases = new List<Case>();
        for (Account acc : accs){
           // System.debug(currContactMap.get(acc.PersonContactID));
            if (currContactMap.get(acc.PersonContactID).Cases != null)
            {
                for (Case tsk : currContactMap.get(acc.PersonContactID).Cases){
                    
                    ContactRelatedCases.add(tsk);
                    
                }
            }
            
        }
        
        return ContactRelatedCases;
    }
    
    
    public static List<Case> getCasesToUpdate(List<Case> accountRelatedCases, List<Case> ContactRelatedCases ,Account accountToKeep )
    {
        //System.debug(accountRelatedCases.size() + ' : '+ContactRelatedCases.size());
        Map<id,Case> casesToUpdate = new Map<id,Case>();
        //List<Case> casesToUpdate = new List <case>();
        for (Case cs : accountRelatedCases)
        {
            cs.AccountId = accountToKeep.Id;
            cs.ContactId = accountToKeep.PersonContactId;
            
            for (Contact cntct : accountToKeep.Contacts)
            {
                cs.ContactId = cntct.id;
            }
            
            casesToUpdate.put(cs.id,cs);
        }
        for (Case cs : ContactRelatedCases){
            if (casesToUpdate.get(cs.id)==null)
            {
                cs.ContactId=accountToKeep.PersonContactId;
                cs.AccountId=accountToKeep.Id;
                casesToUpdate.put(cs.id,cs);
            }
            else
            {
                casesToUpdate.get(cs.id).ContactId=accountToKeep.PersonContactId;
                casesToUpdate.get(cs.id).AccountId=accountToKeep.Id;
            }
        }
        
        return casesToUpdate.values();
    }
    
    public static void updateCases(List<Case> casesToUpdate)
    {
        if(!casesToUpdate.isEmpty())
        {
         //   System.debug('These are Cases which we are updating '+casesToUpdate);
            
            // DML statement
            Database.SaveResult[] srList = Database.update(casesToUpdate, false);
            
            // Iterate through each returned result
            for (Database.SaveResult sr : srList) {
                if (sr.isSuccess()) {
                    // Operation was successful, so get the ID of the record that was processed
                   // System.debug('Successfully updated Case. Case ID: ' + sr.getId());
                }
                else {
                    // Operation failed, so get all errors                
                    for(Database.Error err : sr.getErrors()) {
                       // System.debug('The following error has occurred.');                    
                       // System.debug(err.getStatusCode() + ': ' + err.getMessage());
                       // System.debug('Case fields that affected this error: ' + err.getFields());
                    }
                }
            }
        }
    }
    
    public static List<Lead> getLeadsReffered( Account accountToKeep)
    {
        List<Lead> leadsReffered = new List<Lead>();
        
        for (Account acc : accs)
        {
            for(Lead ld : acc.Leads_Referred__r)
            {
                ld.Referred_By__c = accountToKeep.id;
                leadsReffered.add(ld);
            }
        }
        
        return leadsReffered;
    }
    
    public static void updateLeadsReffered(List<Lead> leadsReffered)
    {
        if(!leadsReffered.isEmpty())
        {
           // System.debug('These are Leads Reffered which we are updating '+leadsReffered);
            
            // DML statement
            Database.SaveResult[] srList = Database.update(leadsReffered, false);
            
            // Iterate through each returned result
            for (Database.SaveResult sr : srList) {
                if (sr.isSuccess()) {
                    // Operation was successful, so get the ID of the record that was processed
                   // System.debug('Successfully updated Lead. Lead ID: ' + sr.getId());
                }
                else {
                    // Operation failed, so get all errors                
                    for(Database.Error err : sr.getErrors()) {
                      //  System.debug('The following error has occurred.');                    
                       // System.debug(err.getStatusCode() + ': ' + err.getMessage());
                       // System.debug('Lead fields that affected this error: ' + err.getFields());
                    }
                }
            }
        }
        
    }
    
    public static List<Opportunity> getOpportunitiesReferred(Account accountToKeep)
    {
        List<Opportunity> opportunitiesReferred = new List<Opportunity>();
        
        for (Account acc : accs)
        {
            
            for(Opportunity opp : acc.Opportunities)
            {
                opp.Referred_By__c = accountToKeep.id;
                opportunitiesReferred.add(opp);
            }
        }
        
        return opportunitiesReferred;
    }
    
    public static void updateOpportunitiesReferred(List<Opportunity> opportunitiesReferred)
    {
        if(!opportunitiesReferred.isEmpty())
        {
           // System.debug('These are Opportunities Referred which we are updating '+opportunitiesReferred);
            
            // DML statement
            Database.SaveResult[] srList = Database.update(opportunitiesReferred, false);
            
            // Iterate through each returned result
            for (Database.SaveResult sr : srList) {
                if (sr.isSuccess()) {
                    // Operation was successful, so get the ID of the record that was processed
                  //  System.debug('Successfully updated Opportunity. Opportunity ID: ' + sr.getId());
                }
                else {
                    // Operation failed, so get all errors                
                    for(Database.Error err : sr.getErrors()) {
                      //  System.debug('The following error has occurred.');                    
                      //  System.debug(err.getStatusCode() + ': ' + err.getMessage());
                       // System.debug('Opportunity fields that affected this error: ' + err.getFields());
                    }
                }
            }
        }
        
    }
    
    public static List<Note> getOldNotes(Set<ID> accountIds)
    {
        List<Note> oldNotes =  new List<Note>();
        
        for(Note nt : [select Id, title, ParentId, body from Note where ParentID IN : accountIds])
        {
            oldNotes.add(nt);
        }
        return oldNotes;
    }
    
    public static List<Note> getNewNotes(List<Note> oldNotes, Account accountToKeep)
    {
        List<Note> newNotes =  new List<Note>();
        for (Note nt : oldNotes)
        {
            Note newNote = new Note(title = nt.title, body = nt.body);
            newNote.ParentId = accountToKeep.id;
            newNotes.add(newNote);
        }
        return newNotes;
    }
    public static void createNewNotes(List<Note> newNotes)
    {
        if(!newNotes.isEmpty())
        {
           // System.debug('These are Notes which we are Creating '+newNotes);
            
            // DML statement
            Database.SaveResult[] srList = Database.insert(newNotes, false);
            
            // Iterate through each returned result
            for (Database.SaveResult sr : srList) {
                if (sr.isSuccess()) {
                    // Operation was successful, so get the ID of the record that was processed
                   // System.debug('Successfully created Note. Note ID: ' + sr.getId());
                }
                else {
                    // Operation failed, so get all errors                
                    for(Database.Error err : sr.getErrors()) {
                       // System.debug('The following error has occurred.');                    
                        //System.debug(err.getStatusCode() + ': ' + err.getMessage());
                       // System.debug('Note fields that affected this error: ' + err.getFields());
                    }
                }
            }
        }
    }
    public static void deleteOldNotes(List<Note> oldNotes)
    {
        if(!oldNotes.isEmpty())
        {
           // System.debug('These are Old Notes which we are Deleting '+oldNotes);
            
            // DML statement
            Database.DeleteResult[] drList = Database.delete(oldNotes, false);
            
            // Iterate through each returned result
            for (Database.DeleteResult dr : drList) {
                if (dr.isSuccess()) {
                    // Operation was successful, so get the ID of the record that was processed
                    //System.debug('Successfully deleted Note. Note ID: ' + dr.getId());
                }
                else {
                    // Operation failed, so get all errors                
                    for(Database.Error err : dr.getErrors()) {
                       // System.debug('The following error has occurred.');                    
                       // System.debug(err.getStatusCode() + ': ' + err.getMessage());
                       // System.debug('Note fields that affected this error: ' + err.getFields());
                    }
                }
            }
        }
    }
    
    public static List<Attachment> getOldAttachments(Set<ID> accountIds)
    {
        List<Attachment> oldAttachments = new List<Attachment>();
        for (Attachment at : [select ID, ParentID, body, Name from attachment where ParentID IN : accountIds])
        {
            oldAttachments.add(at);
        }
        return oldAttachments;
    }
    
    public static List<Attachment> getNewAttachments(List<Attachment> oldAttachments, Account accountToKeep)
    {
        List<Attachment> newAttachments = new List<Attachment>();
        for (Attachment at : oldAttachments)
        {
            Attachment newAttachment = new Attachment(Name = at.name, body = at.body);
            newAttachment.ParentId = accountToKeep.id;
            newAttachments.add(newAttachment);
        }
        return newAttachments;
    }
    
    public static void createNewAttachments(List<Attachment> newAttachments)
    {
        if(!newAttachments.isEmpty())
        {
            //System.debug('These are Attachments which we are Creating '+newAttachments);
            
            // DML statement
            Database.SaveResult[] srList = Database.insert(newAttachments, false);
            
            // Iterate through each returned result
            for (Database.SaveResult sr : srList) {
                if (sr.isSuccess()) {
                    // Operation was successful, so get the ID of the record that was processed
                    //System.debug('Successfully created Attachment. Attachment ID: ' + sr.getId());
                }
                else {
                    // Operation failed, so get all errors                
                    for(Database.Error err : sr.getErrors()) {
                        //System.debug('The following error has occurred.');                    
                        //System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        //System.debug('Attachment fields that affected this error: ' + err.getFields());
                    }
                }
            }
        }
    }
    public static void deleteOldAttachments(List<Attachment> oldAttachments)
    {
        if(!oldAttachments.isEmpty())
        {
            //System.debug('These are Attachments which we are Deleting '+oldAttachments);
            
            // DML statement
            Database.DeleteResult[] drList = Database.delete(oldAttachments, false);
            
            // Iterate through each returned result
            for (Database.DeleteResult dr : drList) {
                if (dr.isSuccess()) {
                    // Operation was successful, so get the ID of the record that was processed
                    //System.debug('Successfully Deleted Attachment. Attachment ID: ' + dr.getId());
                }
                else {
                    // Operation failed, so get all errors                
                    for(Database.Error err : dr.getErrors()) {
                        //System.debug('The following error has occurred.');                    
                        //System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        //System.debug('Attachment fields that affected this error: ' + err.getFields());
                    }
                }
            }
        }
    }
    
    public static List<Survey_Feedback__c> getSurveyFeedbackList( Account accountToKeep)
    {
        
        List<Survey_Feedback__c> surveyFeedbackList = new List<Survey_Feedback__c>();
        for(Account acc : accs)
        {
            for(Survey_Feedback__c sf : acc.Survey_Feedbacks__r)
            {
                sf.Account__c = accountToKeep.id;
                surveyFeedbackList.add(sf);
            }
        }
        
        return surveyFeedbackList;
    }
    public static void updateSurveyFeedbacks(List<Survey_Feedback__c> surveyFeedbackList)
    {
        if(!surveyFeedbackList.isEmpty())
        {
            //System.debug('These are Survey Feedbacks which we are updating '+surveyFeedbackList);
            
            // DML statement
            Database.SaveResult[] srList = Database.update(surveyFeedbackList, false);
            
            // Iterate through each returned result
            for (Database.SaveResult sr : srList) {
                if (sr.isSuccess()) {
                    // Operation was successful, so get the ID of the record that was processed
                    //System.debug('Successfully updated Survey Feedback. Survey Feedback ID: ' + sr.getId());
                }
                else {
                    // Operation failed, so get all errors                
                    for(Database.Error err : sr.getErrors()) {
                        //System.debug('The following error has occurred.');                    
                        //System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        //System.debug('Survey Feedback fields that affected this error: ' + err.getFields());
                    }
                }
            }
        }
        
    }
    
    public static List<talkdesk__Talkdesk_Activity__c> gettaskdeskactvities( Account accounttokeep){
        
        List<talkdesk__Talkdesk_Activity__c> surveyFeedbackList = new List<talkdesk__Talkdesk_Activity__c>();
        for (Account acc : accs)
        {
            for(talkdesk__Talkdesk_Activity__c sf :acc.talkdesk__Talkdesk_Activities__r )
            {
                sf.talkdesk__Account__c = accountToKeep.id;
                surveyFeedbackList.add(sf);
            }
        }
        
        return surveyFeedbackList;
        
        
    }
    
    public static void updatetalkkdesks(List<talkdesk__Talkdesk_Activity__c> surveyFeedbackList)
    {
        if(!surveyFeedbackList.isEmpty())
        {
            //System.debug('These are Talk desks which we are updating '+surveyFeedbackList);
            
            // DML statement
            Database.SaveResult[] srList = Database.update(surveyFeedbackList, false);
            
            // Iterate through each returned result
            for (Database.SaveResult sr : srList) {
                if (sr.isSuccess()) {
                    // Operation was successful, so get the ID of the record that was processed
                    //System.debug('Successfully updated Talk Desk. Talk Desk ID: ' + sr.getId());
                }
                else {
                    // Operation failed, so get all errors                
                    for(Database.Error err : sr.getErrors()) {
                        //System.debug('The following error has occurred.');                    
                        //System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        //System.debug('Talk Desk fields that affected this error: ' + err.getFields());
                    }
                }
            }
        }
        
    }
    
    public static  List<LiveChatTranscript> getlivechattranscripts(Account accounttokeep){
        
        List<LiveChatTranscript> surveyFeedbackList = new List<LiveChatTranscript>();
        
        for (Account acc : accs)
        {
            for(LiveChatTranscript sf : acc.LiveChatTranscripts)
            {
                sf.AccountId = accountToKeep.id;
                surveyFeedbackList.add(sf);
            }
        }
        
        return surveyFeedbackList;
        
        
    }
    
    public static void updatealllivechattranscripts(List<LiveChatTranscript> surveyFeedbackList)
    {
        if(!surveyFeedbackList.isEmpty())
        {
            //System.debug('These are Live Chat Trans which we are updating '+surveyFeedbackList);
            
            // DML statement
            Database.SaveResult[] srList = Database.update(surveyFeedbackList, false);
            
            // Iterate through each returned result
            for (Database.SaveResult sr : srList) {
                if (sr.isSuccess()) {
                    // Operation was successful, so get the ID of the record that was processed
                    //System.debug('Successfully Live Chat Trans. Live Chat Trans: ' + sr.getId());
                }
                else {
                    // Operation failed, so get all errors                
                    for(Database.Error err : sr.getErrors()) {
                        //System.debug('The following error has occurred.');                    
                        //System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        //System.debug('Live Chat Trans fields that affected this error: ' + err.getFields());
                    }
                }
            }
        }
        
    }
    
    public static List<et4ae5__SendDefinition__c>getSendDefinations(Set<id>accids,Account accounttokeep)
    {
        List<et4ae5__SendDefinition__c> surveyFeedbackList = new List<et4ae5__SendDefinition__c>();
        for(et4ae5__SendDefinition__c sf : [Select id,et4ae5__Contact__r.AccountId , et4ae5__Contact__c from et4ae5__SendDefinition__c where et4ae5__Contact__r.AccountId IN : accids])
        {
            sf.et4ae5__Contact__c = accountToKeep.id;
            surveyFeedbackList.add(sf);
        }
        return surveyFeedbackList;
    }
    
    public static void updateallSendDefinations (List<et4ae5__SendDefinition__c> surveyFeedbackList)
    {
        if(!surveyFeedbackList.isEmpty())
        {
            //System.debug('These are Live Chat Trans which we are updating '+surveyFeedbackList);
            
            // DML statement
            Database.SaveResult[] srList = Database.update(surveyFeedbackList, false);
            
            // Iterate through each returned result
            for (Database.SaveResult sr : srList) {
                if (sr.isSuccess()) {
                    // Operation was successful, so get the ID of the record that was processed
                    //System.debug('Successfully Send Definations. Send Definations: ' + sr.getId());
                }
                else {
                    // Operation failed, so get all errors                
                    for(Database.Error err : sr.getErrors()) {
                        //System.debug('The following error has occurred.');                    
                        //System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        //System.debug('Send Definations fields that affected this error: ' + err.getFields());
                    }
                }
            }
        }
        
    }
    public static List<Award__c>getAwards(Account accounttokeep)
    {
        List<Award__c> awards = new List<Award__c>();
        for (Account acc : accs)
        {
            for (Award__c a : acc.Awards__r)
            {
                a.account__c=accounttokeep.id;
                awards.add(a);
            }
        }
        
        
        return awards;
        
    }
    public static List<Earning__c>getEarnings( Account accounttokeep)
    {
        List<Earning__c> awards = new List<Earning__c>();
        for (Account acc : accs)
        {
            for (Earning__c a : acc.Earnings__r)
            {
                a.account__c=accounttokeep.id;
                awards.add(a);
            }
            
        }
        
        return awards;
        
    }
    public static List<Invoice_Charge__c>getInvoiceCharges(Account accounttokeep)
    {
        List<Invoice_Charge__c> awards = new List<Invoice_Charge__c>();
        for (Account acc : accs)
        {
            for (Invoice_Charge__c a : acc.Invoice_Charges__r)
            {
                a.account__c=accounttokeep.id;
                awards.add(a);
            }
        }
        
        return awards;
        
    }
    
    
    public static void deleteAccounts(List<Account> accountsToDelete)
    {
        if(!accountsToDelete.isEmpty())
        {
            //System.debug('These are Accounts which we are Deleting '+accountsToDelete);
            
            // DML statement
            Database.DeleteResult[] drList = Database.delete(accountsToDelete);
            
            // Iterate through each returned result
            for (Database.DeleteResult dr : drList) {
                if (dr.isSuccess()) {
                    // Operation was successful, so get the ID of the record that was processed
                    //System.debug('Successfully Deleted Account. Account ID: ' + dr.getId());
                }
                else {
                    // Operation failed, so get all errors                
                    for(Database.Error err : dr.getErrors()) {
                        //System.debug('The following error has occurred.');                    
                        //System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        //System.debug('Account fields that affected this error: ' + err.getFields());
                    }
                }
            }
        }
    }
    
    
    
    public static List<et4ae5__IndividualEmailResult__c> getcontactRelatedIndividualEmailResults(){
        List<et4ae5__IndividualEmailResult__c> IERs = new List<et4ae5__IndividualEmailResult__c>();
        for (Account acc : accs){
            //System.debug(currContactMap.get(acc.PersonContactID));
            
            
            if (currContactMap.get(acc.PersonContactID).tasks != null)
            {
                for (et4ae5__IndividualEmailResult__c ier : currContactMap.get(acc.PersonContactID).et4ae5__IndividualEmailResults__r){
                    
                    IERs.add(ier);
                    
                }
                
            }
            
        }
        
        return IERs;
    }
    
    
    
    public static List<et4ae5__IndividualEmailResult__c> getIERsToUpdate(List<et4ae5__IndividualEmailResult__c> iers , Account accounttokeep){
        List<et4ae5__IndividualEmailResult__c>iersList = new List<et4ae5__IndividualEmailResult__c>();
        for (et4ae5__IndividualEmailResult__c ier : iers)
        {
            ier.et4ae5__Contact__c = accountToKeep.PersonContactId;
            iersList.add(ier);
        }
        
        return iersList;
    }
    
    
    public static List<Account> getAllAtOnce(Set<Id> accountids, String soql)
    {
        List<Account> accountstoreturn = new List<Account>();
        try {
            accountstoreturn = new List<sobject>(database.query(soql));
            
            for (Account acc : accountstoreturn){
                //System.debug(acc);
                for (Case c : acc.cases){
                    //System.debug(c);
                }
            }
            
            
        } catch (Exception e) {
            //System.debug('Exception in getAllAtOnce : '+e.getMessage() + e.getStackTraceString());
        }
        
        
        return accountstoreturn;
        
    }
    
    public static List<Contact> getAllContactsAtOnce(Set<Id> personContactIds){
        return [SELECT id ,accountid, (SELECT id from Tasks) , (SELECT id,name from et4ae5__IndividualEmailResults__r),(SELECT id from Cases) from Contact where id in :personContactIds]; 
    } 
    
    
    public static String getQuery(List<String> fields, String accountIds)
    {
        string soql = 'SELECT PersonContactID, Account_To_keep__c,' + string.join(fields, ', ')+', ';
        soql+= '(Select id, whatId, WhoId, subject from tasks '+System.Label.Dedupe_Other_Related_Objects_Limit+' ), '; 
        soql+= '(SELECT id from contacts '+System.Label.Dedupe_Other_Related_Objects_Limit+'), ';
        soql+= '(Select id, AccountId from Opportunities), ';
        soql+= '(Select id, AccountId from cases '+System.Label.Dedupe_Other_Related_Objects_Limit+'), ';
        soql+= '(Select id, Referred_By__c from Leads_Referred__r '+System.Label.Dedupe_Other_Related_Objects_Limit+'), ';
        soql+= '(Select id, Name from Survey_Feedbacks__r '+System.Label.Dedupe_Other_Related_Objects_Limit+'), ';
        soql+= '(Select id, talkdesk__Account__c from talkdesk__Talkdesk_Activities__r '+System.Label.Dedupe_Other_Related_Objects_Limit+'), ';
        soql+= '(Select id, AccountId from LiveChatTranscripts '+System.Label.Dedupe_Other_Related_Objects_Limit+'), ';
        soql+= '(Select id , Account__c from Awards__r '+System.Label.Dedupe_Other_Related_Objects_Limit+'), ';
        soql+= '(Select id , Account__c from Invoice_Charges__r '+System.Label.Dedupe_Other_Related_Objects_Limit+'), ';
        soql+= '(Select id , Account__c from Earnings__r '+System.Label.Dedupe_Other_Related_Objects_Limit+') ';
        
        soql+= 'FROM ACCOUNT ';
        soql+= 'WHERE id in : '+accountIds+' ';
        soql+= 'ORDER BY CreatedDate DESC'; 
        System.debug('soql query: ' +soql);
        return soql;
    }
    public static Map<String, List<String>> getFieldsMap()
    {
        Map<String, List<String>> fieldsMap = new Map <String, List<String>>();
        Map<String, Schema.SObjectType> SchemaMap = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> schemaFieldMap = SchemaMap.get('Account').getDescribe().fields.getMap(); 
        
        for (Schema.SObjectField sfield : schemaFieldMap.values()) {
            schema.describefieldresult dfield = sfield.getDescribe();
            if(dfield.isUpdateable() && String.valueOf(dfield.getname())!= 'Name')
            {
                if(fieldsMap.containsKey(String.valueOf(dfield.getType()) )) {
                    List<String> fieldsList = fieldsMap.get(String.valueOf(dfield.getType()));
                    
                    fieldsList.add(String.valueOf(dfield.getname()));
                    fieldsMap.put(String.valueOf(dfield.getType()), fieldsList);
                    
                } else {
                    fieldsMap.put(String.valueOf(dfield.getType()), new List<String> { String.valueOf(dfield.getname()) });
                }
            }
        } 
        return fieldsMap;
    }
    
    public static List<String> getFields(Map<String, List<String>> fieldsMap)
    {
        List<String> fieldsList = new List<String>();
        
        for (List<String> fields : fieldsMap.values()) {
            fieldsList.addAll(fields);
            
        } 
        return fieldsList;
    }
    
    
}