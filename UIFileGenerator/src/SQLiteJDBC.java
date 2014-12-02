import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;

public class SQLiteJDBC {
	public static void main(String args[]) {
		String fileName = "temp";
		Connection c = null;
		Statement stmt = null;
		JsonObject mainJsonObject = new JsonObject();
		try {
			Class.forName("org.sqlite.JDBC");
			c = DriverManager.getConnection("jdbc:sqlite:test.db");
			c.setAutoCommit(false);

			stmt = c.createStatement();
			ResultSet screenRS = stmt.executeQuery("SELECT * FROM ScreenTable;");
			while (screenRS.next()) {
				fileName = screenRS.getString("screen_name");
				String tableIds = screenRS.getString("screen_table_ids");
				String urls = screenRS.getString("screen_url");

				mainJsonObject.addProperty("screen_name", fileName);
				mainJsonObject.addProperty("screen_table_ids", tableIds);
				mainJsonObject.addProperty("screen_url", urls);

				JsonArray jsonArrayTable = new JsonArray();
				stmt = c.createStatement();
				ResultSet uiTableRS = stmt.executeQuery("SELECT * FROM UITablesTable WHERE table_id IN ("+tableIds+");");
				
				while (uiTableRS.next()) {
					JsonObject object = new JsonObject();
					object.addProperty("table_id", uiTableRS.getInt("table_id"));
					object.addProperty("gx", uiTableRS.getString("gx"));
					object.addProperty("gy", uiTableRS.getString("gy"));
					object.addProperty("gw", uiTableRS.getString("gw"));
					object.addProperty("gh", uiTableRS.getString("gh"));
					object.addProperty("css", uiTableRS.getString("css"));
					object.addProperty("pt_id", uiTableRS.getString("pt_id"));
					object.addProperty("type", uiTableRS.getString("type"));
					object.addProperty("name", uiTableRS.getString("name"));
					object.addProperty("scrollable", uiTableRS.getString("scrollable"));
					object.addProperty("component_ids", uiTableRS.getString("component_ids"));

					JsonArray jsonChildArray = new JsonArray();
					stmt = c.createStatement();
					ResultSet uiCompRS = stmt.executeQuery("SELECT * FROM UIComponentsTable WHERE components_id IN ("+uiTableRS.getString("component_ids")+");");
					while (uiCompRS.next()) {
						JsonObject objectChild = new JsonObject();
						
						objectChild.addProperty("components_id", uiCompRS.getInt("components_id"));
						objectChild.addProperty("name", uiCompRS.getString("name"));
						objectChild.addProperty("css", uiCompRS.getString("css"));
						objectChild.addProperty("type", uiCompRS.getString("type"));
						objectChild.addProperty("gx", uiCompRS.getString("gx"));
						objectChild.addProperty("gy", uiCompRS.getString("gy"));
						objectChild.addProperty("gw", uiCompRS.getString("gw"));
						objectChild.addProperty("gh", uiCompRS.getString("gh"));
						objectChild.addProperty("id", uiCompRS.getString("id"));
						objectChild.addProperty("behaviour", uiCompRS.getString("behaviour"));
						objectChild.addProperty("action_id", uiCompRS.getString("action_id"));
						objectChild.addProperty("target_id", uiCompRS.getString("target_id"));
						objectChild.addProperty("request_id", uiCompRS.getString("request_id"));
						
						jsonChildArray.add(objectChild);
					}
					uiCompRS.close();
					
					object.add("children", jsonChildArray);
					
					jsonArrayTable.add(object);
				}
				uiTableRS.close();
				
				mainJsonObject.add("Tables", jsonArrayTable);
				
			}
			screenRS.close();
			stmt.close();
			c.close();
		} catch (Exception e) {
			System.err.println(e.getClass().getName() + ": " + e.getMessage());
			System.exit(0);
		}
		System.out.println("Operation done successfully \nOutput Json::\n"+mainJsonObject);
		
		createFile(fileName, mainJsonObject.toString());
	}

	public static void createFile(String fileName, String content) {
		File file = new File(fileName+".json");
		try (FileOutputStream fop = new FileOutputStream(file)) {
			if (!file.exists()) {
				file.createNewFile();
			}
			
			byte[] contentInBytes = content.getBytes();
 
			fop.write(contentInBytes);
			fop.flush();
			fop.close();
 
			System.out.println(fileName +".json created successfully.");
 
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
}