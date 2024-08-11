function onUpdateDatabase()
	print("> Updating database to version 26 (Info Storage LIB)")
	db.query("CREATE TABLE IF NOT EXISTS `player_misc` (`player_id` int(11) NOT NULL, `info` blob NOT NULL, UNIQUE KEY (`player_id`), FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE) ENGINE=InnoDB DEFAULT CHARSET=latin1;")
	return true
end