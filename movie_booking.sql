-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 06, 2024 at 06:07 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `movie_booking`
--

--
-- Dumping data for table `movies`
--

INSERT INTO `movies` (`id`, `title`, `description`, `genre`, `film_rating`, `duration`, `cast`, `image`, `start_date`, `end_date`, `price`) VALUES
(2, 'The Notebook', 'Noah, a poor man, falls in love with Allie who comes from wealth. They are forced to keep passion for each other aside due to societal pressure and a difference in the social stature of their families', 'Romance/ Drama', 'PG', '121', 'Ryan Gosling and Rachel McAdams', 'notebook.jpg', '2024-06-06', '2024-07-06', 200),
(3, 'Five Feet Apart', 'Stella and Will, both cystic fibrosis patients, develop an unlikely relationship despite the threat of cross-infection. However, they do away with their restrictions to experience togetherness.', 'Romance/ Drama', 'PG-13', '117', 'Haley Lu Richardson and Cole Sprouse', 'Five_Feet_Apart_(2019_poster).png', '2024-06-06', '2024-06-30', 200),
(4, 'The Fault in Our Stars', 'Teenager Hazel Grace\'s life changes when she meets Augustus Waters at a cancer support group. The two then embark on a life-changing journey which brings them even closer.', 'Romance/ Comedy', 'PG-13', '123', 'Shailene Woodley and Ansel Elgort', 'TFIOS.jpg', '2024-06-06', '2024-06-30', 200),
(5, 'Hello, Love, Goodbye', 'Two young individuals in Hong Kong, Joy and Ethan, fall in love but their personal goals and aspirations pose a danger to their relationship.', 'Romance/ Drama', 'PG-13', '118', 'Alden RIchards and Kathryn Bernardo', 'HLG.jpg', '2024-06-06', '2024-06-27', 200);

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `email`, `is_admin`, `is_pwd`, `is_senior`) VALUES
(1, 'admin', 'scrypt:32768:8:1$iKj3ojsN0RdNm5nh$2391c87faada42dd9bd47c9aecb8a32c81b5b1706e30dd99320c9d0321f14a46b74c42576da1cf73cb64d97190b7af99bb62343972676537fe5743d761f8b557', 'admin@gmail.com', 1, 0, 0),
(8, 'berting', 'scrypt:32768:8:1$Lc6NpndpYrXQCmOJ$8dde0a194af2ad817e5f0df3ad73ce1637bcdc92d01e7e6c73f6f313eeee1e5b490b1f4e4643a3cc549f743c47af79450ac21df1833c1bcd7a74f91d87853b9a', 'berting@gmail.com', 0, 0, 1);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
