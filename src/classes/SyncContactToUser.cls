public with sharing class SyncContactToUser implements TriggerDispatcher.ITriggerEntry
{	
	//detect is process
	public void inProgressEntry(TriggerDispatcher.TriggerParameters tp)
	{
		System.assert(tp.triggerObject == 'Contact');
	}

	public void mainEntry(TriggerDispatcher.TriggerParameters tp)
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
				u.phone = ct.phone;
				u.MobilePhone = ct.MobilePhone;
				u.Fax = ct.Fax;

				TriggerDispatcher.sObjectToUpdate.put(u.ID, u);
			}
		}
	}
}