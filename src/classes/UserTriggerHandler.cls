public with sharing class UserTriggerHandler implements TriggerDispatcher.ItriggerEntry{

	// Control user id already proccessed 
	public static Set<ID> userToProcess = new Set<id>();


	public void inProgressEntry(TriggerDispatcher.TriggerParameters tp)
	{
		System.assert(tp.triggerObject == 'User');
	}

	public void mainEntry(TriggerDispatcher.TriggerParameters tp)
	{
		if (tp.isAfter && tp.isUpate)
		{
			SyncUserToContact(tp);
		}

	}

	//synchronize User to Contact
	private void SyncUserToContact(TriggerDispatcher.TriggerParameters tp)
	{
		Map<ID, User> uMap = (Map<ID, User>) tp.newMap; 
		list<ID> userIDs = new List<ID>();
		
		for (User u: uMap.values())
		{
			userIDs.add(u.Id);
		}

		Map<ID, Contact> mapContact = new Map<ID, Contact>([SELECT ID, Phone, MobilePhone, Fax FROM Contact Where User__c in: userIDs]);

		for (User u: uMap.values())
		{
			Contact ct = mapContact.get(u.Id);
			if (ct.phone != u.phone || ct.MobilePhone != u.MobilePhone || ct.Fax != u.Fax)
			{
				if (userToProcess.contains(u.Id)) continue;
				ct.phone = u.phone;
				ct.MobilePhone = u.MobilePhone;
				ct.Fax = u.Fax;

				userToProcess.add(u.Id);
				TriggerDispatcher.sObjectToUpdate.put(ct.ID, ct);
			}
		}
	}
}