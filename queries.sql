/*
Найти всех преступников с одинаковыми кличками, но владеющими разными языками.
*/ 
 CREATE VIEW "Преступники" AS
SELECT  P."Номер фигуранта", "Имя","Фамилия","Кличка","Язык",  "Рост" ,   "Вес",   "Национальность",  "Гражданство"   FROM "Подозреваемые" AS P  INNER JOIN 
( SELECT DISTINCT "Номер фигуранта" FROM "Осужденные по у/д") AS O 
ON  P."Номер фигуранта" = O."Номер фигуранта"

SELECT A.Фамилия AS First, B.Фамилия AS Second, A.Кличка, A.Язык AS "Язык First", B.Язык  AS "Язык Second"
FROM "Преступники" A, "Преступники" B 
WHERE A."Номер фигуранта" < B."Номер фигуранта"
AND A.Кличка = B.Кличка
AND A.Язык <> B.Язык
 

 
/*
Поиск тех преступников, которые совершали преступления только в других странах
*/ 



  

CREATE VIEW "Пресутпники и номера преступлений" AS
SELECT P."Номер фигуранта",  P."Фамилия", P."Гражданство", "Уголовное дело"."Номер преступления"
FROM (("Подозреваемые" as P
INNER JOIN "Осужденные по у/д" as O ON P."Номер фигуранта" = O."Номер фигуранта")
INNER JOIN "Уголовное дело" ON "Уголовное дело"."Номер уголовного дела" = O."Номер уголовного дела"); 
#Получили таблицу, которая показывает какие преступления совершали преступники (не уголовные дела)

CREATE VIEW "Номера сов-их только в других странах" AS
SELECT DISTINCT "Фамилия" FROM "Пресутпники и номера преступлений" AS PP inner join Преступления AS P ON 
PP."Номер преступления" = P."Номер преступления" 
WHERE NOT PP."Номер фигуранта" IN ( 

SELECT "Номер фигуранта" FROM "Пресутпники и номера преступлений" AS PP inner join Преступления AS P ON 
PP."Номер преступления" = P."Номер преступления" 
AND PP.Гражданство = P."Место преступления"

)



 

/*
Поиск таких преступников, которые чаще других меняли преступную группировку.
*/

CREATE VIEW "Номера и смены" AS
SELECT "Номер фигуранта", COUNT(*)-1 AS "Смены группировок (кол-во раз)" 
FROM "Пребывание в группировках"
GROUP BY "Номер фигуранта" 

CREATE VIEW "номера и смены макс" AS
SELECT * FROM "Номера и смены" AS N 
WHERE N."Смены группировок (кол-во раз)" = (SELECT MAX("Смены группировок (кол-во раз)") AS MAX FROM "Номера и смены")

SELECT "Фамилия", "Смены группировок (кол-во раз)" FROM "номера и смены макс" AS F inner join "Преступники" AS S on 
F."Номер фигуранта" = S."Номер фигуранта"



/*
Поиск таких преступников, которые могли бы быть похожими друг на друга по наибольшему числу физических параметров 
*/

CREATE VIEW "Пары" AS
SELECT A.Фамилия AS Фамилия_1, B.Фамилия AS Фамилия_2, A.Рост AS Рост_1, B.Рост AS Рост_2, A.Вес AS Вес_1, B.Вес AS Вес_2, A.Национальность AS Н1,  B.Национальность AS Н2
FROM "Преступники" A, "Преступники" B
WHERE A."Номер фигуранта" < B."Номер фигуранта"

CREATE VIEW "Пары с признаками" AS
SELECT * ,
CASE
     WHEN   "Пары".Рост_1 = "Пары".Рост_2 OR "Пары".Вес_1 = "Пары".Вес_2 OR "Пары".Н1 = "Пары".Н2 THEN 1
    WHEN "Пары".Рост_1 = "Пары".Рост_2 AND "Пары".Вес_1 = "Пары".Вес_2 AND "Пары".Н1 = "Пары".Н2 THEN 3
    WHEN   ("Пары".Рост_1 = "Пары".Рост_2 AND "Пары".Вес_1 = "Пары".Вес_2) OR
           ("Пары".Вес_1 = "Пары".Вес_2 AND "Пары".Н1 = "Пары".Н2) OR
           ("Пары".Рост_1 = "Пары".Рост_2 AND "Пары".Н1 = "Пары".Н2) THEN 2
   
    ELSE 0
END AS priznaki
FROM "Пары"



SELECT * FROM "Пары с признаками"
WHERE priznaki IN (SELECT MAX(priznaki) FROM "Пары с признаками")
 
 