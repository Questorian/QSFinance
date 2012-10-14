

-- create a table for the expenses for use with SQLite

CREATE TABLE expenses
(
id INTEGER PRIMARY KEY,
site TEXT,
url TEXT,
date_setup datetime
)
;

INSERT INTO expenses 
VALUES (NULL, 'Questor Systems', 'http://www.QuestorSystems.com', 'xy');

INSERT INTO expenses 
VALUES (NULL, 'PlanetBala', 'http://www.PlanetBala.com');

INSERT INTO expenses 
VALUES (NULL, 'Lavinia', 'http://www.lavinia.co.uk');

INSERT INTO expenses 
VALUES (NULL, 'BalaFund', 'http://www.balafund.com');

