public with sharing class ContactTriggerHandler {

	// Control Contact id already proccessed 
	public static Set<ID> contactToProcess = new Set<id>();

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
				SyncContactToUser(tp);
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

	// Synchonize Contact to User
	private void SyncContactToUser(TriggerDispatcher.TriggerParameters tp)
	{
		Map<ID, Contact> ctMap = (Map<ID, Contact>) tp.newMap; 
		list<ID> userIDs = new List<ID>();
		
		for (Contact ct: ctMap.values())
		{
			if (ct.User__c !=null)
			{
				userIDs.add(ct.User__c);
			}			
		}

		Map<ID, User> mapUser = new Map<ID, User>([SELECT ID, Phone, MobilePhone, Fax FROM User Where id in: userIDs]);

		for (Contact ct: ctMap.values())
		{
			User u = mapUser.get(ct.User__c);
			if (u.phone != ct.phone || u.MobilePhone != ct.MobilePhone || u.Fax != ct.Fax)
			{	
				if (contactToProcess.contains(ct.Id)) continue;
				u.phone = ct.phone;
				u.MobilePhone = ct.MobilePhone;
				u.Fax = ct.Fax;

				contactToProcess.add(ct.Id);
				TriggerDispatcher.sObjectToUpdate.put(u.ID, u);
			}
		}
	}
}