INSERT INTO `addon_account` (name, label, shared) VALUES
	('society_animal','Animalerie',1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES
	('society_animal','Animalerie',1)
;

INSERT INTO `jobs` (name, label) VALUES
	('animal','Animalerie')
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
	('animal',0,'recruit','Recrue',10,'{}','{}'),
	('animal',1,'novice','Vendeur',25,'{}','{}'),
	('animal',2,'experienced','Experimente',40,'{}','{}'),
	('animal',3,'boss','Patron',0,'{}','{}')
;

ALTER TABLE `users` ADD COLUMN `pet` VARCHAR(50) NOT NULL;