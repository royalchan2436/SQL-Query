
import java.util.ArrayList;
import java.sql.*;
import java.util.Collections;

public class Assignment2 {

	/* A connection to the database */
	private Connection connection;

	/**
	 * Empty constructor. There is no need to modify this. 
	 */
	public Assignment2() {
		try {
			Class.forName("org.postgresql.Driver");
		} catch (ClassNotFoundException e) {
			System.err.println("Failed to find the JDBC driver");
		}
	}

	/**
	* Establishes a connection to be used for this session, assigning it to
	* the instance variable 'connection'.
	*
	* @param  url       the url to the database
	* @param  username  the username to connect to the database
	* @param  password  the password to connect to the database
	* @return           true if the connection is successful, false otherwise
	*/
	public boolean connectDB(String url, String username, String password) {
		try {
			this.connection = DriverManager.getConnection(url, username, password);
			return true;
		} catch (SQLException se) {
			System.err.println("SQL Exception. <Message>: " + se.getMessage());
			return false;
		}
	}

	/**
	* Closes the database connection.
	*
	* @return true if the closing was successful, false otherwise
	*/
	public boolean disconnectDB() {
		try {
			this.connection.close();
		return true;
		} catch (SQLException se) {
			System.err.println("SQL Exception. <Message>: " + se.getMessage());
			return false;
		}
	}

	/**
	 * Returns a sorted list of the names of all musicians and bands 
	 * who released at least one album in a given genre. 
	 *
	 * Returns an empty list if no such genre exists or no artist matches.
	 *
	 * NOTE:
	 *    Use Collections.sort() to sort the names in ascending
	 *    alphabetical order.
	 *
	 * @param genre  the genre to find artists for
	 * @return       a sorted list of artist names
	 */
	public ArrayList<String> findArtistsInGenre(String genre) {
	    ArrayList <String> a2 = new ArrayList<String> ();
            try{

		Statement stmt = this.connection.createStatement();
		stmt.execute("SET search_path TO artistdb;");
		String sql = "SELECT DISTINCT a.name FROM Album al INNER JOIN Artist a ON al.artist_id = a.artist_id WHERE al.genre_id = (SELECT genre_id FROM Genre WHERE genre = \'" + genre + "\');";
		ResultSet rs = stmt.executeQuery(sql);
		while(rs.next()){
		    a2.add(rs.getString(1));
		}
		rs.close();
		stmt.close();
		Collections.sort(a2);
            }catch(Exception se){
                se.printStackTrace();
            }
            return a2;
	}

	/**
	 * Returns a sorted list of the names of all collaborators
	 * (either as a main artist or guest) for a given artist.  
	 *
	 * Returns an empty list if no such artist exists or the artist 
	 * has no collaborators.
	 *
	 * NOTE:
	 *    Use Collections.sort() to sort the names in ascending
	 *    alphabetical order.
	 *
	 * @param artist  the name of the artist to find collaborators for
	 * @return        a sorted list of artist names
	 */
	public ArrayList<String> findCollaborators(String artist) {
                ArrayList<String> a2 = new ArrayList<String> ();
                try{
                    Statement stmt = this.connection.createStatement();
                    stmt.execute("SET search_path TO artistdb;");
                    stmt.execute("CREATE VIEW T1 AS SELECT c.artist2 FROM Collaboration c INNER JOIN Artist a ON c.artist1 = a.artist_id WHERE a.name = \'"+ artist + "\';");
                    stmt.execute("CREATE VIEW T2 AS SELECT c.artist1 FROM Collaboration c INNER JOIN Artist a ON c.artist2 = a.artist_id WHERE a.name = \'"+ artist + "\';");
                    stmt.execute("CREATE VIEW T3 AS (SELECT * FROM T1) UNION (SELECT * FROM T2);");
                    ResultSet rs = stmt.executeQuery("SELECT DISTINCT a.name FROM T3 INNER JOIN Artist a ON T3.artist2 = a.artist_id");
                    while(rs.next()){
                          a2.add(rs.getString(1));
                    }
                    stmt.execute("DROP VIEW T3 CASCADE;");
                    stmt.execute("DROP VIEW T2 CASCADE;");
                    stmt.execute("DROP VIEW T1 CASCADE;");
                    rs.close();
                    stmt.close();
                    Collections.sort(a2);
                }catch(Exception se){
                    se.printStackTrace();
                }
                return a2;
	}


