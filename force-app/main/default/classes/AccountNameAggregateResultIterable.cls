global class AccountNameAggregateResultIterable implements Iterable<AggregateResult> {
    global Iterator<AggregateResult> Iterator(){
       return new AccountNameAggregateResultIterator();
    }
 }