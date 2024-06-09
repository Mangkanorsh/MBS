-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 09, 2024 at 02:12 AM
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

-- --------------------------------------------------------

--
-- Table structure for table `bookings`
--

CREATE TABLE `bookings` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `movie_id` int(11) NOT NULL,
  `movie_title` varchar(255) NOT NULL,
  `timeslot` varchar(20) NOT NULL,
  `date` date NOT NULL,
  `seats` varchar(100) NOT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `seat_quantity` int(11) DEFAULT NULL,
  `total_price` decimal(10,2) DEFAULT NULL,
  `status` varchar(10) DEFAULT 'unpaid'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `bookings`
--

INSERT INTO `bookings` (`id`, `user_id`, `movie_id`, `movie_title`, `timeslot`, `date`, `seats`, `price`, `seat_quantity`, `total_price`, `status`) VALUES
(56, 13, 6, 'The Notebook', '10:30am - 1:30pm', '2024-06-07', 'B5', NULL, 1, 160.00, 'paid'),
(57, 13, 6, 'The Notebook', '5:30pm - 8:30pm', '2024-06-07', 'D1', NULL, 1, 160.00, 'unpaid'),
(58, 10, 6, 'The Notebook', '5:30pm - 8:30pm', '2024-06-07', 'C2', NULL, 1, 160.00, 'paid'),
(59, 10, 7, 'The Fault in Our Stars', '2:00pm - 5:00pm', '2024-06-07', 'A10', NULL, 1, 160.00, 'paid'),
(60, 10, 8, 'Five Feet Apart', '10:30am - 1:30pm', '2024-06-07', 'A1', NULL, 1, 160.00, 'paid');

-- --------------------------------------------------------

--
-- Table structure for table `movies`
--

CREATE TABLE `movies` (
  `id` int(11) NOT NULL,
  `title` varchar(100) NOT NULL,
  `description` text NOT NULL,
  `genre` varchar(50) NOT NULL,
  `film_rating` varchar(10) NOT NULL,
  `duration` varchar(10) NOT NULL,
  `cast` text NOT NULL,
  `image` varchar(100) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `price` int(255) NOT NULL DEFAULT 200
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `movies`
--

INSERT INTO `movies` (`id`, `title`, `description`, `genre`, `film_rating`, `duration`, `cast`, `image`, `start_date`, `end_date`, `price`) VALUES
(6, 'The Notebook', 'Noah, a poor man, falls in love with Allie who comes from wealth. They are forced to keep passion for each other aside due to societal pressure and a difference in the social stature of their families\r\n', 'Romance/Drama', 'PG-13', '2h 1m', 'Ryan Gosling and Rachel McAdams', 'notebook.jpg', '2024-06-07', '2024-06-10', 200),
(7, 'The Fault in Our Stars', 'Teenager Hazel Grace\'s life changes when she meets Augustus Waters at a cancer support group. The two then embark on a life-changing journey which brings them even closer.\r\n', 'Comedy/Romance', 'PG-13', '2h 6m', 'Shailene Woodley and Ansel Elgort', 'TFIOS.jpg', '2024-06-07', '2024-06-10', 200),
(8, 'Five Feet Apart', 'Stella and Will, both cystic fibrosis patients, develop an unlikely relationship despite the threat of cross-infection. However, they do away with their restrictions to experience togetherness.\r\n', 'Romance/Drama', 'PG-13', '1h 57m', 'Haley Lu Richardson and Cole Sprouse', 'Five_Feet_Apart_(2019_poster).png', '2024-06-07', '2024-06-10', 200),
(9, '10 Things I Hate About You', 'As soon as Cameron, a newbie at Padua High School, finds Bianca, he falls in love with her. However, to date Bianca, he must first get her older sister Kate, a mean feminist, to date someone.\r\n', 'Comedy/Romance', 'PG-13', '1h 37m', 'Julia Stiles and Heath Ledger', '10_Things_I_Hate_About_You_film.jpg', '2024-06-07', '2024-06-10', 200),
(10, 'About time', 'Like all the men in his family, Tim Lake possesses the power to travel in time. With the advice of his father, he uses his special ability to pursue his romantic interest, Mary.', 'Romance/Sci-fi ', 'R', '2h 3m', 'Rachel McAdams and Domhnall Gleeson', 'about-time.jpg', '2024-06-07', '2024-06-10', 200),
(11, 'The Time Traveler\'s Wife', 'Henry DeTamble, a librarian, possesses a unique gene that lets him involuntarily travel through time. His wife, Claire Abshire, finds it difficult to cope with it.', 'Romance/Sci-fi', 'PG-13', '1h 48m', 'Eric Bana and Rachel McAdams', 'The Time Traveler\'s Wife.jpg', '2024-06-07', '2024-06-10', 200),
(12, '13 Going on 30', 'Jenna Rink makes an unusual wish on her birthday. Miraculously, her wish comes true and the 13-year-old Jenna wakes up the next day as a 30-year-old woman.', 'Comedy/Romance ', 'PG-13', '1h 37m', 'Mark Ruffalo and Rachel McAdams', '13 Going on 30.jpg', '2024-06-07', '2024-06-10', 200),
(13, '50 First Dates', 'Henry, against the idea of a committed romance with women, meets Lucy and is smitten with her. She too likes him. But unhappiness visits him when he realises she suffers from short-term memory loss.', 'Comedy/Romance', 'PG-13', '1h 39m', 'Adam Sandler and Drew Barrymore', '50 First Dates.jpg', '2024-06-07', '2024-06-10', 200),
(15, 'How to Lose a Guy in 10 Days', 'Andie, a magazine writer, meets her date Benjamin, a marketing executive, after she decides to write a special column while he makes a bet. Unaware of their real intentions, they fall in love.\r\n', 'Comedy', 'PG-13', '1h 50m', 'Kate Hudson and Matthew McConaughey', 'One_Piece_Film_Red_Visual_Poster.jpg', '2024-06-07', '2024-06-10', 200);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(100) NOT NULL,
  `is_admin` tinyint(1) NOT NULL DEFAULT 0,
  `is_pwd` tinyint(1) NOT NULL DEFAULT 0,
  `is_senior` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `email`, `is_admin`, `is_pwd`, `is_senior`) VALUES
