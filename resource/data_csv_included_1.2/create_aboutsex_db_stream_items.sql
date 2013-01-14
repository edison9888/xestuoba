CREATE TABLE stream_items(itemID INTEGER PRIMARY KEY AUTOINCREMENT, itemName TEXT, location TEXT, isRead BOOLEAN, isMarked BOOLEAN, releasedTime INTEGER, markedTime INTEGER, iconURL TEXT, summary TEXT, numVisits INTEGER, tag INTEGER);
CREATE TABLE stream_items_import(itemName TEXT, location TEXT, isRead BOOLEAN, isMarked BOOLEAN, releasedTime INTEGER, markedTime INTEGER, iconURL TEXT, summary TEXT, numVisits INTEGER, tag INTEGER);
.import ./stream_items.csv stream_items_import
INSERT INTO stream_items(itemName, location, isRead, isMarked, releasedTime, markedTime, iconURL, summary, numVisits, tag) SELECT * FROM stream_items_import;
DROP TABLE stream_items_import;
UPDATE stream_items SET releasedTime=1347705135;