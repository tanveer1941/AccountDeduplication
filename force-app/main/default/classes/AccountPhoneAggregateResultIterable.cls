global class AccountPhoneAggregateResultIterable implements Iterable<AggregateResult> {
   global Iterator<AggregateResult> Iterator(){
      return new AccountPhoneAggregateResultIterator();
   }
}