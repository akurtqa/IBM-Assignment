trigger UserTrigger on User (after insert, after update) {
    if (trigger.isAfter) {
        if (trigger.isInsert) {
            UserTriggerHandler.afterInsert(trigger.new, trigger.newMap);
        } else if (trigger.isUpdate) {
            UserTriggerHandler.afterUpdate(trigger.new, trigger.newMap, trigger.old, trigger.oldMap);
        }
    }
}