	/**
	 * Returns a sorted list of the names of all songwriters
	 * who wrote songs for a given artist (the given artist is excluded).  
	 *
	 * Returns an empty list if no such artist exists or the artist 
	 * has no other songwriters other than themself.
	 *
	 * NOTE:
	 *    Use Collections.sort() to sort the names in ascending
	 *    alphabetical order.
	 *
	 * @param artist  the name of the artist to find the songwriters for
	 * @return        a sorted list of songwriter names
	 */
	public ArrayList<String> findSongwriters(String artist) {
                ArrayList<String> a2 = new ArrayList<String> ();
                try{
                     Statement stmt = connection.createStatement();
                     stmt.execute("SET search_path TO artistdb;");
                     stmt.execute("CREATE VIEW E1 AS SELECT s.songwriter_id, b.album_id FROM Song s INNER JOIN BelongsToAlbum b ON s.song_id = b.song_id;");
                     stmt.execute("CREATE VIEW E4 AS SELECT E1.songwriter_id, a.artist_id, a.album_id FROM E1 INNER JOIN Album a ON E1.album_id = a.album_id;");
                     stmt.execute("CREATE VIEW E2 AS SELECT b.album_id FROM Album b INNER JOIN Artist a ON b.artist_id = a.artist_id WHERE a.name = \'"+artist+"\';");
                     stmt.execute("CREATE VIEW E3 AS SELECT E4.songwriter_id FROM E2 INNER JOIN E4 ON E2.album_id = E4.album_id;");
                     ResultSet rs = stmt.executeQuery("SELECT a.name FROM E3 INNER JOIN Artist a ON E3.songwriter_id = a.artist_id WHERE a.name <> \'"+artist+"\';");
                     while(rs.next()){
                        a2.add(rs.getString(1));
                     }
                     rs.close();
                     stmt.execute("DROP VIEW E3 CASCADE;");
                     stmt.execute("DROP VIEW E2 CASCADE;");
                     stmt.execute("DROP VIEW E4 CASCADE;");
                     stmt.execute("DROP VIEW E1 CASCADE;");
                     stmt.close();
                     Collections.sort(a2);
                }catch(Exception se){
                     se.printStackTrace();
                }
                return a2;
	}

	/**
	 * Returns a sorted list of the names of all acquaintances
	 * for a given pair of artists.  
	 *
	 * Returns an empty list if either of the artists does not exist, 
	 * or they have no acquaintances.
	 *
	 * NOTE:
	 *    Use Collections.sort() to sort the names in ascending
	 *    alphabetical order.
	 *
	 * @param artist1  the name of the first artist to find acquaintances for
	 * @param artist2  the name of the second artist to find acquaintances for
	 * @return         a sorted list of artist names
	 */
	public ArrayList<String> findAcquaintances(String artist1, String artist2) {
                
	    ArrayList<String> a2 = new ArrayList<String> ();
            a2 = findCollaborators(artist1);
            a2.addAll(findCollaborators(artist2));
	    a2.addAll(findSongwriters(artist1));
	    a2.addAll(findSongwriters(artist2));
            ArrayList<String> ans = new ArrayList<String> ();
            for(String item: a2){
                if(!ans.contains(item)){
		    ans.add(item);
		}
	    }
            Collections.sort(ans);
	    return ans;
	}
	
	
	public static void main(String[] args) {
		
		Assignment2 a2 = new Assignment2();
		
		/* TODO: Change the database name and username to your own here. */
		a2.connectDB("jdbc:postgresql://localhost:5432/csc343h-g3chenro",
		             "g3chenro",
		             "");
		
                System.err.println("\n----- ArtistsInGenre -----");
                ArrayList<String> res = a2.findArtistsInGenre("Rock");
                for (String s : res) {
                  System.err.println(s);
                }
                
		System.err.println("\n----- Collaborators -----");
		res = a2.findCollaborators("Michael Jackson");
		for (String s : res) {
		  System.err.println(s);
		}
		
		System.err.println("\n----- Songwriters -----");
	        res = a2.findSongwriters("Justin Bieber");
		for (String s : res) {
		  System.err.println(s);
		}
		
		System.err.println("\n----- Acquaintances -----");
		res = a2.findAcquaintances("Jaden Smith", "Miley Cyrus");
		for (String s : res) {
		  System.err.println(s);
		}
                
		
		a2.disconnectDB();
	}
}
