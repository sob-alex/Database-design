CREATE TABLE "Преступления" (
    "Номер преступления" SERIAL,
    "Место преступления" varchar(255) NOT NULL,
    "Описание" varchar(255),
    CONSTRAINT K1 PRIMARY KEY("Номер преступления")
);

CREATE TABLE "Подозреваемые" (
    "Номер фигуранта" SERIAL  ,
    "Имя" varchar(255) NOT NULL,
    "Фамилия" varchar(255) NOT NULL,
    "Кличка" varchar(255),
    "Язык" varchar(255),
    "Рост" int,
    "Вес" int,
    "Национальность" varchar(255),
    "Гражданство" varchar(255),
  
    CONSTRAINT K6 PRIMARY KEY("Номер фигуранта")
);

CREATE TABLE "Статьи" (
    "Номер статьи"  SERIAL,
    "Название" varchar(255) NOT NULL,
  
    CONSTRAINT K3 PRIMARY KEY("Номер статьи")
);

CREATE TABLE "Статьи особой тяжести" (
    "Номер статьи" int NOT NULL,
    CONSTRAINT K12 PRIMARY KEY("Номер статьи"),
    CONSTRAINT F11 FOREIGN KEY ("Номер статьи") REFERENCES "Статьи"("Номер статьи") 
    ON DELETE CASCADE
    ON UPDATE CASCADE
);



CREATE TABLE "Уголовное дело" (
    "Номер уголовного дела" SERIAL,
    "Номер преступления" int NOT NULL,
    "Дата возбуждения" date NOT NULL,
  CONSTRAINT K2  PRIMARY KEY ("Номер уголовного дела"),
  CONSTRAINT F1  FOREIGN KEY ("Номер преступления") REFERENCES "Преступления"("Номер преступления") 
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE "Статьи уг-го дела" (
    "Номер статьи" int NOT NULL,
    "Номер уголовного дела" int NOT NULL,
    CONSTRAINT K4 PRIMARY KEY ("Номер статьи","Номер уголовного дела"),
    CONSTRAINT F3 FOREIGN KEY ("Номер статьи") REFERENCES "Статьи"("Номер статьи")
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    CONSTRAINT F2 FOREIGN KEY ("Номер уголовного дела") REFERENCES "Уголовное дело"("Номер уголовного дела") 
    ON DELETE CASCADE
    ON UPDATE CASCADE
);


CREATE TABLE "Группировки" (
    "Номер группировки" SERIAL,
    "Название" varchar(255) NOT NULL,
     CONSTRAINT K15 PRIMARY KEY ("Номер группировки")
  
);

CREATE TABLE "Пребывание в группировках" (
    "Номер фигуранта" int NOT NULL,
    "Номер группировки" int NOT NULL,
    "Дата вступления" Date NOT NULL,
     CONSTRAINT K11 PRIMARY KEY ("Номер фигуранта","Номер группировки","Дата вступления"),
    CONSTRAINT F10 FOREIGN KEY ("Номер фигуранта") REFERENCES "Подозреваемые"("Номер фигуранта")
     ON DELETE CASCADE
    ON UPDATE CASCADE,
    CONSTRAINT F15 FOREIGN KEY ("Номер группировки") REFERENCES "Группировки"("Номер группировки")
     ON DELETE CASCADE
    ON UPDATE CASCADE

     
);

 

CREATE TABLE "История пребывания" (
    "Номер фигуранта" int NOT NULL,
    "Номер группировки" int NOT NULL,
    "Дата вступления" Date NOT NULL,
    "Дата выхода" Date NOT NULL,
     CONSTRAINT K14 PRIMARY KEY ("Номер фигуранта","Номер группировки","Дата вступления","Дата выхода"),
    CONSTRAINT F14 FOREIGN KEY ("Номер фигуранта", "Номер группировки" , "Дата вступления") REFERENCES "Пребывание в группировках"("Номер фигуранта", "Номер группировки" , "Дата вступления")
     ON DELETE CASCADE
    ON UPDATE CASCADE
    

     
);





CREATE TABLE "Архив уголовных дел" (
    "Номер уголовного дела" int NOT NULL,
    "Дата окончания" date NOT NULL,
   CONSTRAINT K5 PRIMARY KEY ("Номер уголовного дела"),
   CONSTRAINT F4 FOREIGN KEY ("Номер уголовного дела") REFERENCES "Уголовное дело"("Номер уголовного дела") 
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE "Подозреваемые по у/д" (
    "Номер фигуранта" int NOT NULL,
    "Номер уголовного дела" int NOT NULL,
    CONSTRAINT K7 PRIMARY KEY ("Номер фигуранта","Номер уголовного дела"),
    CONSTRAINT F6 FOREIGN KEY ("Номер фигуранта") REFERENCES "Подозреваемые"("Номер фигуранта")
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    CONSTRAINT F5 FOREIGN KEY ("Номер уголовного дела") REFERENCES "Уголовное дело"("Номер уголовного дела")
    ON DELETE CASCADE
    ON UPDATE CASCADE  
);

 

CREATE TABLE "Осужденные по у/д" (
    "Номер фигуранта" int NOT NULL,
    "Номер уголовного дела" int NOT NULL,
    CONSTRAINT K10 PRIMARY KEY ("Номер фигуранта","Номер уголовного дела"),
    CONSTRAINT F9 FOREIGN KEY ("Номер фигуранта","Номер уголовного дела") REFERENCES "Подозреваемые по у/д"("Номер фигуранта","Номер уголовного дела")  
    ON DELETE CASCADE
    ON UPDATE CASCADE
);


CREATE TABLE "По статьям" (
    "Номер фигуранта" int NOT NULL,
    "Номер уголовного дела" int NOT NULL,
    "Номер статьи" int NOT NULL,
    CONSTRAINT K13 PRIMARY KEY ("Номер фигуранта","Номер уголовного дела","Номер статьи"),
  CONSTRAINT F12 FOREIGN KEY ("Номер фигуранта","Номер уголовного дела") REFERENCES "Подозреваемые по у/д"("Номер фигуранта","Номер уголовного дела")
    ON DELETE CASCADE
    ON UPDATE CASCADE,
CONSTRAINT F13 FOREIGN KEY ("Номер статьи","Номер уголовного дела") REFERENCES "Статьи уг-го дела"("Номер статьи","Номер уголовного дела")
    ON DELETE CASCADE
    ON UPDATE CASCADE
);