(9, 'admin', 'scrypt:32768:8:1$UgYAztXSifYoZaWc$cb38e504f60ff40b5a1cf711d5032847332f33ca22b8a43d770064446450532226f66897acc5ffa47e3149341360ea4aeb2a6f7816d5f12be43cee77e2022bcb', 'admin@gmail.com', 1, 0, 0),
(10, 'user', 'scrypt:32768:8:1$ALxYc1CcIetH7l5k$2a8a0c2479c1cf31f7e0827470e54311bffa0dbfce28b9f1bc1fb911412c00918aa8817d913134e6aeda489c54ed741abe3fc664709919a408d009529f6cfc20', 'user@example.com', 0, 0, 1),
(11, 'jonel', 'scrypt:32768:8:1$809igWpf3toOMWDj$4431738f03e657359a813b2dcb353aa292417cb099e3c6b1b57140e520a77145bbd92df4d5088e9d06cd13fafccadbbc6987fd6351f172440f8281a330b4233f', 'jonel@example.com', 0, 0, 0),
(12, 'bugarto', 'scrypt:32768:8:1$VtVRZdwUg38f82jq$edf125acbb428d54f319ccb3b769fbd8b3541317810b6d873607da2c88cfede14034d26b556649bb5222bd71d047880b78694d89ec43b75c295f65b834277075', 'bugarto@example.com', 0, 1, 0),
(13, 'bebot', 'scrypt:32768:8:1$yHGcsrE70NHUlgj4$63fe19a189a8da87d689de7523f4a3a688ee297f290e63fbed3dcdef0285dea9adc4289131b51876a74e4d39cb540729f09863876d6bec7dc63cd22f0df1128b', 'bebot@gmail.com', 0, 0, 1);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `bookings`
--
ALTER TABLE `bookings`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `movie_id` (`movie_id`);

--
-- Indexes for table `movies`
--
ALTER TABLE `movies`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `bookings`
--
ALTER TABLE `bookings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=61;

--
-- AUTO_INCREMENT for table `movies`
--
ALTER TABLE `movies`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `bookings`
--
ALTER TABLE `bookings`
  ADD CONSTRAINT `bookings_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `bookings_ibfk_2` FOREIGN KEY (`movie_id`) REFERENCES `movies` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
