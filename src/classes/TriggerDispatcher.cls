public with sharing class TriggerDispatcher 
{
	private static final string SACCOUNT 	 = 'Account';
	private static final string SCONTACT 	 = 'Contact';
	private static final string SUSER	 	 = 'User';
	private static final string SLEAD 	 	 = 'Lead';
	private static final string SOPPORTUNITY = 'Opportunity';

	public static ITriggerEntry activeInstance = null;
	public static Map<ID, SObject> sObjectToUpdate = new  Map<ID, SObject>();


	public interface ITriggerEntry 
	{
		void mainEntry(TriggerParameters tp);
		void inProgressEntry(TriggerParameters tp);
	}

	public class TriggerParameters
	{
		public string triggerObject {get; private set;}
		public boolean isInsert {get; private set;}
		public boolean isUpate {get;private set;}
		public boolean isDelete {get;private set;}
		public boolean isBefore {get;private set;}
		public boolean isAfter {get;private set;}
		public boolean isExecuting {get;private set;}

		public List<Object> oldList {get; private set;}
		public List<Object> newList {get; set;}
		public Map<ID, SObject> oldMap  {get;private set;}
		public Map<ID, SObject> newMap {get; set;}

		public TriggerParameters(boolean iB, boolean iA, boolean iI, boolean iU, boolean iD,  
								 boolean iE, List<Object> oL, List<Object> nL, Map<ID, SObject> oM, 
								 Map<ID, SObject> nM, String sObj)
		{
			this.isInsert = iI;
			this.isUpate  = iU;
			this.isDelete = iD; 
			this.isBefore = iB;
			this.isAfter = iA;
			this.isExecuting = iE;
			this.oldList = oL;
			this.newList = nL;
			this.oldMap = oM;
			this.newMap = nM;
			this.triggerObject = sObj;
		}	

		private String getObjectType(SObject so)
		{
			string rsVal = '';

			if (so instanceof Account) rsVal = SACCOUNT;
			else if (so instanceof Contact) rsVal = SCONTACT;
			else if (so instanceof User) rsVal = SUSER;
			else if (so instanceof Lead) rsVal = SLEAD;
			else if (so instanceof Opportunity) rsVal = SOPPORTUNITY;
			
			return rsVal;
		}
	}

	//Central dispatch entry
	public static void TriggerHandler(TriggerParameters tp)
	{
		if (activeInstance == null)
		{
			processWork(tp);
		}
		else 
		{
			activeInstance.inProgressEntry(tp);
		}
	}

	// Oder of execution is controlled
	private static void processWork(TriggerParameters tp)
	{
		if (tp.triggerObject == SCONTACT)
		{
			execute(new SyncContactToUser(), tp);
		}
		else if (tp.triggerObject == SUSER)
		{
			execute(new UserTriggerHandler(),tp);
		}

		if (sObjectToUpdate.size() > 0)
		{
			update sObjectToUpdate.values();
		}
	}

	private static void execute(ITriggerEntry ite, Triggerparameters tp)
	{
		activeInstance =  ite;
		activeInstance.mainEntry(tp);
	}

}