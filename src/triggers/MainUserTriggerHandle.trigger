trigger MainUserTriggerHandle on User (before insert, before update, before delete, after insert, after update, after delete) 
{
    TriggerDispatcher.TriggerHandler(New TriggerDispatcher.TriggerParameters(trigger.isBefore, trigger.isAfter, trigger.isInsert,
                                                                             trigger.isUpdate, trigger.isDelete, trigger.isExecuting,
                                                                             trigger.old, trigger.new, trigger.oldMap, trigger.newMap,'User'));
}