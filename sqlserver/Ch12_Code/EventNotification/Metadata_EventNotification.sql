---For server level event notification metadata
SELECT *
FROM sys.server_event_notifications

---For database level event notification metadata.
---Run it in the database you are interested in.
SELECT *
FROM sys.event_notifications

---To see list of all the events you can create
---notification on.
SELECT *
FROM sys.event_notification_event_types