public with sharing class AccountTriggerHandler implements TriggerDispatcher.ItriggerEntry
{
	public static Set<Id> accountToProcess = new Set<Id>();

	//detect is process
	public void inProgressEntry(TriggerDispatcher.TriggerParameters tp)
	{
		System.assert(tp.triggerObject == 'Contact');
	}

	public void mainEntry(TriggerDispatcher.TriggerParameters tp)
	{
		// Is After	
		if (tp.isAfter)
		{
			// Is update	
			if (tp.isUpate)
			{
				
			}
			// Is Insert	
			if (tp.isInsert)
			{
				
			}
			// Is Delete	
			if (tp.isDelete)
			{
				
			}
		}
		// Is Before
		else 
		{
		    // Is update	
			if (tp.isUpate)
			{
				
			}
			// Is Insert	
			if (tp.isInsert)
			{
				
			}
			// Is Delete	
			if (tp.isDelete)
			{
				
			}
		}
		
	}

	public void accountRatingChange(TriggerDispatcher.TriggerParameters tp)
	{

	}
}