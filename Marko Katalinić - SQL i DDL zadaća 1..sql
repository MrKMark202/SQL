CREATE DATABASE trgovina;
USE trgovina;

CREATE TABLE kupac (
	id INTEGER NOT NULL,
	ime VARCHAR(10) NOT NULL,
	prezime VARCHAR(15) NOT NULL
);

CREATE TABLE zaposlenik (
	id INTEGER NOT NULL,
	ime VARCHAR(10) NOT NULL,
	prezime VARCHAR(15) NOT NULL,
	oib CHAR(10) NOT NULL,
	datum_zaposlenja DATETIME NOT NULL,
    -- 2. Zadatak DDL
    CHECK (ime != prezime)
    -- 
);

CREATE TABLE artikl (
	id INTEGER NOT NULL,
    -- 1.Zadatak DDL
	naziv VARCHAR(20) UNIQUE NOT NULL,
    -- 
	cijena NUMERIC(10,2) NOT NULL
);

CREATE TABLE racun (
	id INTEGER NOT NULL,
	id_zaposlenik INTEGER NOT NULL,
	id_kupac INTEGER NOT NULL,
	broj VARCHAR(100) NOT NULL,
	datum_izdavanja DATETIME NOT NULL
);

CREATE TABLE stavka_racun (
	id INTEGER NOT NULL,
	id_racun INTEGER,
	id_artikl INTEGER NOT NULL,
	kolicina INTEGER NOT NULL,
    -- 3. Zadatak
    FOREIGN KEY (id_racun) REFERENCES racun (id)
    ON DELETE set NULL,
    -- DDL
    FOREIGN KEY (id_artikl) REFERENCES artikl (id)
);


/* == Unos podataka == */
INSERT INTO kupac VALUES (1, 'Lea', 'Fabris'),
                         (2, 'David', 'Sirotić'),
                         (3, 'Tea', 'Bibić');

INSERT INTO zaposlenik VALUES 
	(11, 'Marko', 'Marić', '123451', STR_TO_DATE('01.10.2020.', '%d.%m.%Y.')),
	(12, 'Toni', 'Milovan', '123452', STR_TO_DATE('02.10.2020.', '%d.%m.%Y.')),
	(13, 'Tea', 'Marić', '123453', STR_TO_DATE('02.10.2020.', '%d.%m.%Y.'));

INSERT INTO artikl VALUES (21, 'Puding', 5.99),
                          (22, 'Milka čokolada', 30.00),
                          (23, 'Čips', 9);

INSERT INTO racun VALUES 
	(31, 11, 1, '00001', STR_TO_DATE('05.10.2020.', '%d.%m.%Y.')),
	(32, 12, 2, '00002', STR_TO_DATE('06.10.2020.', '%d.%m.%Y.')),
	(33, 12, 1, '00003', STR_TO_DATE('06.10.2020.', '%d.%m.%Y.'));

INSERT INTO stavka_racun VALUES (41, 31, 21, 2),
                                (42, 31, 22, 5),
                                (43, 32, 22, 1),
                                (44, 32, 21, 1);
                                

-- 4. Napravi pogled (View) koji prikazuje sve kupce koji imaju ime jednako prezimenu, pritom je omogućen unos kupaca kroz pogled samo ukoliko je navedeni uvjet zadovoljen

CREATE VIEW kupci_imeprezime AS
SELECT ime, prezime
FROM kupac
WHERE ime LIKE prezime
WITH CHECK OPTION;


-- 5. Napravi pogled (View) koji prikazuje sve račune i njihov ukupan iznos. Nakon toga napiši upit koji koristi prethodno napravljeni pogled kako bi se pronašao račun sa najvećim iznosom

CREATE VIEW racun_SUM_iznos AS
SELECT r.id, SUM(kolicina*cijena) AS ukupna_cijena_racuna
FROM artikl a, racun r, stavka_racun sr
WHERE a.id = sr.id_artikl AND r.id = sr.id_racun
GROUP BY id_racun;

SELECT *
FROM racun_SUM_iznos
ORDER BY ukupna_cijena_racuna DESC
LIMIT 1;


-- 1. Prikaži sve zaposlenike čije ime sadrži barem 4 slova

SELECT ime
FROM zaposlenik
WHERE LENGTH(ime) > 3;

-- 2. Prikaži sva imena zaposlenika koja se pojavljuju kao imena kupaca

SELECT z.ime, k.ime
FROM zaposlenik z, kupac k
WHERE z.ime = k.ime;

-- 3. Ažuriraj artikle tako da im se cijena spusti za 10%

UPDATE artikl
SET cijena = cijena/0.10;

-- 4. Prikaži artikle koji imaju iznadprosječnu cijenu
SELECT cijena
FROM artikl
WHERE cijena >
(SELECT AVG(cijena) AS prosjecna_cijena
FROM artikl);

-- Prikaži sve artikle i račune na kojima su izdani, pritom prikazati i artikle koji nisu niti jednom kupljeni (niti jednom dodani na stavke računa)

SELECT *
FROM artikl a
LEFT OUTER JOIN stavka_racun r ON r.id_artikl=a.id;

-- Prikaži najučestalijeg kupca (kupac koji ima najviše računa)

SELECT *, COUNT(*) Najucestaliji 
FROM kupac 
INNER JOIN racun 
ON racun.id_kupac=kupac.id
GROUP BY kupac.id
HAVING count(*)>1;
