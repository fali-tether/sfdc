public class UpsertDetailsRequest {
        @invocableVariable(label='External ID Field for these records to upsert against' required=true)
        public String upsertFieldName;
        
        @invocableVariable(label='What Batch Size Would you like to suggest as the default' required=true)
        public Integer batchSize;
        
        @invocableVariable(label='Records to be Upserted' required=true)
        public List<SObject> records;
}