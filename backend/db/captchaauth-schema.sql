CREATE TABLE IF NOT EXISTS "captchaauth" (
  "id" int(11) NOT NULL AUTO_INCREMENT,
  "methodOwner" varchar(30) COLLATE latin1_general_ci NOT NULL,
  "methodName" varchar(30) COLLATE latin1_general_ci NOT NULL,
  "solution" varchar(10) COLLATE latin1_general_ci NOT NULL,
  "solved" tinyint(1) NOT NULL,
  PRIMARY KEY ("id")
);
