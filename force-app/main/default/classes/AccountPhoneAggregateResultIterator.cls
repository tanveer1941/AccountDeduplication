global class AccountPhoneAggregateResultIterator implements Iterator<AggregateResult> {
    AggregateResult [] results {get;set;}
    // tracks which result item is returned
    Integer index {get; set;}
    Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    Limit_List_For_Batches__c llfb = Limit_List_For_Batches__c.getValues('Limit Values');
    String LimitforThisBatch = System.label.Dedupe_Limit;
    
    global AccountPhoneAggregateResultIterator() {
        index = 0;
        // Fire query here to load the results
        /*if (llfb.Limit_For_Account_Duplication__c == null)
        {
            llfb.Limit_For_Account_Duplication__c = ' '; 
        }*/
        //String query = 'Select count (id), PersonEmail, PersonMobilePhone from account where RecordTypeId= \''+personAccountRecordTypeId+'\' ';// AND LastName =\'test4\'  //AND PersonEmail =\'dedeup@email1.com\'
       String query =System.Label.Dedupe_FifthDiamond_Where_Clause;//+' GROUP BY PersonEmail, PersonMobilePhone Having Count(id)>1 ';
	   query +=' Limit '+LimitforThisBatch+ '';
        results = Database.query(query); 
                   
    } 
    
    global boolean hasNext(){ 
        return results != null && !results.isEmpty() && index < results.size(); 
    }    
    
    global AggregateResult next(){        
        return results[index++];            
    }       
}