global class AccountNameMobileAggregateResultIterable implements Iterable<AggregateResult> {
    global Iterator<AggregateResult> Iterator(){
       return new AccountNameMobileAggregateResultIterator();
    }
 }