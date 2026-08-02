/**
 * BaseTriggerHandler provides trigger event handler methods
 * that can be overridden by subclasses.
 */
public virtual with sharing class BaseTriggerHandler {

    /**
     * Executes logic before a record is inserted.
     */
    public virtual void beforeInsert() {
        return;
    }

    /**
     * Executes logic before a record is updated.
     */
    public virtual void beforeUpdate() {
        return;
    }

    /**
     * Executes logic before a record is deleted.
     */
    public virtual void beforeDelete() {
        return;
    }

    /**
     * Executes logic after a record is inserted.
     */
    public virtual void afterInsert() {
        return;
    }

    /**
     * Executes logic after a record is updated.
     */
    public virtual void afterUpdate() {
        return;
    }

    /**
     * Executes logic after a record is deleted.
     */
    public virtual void afterDelete() {
        return;
    }

}

