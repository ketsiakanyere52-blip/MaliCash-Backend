-- MySQL dump 10.13  Distrib 8.0.46, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: malicash
-- ------------------------------------------------------
-- Server version	8.0.46

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `caisse`
--

DROP TABLE IF EXISTS `caisse`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `caisse` (
  `id_caisse` int NOT NULL AUTO_INCREMENT,
  `id_entreprise` int NOT NULL,
  `nom` varchar(100) NOT NULL,
  `solde_initial` decimal(12,2) DEFAULT '0.00',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_caisse`),
  KEY `id_entreprise` (`id_entreprise`),
  CONSTRAINT `caisse_ibfk_1` FOREIGN KEY (`id_entreprise`) REFERENCES `entreprise` (`id_entreprise`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `caisse`
--

LOCK TABLES `caisse` WRITE;
/*!40000 ALTER TABLE `caisse` DISABLE KEYS */;
INSERT INTO `caisse` (`id_caisse`, `id_entreprise`, `nom`, `solde_initial`, `created_at`) VALUES (1,1,'Ketsia',1000.00,'2026-08-02 04:48:35'),(2,3,'Kikusa',1000.00,'2026-08-04 05:43:01'),(3,4,'Principal',300.00,'2026-08-04 06:54:29');
/*!40000 ALTER TABLE `caisse` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `entree`
--

DROP TABLE IF EXISTS `entree`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `entree` (
  `id_entree` int NOT NULL AUTO_INCREMENT,
  `id_caisse` int NOT NULL,
  `libelle` varchar(255) NOT NULL,
  `montant` decimal(12,2) NOT NULL,
  `date_entree` datetime DEFAULT CURRENT_TIMESTAMP,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_entree`),
  KEY `id_caisse` (`id_caisse`),
  CONSTRAINT `entree_ibfk_1` FOREIGN KEY (`id_caisse`) REFERENCES `caisse` (`id_caisse`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `entree`
--

LOCK TABLES `entree` WRITE;
/*!40000 ALTER TABLE `entree` DISABLE KEYS */;
INSERT INTO `entree` (`id_entree`, `id_caisse`, `libelle`, `montant`, `date_entree`, `description`) VALUES (1,1,'Vente parcelle',1200.00,'2026-08-02 05:17:52',NULL),(2,1,'vente telephone',80.00,'2026-08-02 05:25:58',NULL),(3,1,'Vente tricot',70.00,'2026-08-02 07:26:32',NULL),(4,1,'Vente chaussettes',12.00,'2026-08-03 07:37:36',NULL),(5,1,'Vente biscuits',120.00,'2026-08-03 09:21:47',NULL),(6,2,'vente',20.00,'2026-08-04 06:08:34',NULL),(7,2,'vente habit',12.00,'2026-08-04 06:10:42',NULL),(8,3,'Vente parcelle',200.00,'2026-08-04 06:54:52',NULL);
/*!40000 ALTER TABLE `entree` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `entreprise`
--

DROP TABLE IF EXISTS `entreprise`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `entreprise` (
  `id_entreprise` int NOT NULL AUTO_INCREMENT,
  `nom` varchar(150) NOT NULL,
  `adresse` varchar(255) DEFAULT NULL,
  `telephone` varchar(50) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `password` varchar(100) DEFAULT NULL,
  `date_creation` datetime DEFAULT CURRENT_TIMESTAMP,
  `devise` varchar(10) NOT NULL DEFAULT 'USD',
  PRIMARY KEY (`id_entreprise`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `entreprise`
--

LOCK TABLES `entreprise` WRITE;
/*!40000 ALTER TABLE `entreprise` DISABLE KEYS */;
INSERT INTO `entreprise` (`id_entreprise`, `nom`, `adresse`, `telephone`, `email`, `password`, `date_creation`, `devise`) VALUES (1,'ketsia','goma','0990775139','ketsia@gmail.com','$2a$10$AfHwIt1LNw8NCzswP2TUPeN9LFCxFNYqPzWH8juPKB0YPSoWq3gDa','2026-07-30 03:28:15','USD'),(2,'kikusa','Goma','0990775139','kikusa@gmail.com','$2a$10$OVsHNNPyOT3w/3PsG6Hlxe0Mx6wA7/RnoqyuZ7QPMoL/bTGFTBx12','2026-08-04 04:14:42','CDF'),(3,'kikusa','Goma','09877622662','kikusakk@gmail.com','$2a$10$L7Ju2vVMtHNU3gOqfjBBSudZahpZcD8BRWYqC6aJ3cPAUwDIWE0j6','2026-08-04 04:31:45','CDF'),(4,'Kikusa kk','Katoyi','0990775139','kikusaw@gmail.com','$2a$10$JyS9XPhdmTUkBA1WMO7OCOdX8UgMjoLFN9QaAcT0tTmuolEBilkX6','2026-08-04 06:54:08','CDF');
/*!40000 ALTER TABLE `entreprise` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mouvement_caisse`
--

DROP TABLE IF EXISTS `mouvement_caisse`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mouvement_caisse` (
  `id_mouvement` int NOT NULL AUTO_INCREMENT,
  `id_caisse` int NOT NULL,
  `id_entree` int DEFAULT NULL,
  `id_sortie` int DEFAULT NULL,
  `type_mouvement` enum('ENTREE','SORTIE') NOT NULL,
  `libelle` varchar(255) NOT NULL,
  `montant` decimal(12,2) NOT NULL,
  `date_mouvement` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_mouvement`),
  KEY `id_caisse` (`id_caisse`),
  KEY `id_entree` (`id_entree`),
  KEY `id_sortie` (`id_sortie`),
  CONSTRAINT `mouvement_caisse_ibfk_1` FOREIGN KEY (`id_caisse`) REFERENCES `caisse` (`id_caisse`) ON DELETE CASCADE,
  CONSTRAINT `mouvement_caisse_ibfk_2` FOREIGN KEY (`id_entree`) REFERENCES `entree` (`id_entree`) ON DELETE SET NULL,
  CONSTRAINT `mouvement_caisse_ibfk_3` FOREIGN KEY (`id_sortie`) REFERENCES `sortie` (`id_sortie`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mouvement_caisse`
--

LOCK TABLES `mouvement_caisse` WRITE;
/*!40000 ALTER TABLE `mouvement_caisse` DISABLE KEYS */;
INSERT INTO `mouvement_caisse` (`id_mouvement`, `id_caisse`, `id_entree`, `id_sortie`, `type_mouvement`, `libelle`, `montant`, `date_mouvement`) VALUES (1,1,NULL,NULL,'ENTREE','Vente parcelle',1200.00,'2026-08-02 05:17:52'),(2,1,NULL,NULL,'SORTIE','Achat maison',120.00,'2026-08-02 05:18:12'),(3,1,NULL,NULL,'SORTIE','achat billetin',200.00,'2026-08-02 05:25:32'),(4,1,NULL,NULL,'ENTREE','vente telephone',80.00,'2026-08-02 05:25:58'),(5,1,NULL,NULL,'SORTIE','Transport',60.00,'2026-08-02 07:24:56'),(6,1,NULL,NULL,'ENTREE','Vente tricot',70.00,'2026-08-02 07:26:32'),(7,1,NULL,NULL,'ENTREE','Vente chaussettes',12.00,'2026-08-03 07:37:36'),(8,1,NULL,NULL,'SORTIE','Achat maison',100.00,'2026-08-03 08:57:55'),(9,1,NULL,NULL,'ENTREE','Vente biscuits',120.00,'2026-08-03 09:21:47'),(10,2,NULL,NULL,'ENTREE','vente',20.00,'2026-08-04 06:08:34'),(11,2,NULL,NULL,'SORTIE','achat',20.00,'2026-08-04 06:09:07'),(12,2,NULL,NULL,'ENTREE','vente habit',12.00,'2026-08-04 06:10:42'),(13,3,NULL,NULL,'ENTREE','Vente parcelle',200.00,'2026-08-04 06:54:52'),(14,3,NULL,NULL,'SORTIE','Achat maison',100.00,'2026-08-04 06:55:08');
/*!40000 ALTER TABLE `mouvement_caisse` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sortie`
--

DROP TABLE IF EXISTS `sortie`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sortie` (
  `id_sortie` int NOT NULL AUTO_INCREMENT,
  `id_caisse` int NOT NULL,
  `libelle` varchar(255) NOT NULL,
  `montant` decimal(12,2) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `date_sortie` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_sortie`),
  KEY `id_caisse` (`id_caisse`),
  CONSTRAINT `sortie_ibfk_1` FOREIGN KEY (`id_caisse`) REFERENCES `caisse` (`id_caisse`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sortie`
--

LOCK TABLES `sortie` WRITE;
/*!40000 ALTER TABLE `sortie` DISABLE KEYS */;
INSERT INTO `sortie` (`id_sortie`, `id_caisse`, `libelle`, `montant`, `description`, `date_sortie`) VALUES (1,1,'Achat maison',120.00,NULL,'2026-08-02 05:18:12'),(2,1,'achat billetin',200.00,NULL,'2026-08-02 05:25:32'),(3,1,'Transport',60.00,NULL,'2026-08-02 07:24:56'),(4,1,'Achat maison',100.00,NULL,'2026-08-03 08:57:55'),(5,2,'achat',20.00,NULL,'2026-08-04 06:09:07'),(6,3,'Achat maison',100.00,NULL,'2026-08-04 06:55:08');
/*!40000 ALTER TABLE `sortie` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `utilisateurs`
--

DROP TABLE IF EXISTS `utilisateurs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `utilisateurs` (
  `id_utilisateur` int NOT NULL AUTO_INCREMENT,
  `id_entreprise` int NOT NULL,
  `nom` varchar(100) NOT NULL,
  `postnom` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `date_creation` datetime DEFAULT CURRENT_TIMESTAMP,
  `email` varchar(100) NOT NULL,
  PRIMARY KEY (`id_utilisateur`),
  UNIQUE KEY `postnom` (`postnom`),
  UNIQUE KEY `email` (`email`),
  KEY `id_entreprise` (`id_entreprise`),
  CONSTRAINT `utilisateurs_ibfk_1` FOREIGN KEY (`id_entreprise`) REFERENCES `entreprise` (`id_entreprise`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `utilisateurs`
--

LOCK TABLES `utilisateurs` WRITE;
/*!40000 ALTER TABLE `utilisateurs` DISABLE KEYS */;
/*!40000 ALTER TABLE `utilisateurs` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-08-04  8:45:18
