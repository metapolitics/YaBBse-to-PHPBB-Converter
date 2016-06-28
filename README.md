# YaBBse-to-PHPBB-Converter

This SQL script is designed to port an old - circa 2006 - YaBBse forum database to a table structure used by phpbb v2. The script only scrapes the bare minimum (users, posts, topics and forum categories) and imports it ontop of an existing phpbb v2 database.

The SQL still contains original hardcoded database and table names. Replace if needed.

Original YaBBse database: intothep_originalforums
New phpBB database: phpbb_2

This script was used in conjunction with sweetmanC/Merge-phpBB-v3-databases.
i.e. converted a yabbse database to phpbbv2, upgrade phpbbv2 to phpbbv3 using tools provided by phpbb and then merged with a running forum.
